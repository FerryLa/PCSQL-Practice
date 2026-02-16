# 🔋 Battery Factory Game — Full Stack 구축 가이드

## 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Compose Network                     │
│                                                               │
│  ┌──────────┐     ┌──────────┐     ┌──────────────────────┐ │
│  │  React    │────▶│ FastAPI  │────▶│  PostgreSQL          │ │
│  │  Game     │     │ :5001    │     │  (battery_game)      │ │
│  │  Client   │◀────│          │     │  :5433               │ │
│  └──────────┘     └──────────┘     └──────────┬───────────┘ │
│                         │                      │              │
│                         │              ┌───────▼───────────┐ │
│                         │              │  Redash Server     │ │
│                         └─────────────▶│  :5000             │ │
│                                        │  (쿼리 & 대시보드) │ │
│                                        └───────┬───────────┘ │
│                                                │              │
│  ┌──────────┐     ┌──────────┐     ┌──────────▼───────────┐ │
│  │  Redis   │◀────│ Redash   │     │  PostgreSQL          │ │
│  │          │     │ Worker   │     │  (redash 내부 DB)     │ │
│  └──────────┘     └──────────┘     └──────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 데이터 흐름

```
[게임 플레이]
     │
     ▼
[React → POST /api/games/end]  →  [FastAPI]  →  [PostgreSQL game_db]
                                                       │
     ┌─────────────────────────────────────────────────┘
     ▼
[Redash가 game_db에 SQL 쿼리 실행]
     │
     ▼
[시각화 & 대시보드 생성]
     │
     ▼
[Public Dashboard URL → iframe으로 게임 내 임베드]
  또는
[FastAPI /api/redash/embed/{query_id} → JSON 프록시]
```

---

## 🚀 Quick Start

### 사전 요구사항

- Docker Desktop (Docker Compose v2 포함)
- Python 3.10+ (Redash 설정 스크립트용)
- Node.js 18+ (React 프론트엔드용, 선택)

### Step 1: 전체 스택 부팅

```bash
cd battery-factory
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh
```

또는 수동:

```bash
docker compose up -d --build
# Redash DB 초기화 (최초 1회)
docker compose run --rm redash-server create_db
```

### Step 2: Redash 초기 설정

1. **http://localhost:5000** 접속
2. 관리자 계정 생성 (이메일, 비밀번호 설정)
3. 우측 상단 프로필 → **API Key** 복사

### Step 3: Redash 자동 구성

```bash
pip install requests
python scripts/setup_redash.py --api-key YOUR_API_KEY_HERE
```

이 스크립트가 자동으로 생성하는 것:
- ✅ 데이터소스 연결 (game_db → Redash)
- ✅ 7개 분석 쿼리 (리더보드, KPI 트렌드, 불량 분석 등)
- ✅ 차트/테이블 시각화
- ✅ 3개 대시보드 (종합, KPI 분석, 불량 리포트)

### Step 4: .env 파일에 API Key 설정

```bash
# .env
REDASH_API_KEY=your_actual_key_here
```

```bash
docker compose restart backend
```

### Step 5: 대시보드 공개 설정 (iframe 임베드용)

1. Redash에서 대시보드 열기
2. 공유 버튼 → **"공개 URL 생성"** 클릭
3. 생성된 Public Token URL을 React 게임에서 iframe으로 표시

---

## 📊 Redash 대시보드 구성

### 1. 종합 대시보드 (`battery-overview`)

| 위젯 | 쿼리 | 시각화 |
|------|------|--------|
| 리더보드 | `SELECT * FROM leaderboard` | Table |
| 일별 트렌드 | 일별 평균 점수/수율 | Line Chart |
| 점수 분포 | 등급대별 게임 수 | Bar Chart |

### 2. KPI 분석 대시보드 (`kpi-analysis`)

| 위젯 | 쿼리 | 시각화 |
|------|------|--------|
| KPI 트렌드 | 최근 세션 KPI 변화 | Multi-Line Chart |
| 공정별 성과 | 스테이지별 평균 | Grouped Bar |
| 전략별 비교 | strategy_comparison 뷰 | Stacked Column |

### 3. 불량 분석 대시보드 (`defect-report`)

| 위젯 | 쿼리 | 시각화 |
|------|------|--------|
| 불량 유형 분포 | defect_analysis 뷰 | Pie Chart |
| 해결률 | 유형별 resolution_rate | Bar Chart |
| KPI 영향도 | 유형별 avg_kpi_impact | Horizontal Bar |

---

## 🎮 게임 ↔ Redash 연동 방법

### 방법 1: iframe 임베드 (권장)

```jsx
// React 게임 내에서
<iframe
  src="http://localhost:5000/public/dashboards/{token}"
  width="100%"
  height="600"
  frameBorder="0"
/>
```

### 방법 2: API 프록시 (CORS 우회)

```jsx
// FastAPI가 Redash 결과를 프록시
const response = await fetch('/api/redash/embed/1');
const data = await response.json();
// data.query_result.data.rows → 차트 데이터로 활용
```

### 방법 3: 직접 DB 쿼리 (실시간)

```jsx
// FastAPI analytics 엔드포인트 직접 호출
const kpiTrend = await fetch('/api/analytics/kpi-trend/123');
const stagePerf = await fetch('/api/analytics/stage-performance');
```

---

## 🗄️ 데이터베이스 스키마

### 핵심 테이블

| 테이블 | 설명 | 주요 컬럼 |
|--------|------|-----------|
| `players` | 플레이어 | nickname, best_score, best_grade, KPI 최고기록 |
| `game_sessions` | 게임 세션 | total_score, grade, KPI, yield_rate, strategy |
| `stage_results` | 스테이지별 결과 | rating, stars, KPI 스냅샷, combo, fever |
| `kpi_history` | KPI 시계열 | energy, stability, productivity, event_type |
| `defect_log` | 불량 이력 | defect_type, severity, resolved, kpi_impact |
| `upgrade_log` | 업그레이드 구매 | upgrade_id, cost, kpi_target, boost_value |
| `strategy_log` | 전략 변경 | strategy, stage_number |

### 분석 뷰

| 뷰 | 용도 |
|----|------|
| `leaderboard` | Materialized View, 랭킹 |
| `v_kpi_trend` | KPI 시계열 분석 |
| `v_stage_performance` | 공정별 성과 집계 |
| `v_defect_analysis` | 불량 유형별 분석 |
| `v_strategy_comparison` | 전략별 비교 |

---

## 🔌 API 엔드포인트

### 플레이어

| Method | Path | 설명 |
|--------|------|------|
| POST | `/api/players` | 플레이어 생성/조회 |
| GET | `/api/players/{id}` | 플레이어 정보 |

### 게임 세션

| Method | Path | 설명 |
|--------|------|------|
| POST | `/api/games/start` | 게임 시작 |
| POST | `/api/games/end` | 게임 종료 (전체 결과 저장) |
| POST | `/api/games/strategy` | 전략 변경 기록 |
| POST | `/api/games/upgrade` | 업그레이드 구매 기록 |

### 리더보드

| Method | Path | 설명 |
|--------|------|------|
| GET | `/api/leaderboard` | 전체 랭킹 (Top 20) |
| GET | `/api/leaderboard/player/{id}` | 개인 랭킹 |

### 분석 (Redash에서도 사용)

| Method | Path | 설명 |
|--------|------|------|
| GET | `/api/analytics/kpi-trend/{session_id}` | KPI 시계열 |
| GET | `/api/analytics/stage-performance` | 공정별 성과 |
| GET | `/api/analytics/defect-analysis` | 불량 분석 |
| GET | `/api/analytics/strategy-comparison` | 전략별 비교 |
| GET | `/api/analytics/player-history/{id}` | 플레이어 게임 이력 |

### Redash 연동

| Method | Path | 설명 |
|--------|------|------|
| GET | `/api/redash/dashboard-url` | 대시보드 URL 목록 |
| GET | `/api/redash/embed/{query_id}` | 쿼리 결과 프록시 |

---

## 🛠️ 운영 명령어

```bash
# 전체 시작
docker compose up -d

# 전체 중지
docker compose down

# 로그 확인
docker compose logs -f backend
docker compose logs -f redash-server

# Game DB 접속
docker compose exec game-db psql -U battery_admin -d battery_game

# 리더보드 수동 갱신
docker compose exec game-db psql -U battery_admin -d battery_game \
  -c "REFRESH MATERIALIZED VIEW CONCURRENTLY leaderboard;"

# Redash DB 초기화 (최초 1회만)
docker compose run --rm redash-server create_db

# 볼륨 포함 완전 삭제
docker compose down -v
```

---

## 🔒 보안 체크리스트

- [ ] `.env` 파일 `.gitignore`에 추가
- [ ] `GAME_DB_PASSWORD` 운영 환경에서 변경
- [ ] `REDASH_SECRET_KEY`, `REDASH_COOKIE_SECRET` 변경
- [ ] Redash Admin 비밀번호 강화
- [ ] 운영 환경에서 CORS_ORIGINS 제한
- [ ] PostgreSQL 외부 포트(5433) 방화벽 설정
