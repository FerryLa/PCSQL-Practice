#!/usr/bin/env python3
"""
Battery Factory Game - Redash 자동 설정 스크립트
Redash에 데이터소스, 쿼리, 시각화, 대시보드를 자동 생성합니다.

사용법:
    1. Docker Compose로 전체 스택 구동
    2. Redash 초기 설정 완료 (http://localhost:5000 에서 관리자 계정 생성)
    3. API Key를 획득하여 아래 스크립트 실행
    
    python setup_redash.py --api-key YOUR_API_KEY
"""

import argparse
import time
import requests

REDASH_URL = "http://localhost:5000"
GAME_DB_CONFIG = {
    "host": "game-db",       # docker network 내부 호스트명
    "port": 5432,
    "dbname": "battery_game",
    "user": "battery_admin",
    "password": "battery_secure_2024",
}


def api(method, path, api_key, json_data=None):
    """Redash API 헬퍼"""
    headers = {"Authorization": f"Key {api_key}", "Content-Type": "application/json"}
    url = f"{REDASH_URL}/api/{path}"
    resp = getattr(requests, method)(url, headers=headers, json=json_data, timeout=30)
    if resp.status_code not in (200, 201):
        print(f"  ⚠️  {method.upper()} {path} → {resp.status_code}: {resp.text[:200]}")
        return None
    return resp.json()


def create_data_source(api_key):
    """Game DB를 Redash 데이터소스로 등록"""
    print("\n📦 1. 데이터소스 생성: battery_game (PostgreSQL)")
    result = api("post", "data_sources", api_key, {
        "name": "Battery Game DB",
        "type": "pg",
        "options": {
            "host": GAME_DB_CONFIG["host"],
            "port": GAME_DB_CONFIG["port"],
            "dbname": GAME_DB_CONFIG["dbname"],
            "user": GAME_DB_CONFIG["user"],
            "password": GAME_DB_CONFIG["password"],
        },
    })
    if result:
        print(f"  ✅ 데이터소스 ID: {result['id']}")
        return result["id"]
    return None


def create_query(api_key, ds_id, name, query_sql, description=""):
    """Redash 쿼리 생성"""
    result = api("post", "queries", api_key, {
        "name": name,
        "query": query_sql,
        "data_source_id": ds_id,
        "description": description,
        "schedule": None,
    })
    if result:
        query_id = result["id"]
        # 쿼리 실행하여 결과 캐시
        api("post", f"queries/{query_id}/results", api_key, {"max_age": 0})
        time.sleep(1)
        print(f"  ✅ 쿼리 '{name}' (ID: {query_id})")
        return query_id
    return None


def create_visualization(api_key, query_id, name, viz_type, options):
    """Redash 시각화 생성"""
    result = api("post", "visualizations", api_key, {
        "query_id": query_id,
        "name": name,
        "type": viz_type,
        "options": options,
    })
    if result:
        print(f"    📊 시각화 '{name}' (ID: {result['id']})")
        return result["id"]
    return None


def create_dashboard(api_key, name):
    """대시보드 생성"""
    result = api("post", "dashboards", api_key, {"name": name})
    if result:
        print(f"  ✅ 대시보드 '{name}' (ID: {result['id']}, slug: {result.get('slug', '')})")
        return result
    return None


def add_widget(api_key, dashboard_id, viz_id=None, text_content=None, width=1, col=0, row=0, size_x=3, size_y=8):
    """대시보드에 위젯 추가"""
    payload = {
        "dashboard_id": dashboard_id,
        "options": {
            "parameterMappings": {},
            "isHidden": False,
            "position": {
                "autoHeight": True,
                "sizeX": size_x,
                "sizeY": size_y,
                "minSizeX": 1,
                "maxSizeX": 6,
                "minSizeY": 1,
                "maxSizeY": 1000,
                "col": col,
                "row": row,
            },
        },
        "width": width,
    }
    if viz_id:
        payload["visualization_id"] = viz_id
    if text_content:
        payload["text"] = text_content

    return api("post", "widgets", api_key, payload)


def setup_all(api_key):
    """전체 Redash 설정 실행"""
    print("=" * 60)
    print("🔋 Battery Factory - Redash 자동 설정")
    print("=" * 60)

    # ─── 1. Data Source ───
    ds_id = create_data_source(api_key)
    if not ds_id:
        print("❌ 데이터소스 생성 실패. 이미 존재하는지 확인하세요.")
        # 기존 데이터소스에서 찾기
        sources = api("get", "data_sources", api_key)
        if sources:
            for s in sources:
                if "battery" in s.get("name", "").lower() or "game" in s.get("name", "").lower():
                    ds_id = s["id"]
                    print(f"  ℹ️  기존 데이터소스 사용: ID {ds_id}")
                    break
        if not ds_id:
            print("❌ 데이터소스를 찾을 수 없습니다. 종료합니다.")
            return

    # ─── 2. Queries & Visualizations ───
    print("\n📝 2. 쿼리 & 시각화 생성")
    queries = {}
    viz_ids = {}

    # Q1: 리더보드
    q_id = create_query(api_key, ds_id, "🏆 리더보드 (Top 20)", """
SELECT
    rank_by_score AS "순위",
    nickname AS "닉네임",
    best_score AS "최고점수",
    best_grade AS "등급",
    total_games AS "게임수",
    ROUND(best_energy::numeric, 0) AS "에너지",
    ROUND(best_stability::numeric, 0) AS "안전성",
    ROUND(best_productivity::numeric, 0) AS "생산성",
    ROUND(weighted_kpi::numeric, 1) AS "KPI종합"
FROM leaderboard
ORDER BY rank_by_score
LIMIT 20;
    """, "플레이어 종합 랭킹")
    if q_id:
        queries["leaderboard"] = q_id

    # Q2: 공정별 성과
    q_id = create_query(api_key, ds_id, "📊 공정별 평균 성과", """
SELECT * FROM v_stage_performance;
    """, "전체 플레이어의 공정별 평균 성과")
    if q_id:
        queries["stage_perf"] = q_id
        # 차트 시각화
        create_visualization(api_key, q_id, "공정별 평균 점수", "CHART", {
            "globalSeriesType": "column",
            "xAxis": {"type": "-", "labels": {"enabled": True}},
            "yAxis": [{"type": "linear"}],
            "columnMapping": {
                "stage_name": "x",
                "avg_rating": "y",
                "avg_energy": "y",
                "avg_stability": "y",
                "avg_productivity": "y",
            },
            "seriesOptions": {},
            "legend": {"enabled": True},
        })

    # Q3: KPI 트렌드 (최근 세션)
    q_id = create_query(api_key, ds_id, "📈 KPI 트렌드 (최근 세션)", """
SELECT
    kh.stage_number AS "스테이지",
    ROUND(kh.energy::numeric, 1) AS "에너지밀도",
    ROUND(kh.stability::numeric, 1) AS "안전성",
    ROUND(kh.productivity::numeric, 1) AS "생산성",
    kh.event_type AS "이벤트"
FROM kpi_history kh
WHERE kh.session_id = (
    SELECT id FROM game_sessions ORDER BY started_at DESC LIMIT 1
)
ORDER BY kh.recorded_at;
    """, "가장 최근 게임 세션의 KPI 변화 추이")
    if q_id:
        queries["kpi_trend"] = q_id
        create_visualization(api_key, q_id, "KPI 추이 차트", "CHART", {
            "globalSeriesType": "line",
            "xAxis": {"type": "-", "labels": {"enabled": True}},
            "yAxis": [{"type": "linear"}],
            "columnMapping": {
                "스테이지": "x",
                "에너지밀도": "y",
                "안전성": "y",
                "생산성": "y",
            },
            "seriesOptions": {
                "에너지밀도": {"type": "line", "color": "#e74c3c"},
                "안전성": {"type": "line", "color": "#3498db"},
                "생산성": {"type": "line", "color": "#2ecc71"},
            },
            "legend": {"enabled": True},
        })

    # Q4: 불량 분석
    q_id = create_query(api_key, ds_id, "🔍 불량 유형별 분석", """
SELECT * FROM v_defect_analysis;
    """, "불량 유형별 발생 빈도 및 해결률")
    if q_id:
        queries["defect"] = q_id
        create_visualization(api_key, q_id, "불량 유형 분포", "CHART", {
            "globalSeriesType": "pie",
            "columnMapping": {"defect_name": "x", "occurrence_count": "y"},
        })

    # Q5: 전략별 비교
    q_id = create_query(api_key, ds_id, "🧠 전략별 성과 비교", """
SELECT * FROM v_strategy_comparison;
    """, "사용 전략별 평균 점수 및 KPI 비교")
    if q_id:
        queries["strategy"] = q_id
        create_visualization(api_key, q_id, "전략별 평균 KPI", "CHART", {
            "globalSeriesType": "column",
            "xAxis": {"type": "-"},
            "columnMapping": {
                "strategy_used": "x",
                "avg_energy": "y",
                "avg_stability": "y",
                "avg_productivity": "y",
            },
            "legend": {"enabled": True},
        })

    # Q6: 점수 분포
    q_id = create_query(api_key, ds_id, "📉 점수 분포 히스토그램", """
SELECT
    CASE
        WHEN total_score >= 4000 THEN 'S (4000+)'
        WHEN total_score >= 3000 THEN 'A (3000-3999)'
        WHEN total_score >= 2000 THEN 'B (2000-2999)'
        WHEN total_score >= 1000 THEN 'C (1000-1999)'
        ELSE 'D (<1000)'
    END AS "등급대",
    COUNT(*) AS "게임수",
    ROUND(AVG(yield_rate)::numeric, 1) AS "평균수율"
FROM game_sessions
WHERE ended_at IS NOT NULL
GROUP BY 1
ORDER BY 1;
    """, "전체 게임의 점수 등급 분포")
    if q_id:
        queries["score_dist"] = q_id

    # Q7: 수율 트렌드
    q_id = create_query(api_key, ds_id, "📊 일별 평균 수율 트렌드", """
SELECT
    DATE(started_at) AS "날짜",
    COUNT(*) AS "게임수",
    ROUND(AVG(total_score)::numeric, 0) AS "평균점수",
    ROUND(AVG(yield_rate)::numeric, 1) AS "평균수율",
    ROUND(AVG(final_energy)::numeric, 1) AS "평균에너지",
    ROUND(AVG(final_stability)::numeric, 1) AS "평균안전성"
FROM game_sessions
WHERE ended_at IS NOT NULL
GROUP BY DATE(started_at)
ORDER BY "날짜" DESC
LIMIT 30;
    """, "최근 30일간 일별 게임 통계")
    if q_id:
        queries["daily_trend"] = q_id

    # ─── 3. Dashboard ───
    print("\n🎨 3. 대시보드 생성")

    # 종합 대시보드
    dash = create_dashboard(api_key, "🔋 Battery Factory - 종합 대시보드")
    if dash:
        dash_id = dash["id"]
        # 타이틀 텍스트
        add_widget(api_key, dash_id,
                   text_content="# 🔋 Battery Factory 품질관리 대시보드\n실시간 배터리 제조 시뮬레이션 데이터 분석",
                   col=0, row=0, size_x=6, size_y=3)

        # 리더보드는 기본 테이블 viz 사용 (query의 첫 번째 viz)
        if "leaderboard" in queries:
            # 기본 테이블 시각화 ID를 가져오기
            q_detail = api("get", f"queries/{queries['leaderboard']}", api_key)
            if q_detail and q_detail.get("visualizations"):
                add_widget(api_key, dash_id, viz_id=q_detail["visualizations"][0]["id"],
                           col=0, row=3, size_x=6, size_y=10)

    # KPI 분석 대시보드
    dash = create_dashboard(api_key, "📈 KPI 분석 대시보드")
    if dash:
        dash_id = dash["id"]
        add_widget(api_key, dash_id,
                   text_content="# 📈 KPI 트렌드 & 전략 분석\n에너지 밀도 / 안전성 / 생산성 트레이드오프 분석",
                   col=0, row=0, size_x=6, size_y=3)

    # 불량 분석 대시보드
    dash = create_dashboard(api_key, "🔍 불량 분석 리포트")
    if dash:
        dash_id = dash["id"]
        add_widget(api_key, dash_id,
                   text_content="# 🔍 불량 분석 리포트\n불량 유형, 해결률, KPI 영향도 분석",
                   col=0, row=0, size_x=6, size_y=3)

    # ─── 완료 ───
    print("\n" + "=" * 60)
    print("✅ Redash 설정 완료!")
    print(f"   📊 Redash UI: {REDASH_URL}")
    print(f"   🎮 Game API:  http://localhost:5001")
    print(f"   📋 생성된 쿼리: {len(queries)}개")
    print("=" * 60)
    print("\n다음 단계:")
    print("  1. Redash UI에서 대시보드 레이아웃 조정")
    print("  2. 대시보드를 공개(Public)로 설정하여 iframe 임베드 가능")
    print("  3. React 게임에서 /api/redash/dashboard-url로 URL 획득")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Battery Factory - Redash Setup")
    parser.add_argument("--api-key", required=True, help="Redash Admin API Key")
    parser.add_argument("--redash-url", default=REDASH_URL, help="Redash URL")
    args = parser.parse_args()

    REDASH_URL = args.redash_url
    setup_all(args.api_key)
