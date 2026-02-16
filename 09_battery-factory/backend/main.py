"""
Battery Factory Game - FastAPI Backend
배터리 제조 시뮬레이션 게임 API 서버

Architecture:
    React Game Client → FastAPI → PostgreSQL (game_db)
                                      ↑
                              Redash (쿼리 & 시각화)
"""

import os
import json
from datetime import datetime
from contextlib import asynccontextmanager
from typing import Optional

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy import text
import httpx


# ═══════════════════════════════════════════════════════════════
# CONFIG
# ═══════════════════════════════════════════════════════════════

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+asyncpg://battery_admin:battery_secure_2024@localhost:5433/battery_game"
)
REDASH_URL = os.getenv("REDASH_URL", "http://localhost:5000")
REDASH_API_KEY = os.getenv("REDASH_API_KEY", "")
CORS_ORIGINS = json.loads(os.getenv("CORS_ORIGINS", '["http://localhost:3000","http://localhost:5173"]'))


# ═══════════════════════════════════════════════════════════════
# DATABASE
# ═══════════════════════════════════════════════════════════════

engine = create_async_engine(DATABASE_URL, echo=False, pool_size=10, max_overflow=20)
async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def get_db():
    async with async_session() as session:
        try:
            yield session
        finally:
            await session.close()


# ═══════════════════════════════════════════════════════════════
# PYDANTIC MODELS
# ═══════════════════════════════════════════════════════════════

class PlayerCreate(BaseModel):
    nickname: str = Field(..., min_length=2, max_length=50)

class PlayerResponse(BaseModel):
    id: int
    nickname: str
    total_games: int
    best_score: int
    best_grade: str
    best_energy: float
    best_stability: float
    best_productivity: float
    total_coins: int

class KPISnapshot(BaseModel):
    energy: float = Field(ge=0, le=100)
    stability: float = Field(ge=0, le=100)
    productivity: float = Field(ge=0, le=100)

class StageResultInput(BaseModel):
    stage_number: int = Field(ge=1, le=7)
    stage_name: str
    stage_score: int = Field(ge=0)
    rating: int = Field(ge=0, le=100)
    stars: int = Field(ge=0, le=3)
    time_spent: float = Field(ge=0)
    kpi_snapshot: KPISnapshot
    max_combo_in_stage: int = 0
    fever_triggered: bool = False

class DefectInput(BaseModel):
    stage_number: int
    defect_type: str
    defect_name: str
    severity: str
    affected_kpi: str
    resolved: bool
    resolution_type: Optional[str] = None
    kpi_impact: float = 0

class GameStartInput(BaseModel):
    player_id: int

class GameEndInput(BaseModel):
    session_id: int
    total_score: int
    grade: str
    total_stars: int
    max_combo: int
    final_kpi: KPISnapshot
    stages_completed: int
    lives_remaining: int
    yield_rate: float
    coins_earned: int
    strategy_used: str = "balanced"
    end_type: str = "clear"
    # 상세 결과
    stage_results: list[StageResultInput] = []
    defects: list[DefectInput] = []
    kpi_history: list[dict] = []

class StrategyChangeInput(BaseModel):
    session_id: int
    stage_number: int
    strategy: str

class UpgradePurchaseInput(BaseModel):
    session_id: int
    player_id: int
    upgrade_id: str
    upgrade_name: str
    cost: int
    kpi_target: str
    boost_value: float


# ═══════════════════════════════════════════════════════════════
# APP LIFECYCLE
# ═══════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🔋 Battery Factory API Starting...")
    yield
    await engine.dispose()
    print("🔋 Battery Factory API Stopped.")


app = FastAPI(
    title="Battery Factory Game API",
    description="배터리 제조 시뮬레이션 게임 백엔드 API",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ═══════════════════════════════════════════════════════════════
# HEALTH CHECK
# ═══════════════════════════════════════════════════════════════

@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "battery-factory-api"}


# ═══════════════════════════════════════════════════════════════
# PLAYER ENDPOINTS
# ═══════════════════════════════════════════════════════════════

@app.post("/api/players", response_model=PlayerResponse)
async def create_player(data: PlayerCreate, db: AsyncSession = Depends(get_db)):
    """플레이어 생성 또는 기존 플레이어 반환"""
    result = await db.execute(
        text("SELECT * FROM players WHERE nickname = :nickname"),
        {"nickname": data.nickname}
    )
    row = result.mappings().first()
    if row:
        return dict(row)

    result = await db.execute(
        text("""
            INSERT INTO players (nickname)
            VALUES (:nickname)
            RETURNING *
        """),
        {"nickname": data.nickname}
    )
    await db.commit()
    return dict(result.mappings().first())


@app.get("/api/players/{player_id}", response_model=PlayerResponse)
async def get_player(player_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        text("SELECT * FROM players WHERE id = :id"),
        {"id": player_id}
    )
    row = result.mappings().first()
    if not row:
        raise HTTPException(404, "Player not found")
    return dict(row)


# ═══════════════════════════════════════════════════════════════
# GAME SESSION ENDPOINTS
# ═══════════════════════════════════════════════════════════════

@app.post("/api/games/start")
async def start_game(data: GameStartInput, db: AsyncSession = Depends(get_db)):
    """게임 세션 시작"""
    result = await db.execute(
        text("""
            INSERT INTO game_sessions (player_id)
            VALUES (:player_id)
            RETURNING id, started_at
        """),
        {"player_id": data.player_id}
    )
    await db.commit()
    row = result.mappings().first()
    return {"session_id": row["id"], "started_at": row["started_at"].isoformat()}


@app.post("/api/games/end")
async def end_game(data: GameEndInput, db: AsyncSession = Depends(get_db)):
    """게임 세션 종료 — 전체 결과 저장"""

    # 1. 게임 세션 업데이트
    await db.execute(
        text("""
            UPDATE game_sessions SET
                ended_at = NOW(),
                total_score = :total_score,
                grade = :grade,
                total_stars = :total_stars,
                max_combo = :max_combo,
                final_energy = :energy,
                final_stability = :stability,
                final_productivity = :productivity,
                stages_completed = :stages_completed,
                lives_remaining = :lives_remaining,
                yield_rate = :yield_rate,
                coins_earned = :coins_earned,
                strategy_used = :strategy_used,
                end_type = :end_type
            WHERE id = :session_id
        """),
        {
            "session_id": data.session_id,
            "total_score": data.total_score,
            "grade": data.grade,
            "total_stars": data.total_stars,
            "max_combo": data.max_combo,
            "energy": data.final_kpi.energy,
            "stability": data.final_kpi.stability,
            "productivity": data.final_kpi.productivity,
            "stages_completed": data.stages_completed,
            "lives_remaining": data.lives_remaining,
            "yield_rate": data.yield_rate,
            "coins_earned": data.coins_earned,
            "strategy_used": data.strategy_used,
            "end_type": data.end_type,
        }
    )

    # 2. 스테이지 결과 저장
    for sr in data.stage_results:
        await db.execute(
            text("""
                INSERT INTO stage_results
                    (session_id, stage_number, stage_name, stage_score, rating, stars,
                     time_spent, energy_snapshot, stability_snapshot, productivity_snapshot,
                     max_combo_in_stage, fever_triggered)
                VALUES
                    (:sid, :sn, :name, :score, :rating, :stars,
                     :time, :energy, :stability, :productivity,
                     :combo, :fever)
            """),
            {
                "sid": data.session_id, "sn": sr.stage_number, "name": sr.stage_name,
                "score": sr.stage_score, "rating": sr.rating, "stars": sr.stars,
                "time": sr.time_spent, "energy": sr.kpi_snapshot.energy,
                "stability": sr.kpi_snapshot.stability, "productivity": sr.kpi_snapshot.productivity,
                "combo": sr.max_combo_in_stage, "fever": sr.fever_triggered,
            }
        )

    # 3. 불량 이력 저장
    for d in data.defects:
        await db.execute(
            text("""
                INSERT INTO defect_log
                    (session_id, stage_number, defect_type, defect_name, severity,
                     affected_kpi, resolved, resolution_type, kpi_impact)
                VALUES
                    (:sid, :sn, :type, :name, :severity,
                     :kpi, :resolved, :res_type, :impact)
            """),
            {
                "sid": data.session_id, "sn": d.stage_number, "type": d.defect_type,
                "name": d.defect_name, "severity": d.severity, "kpi": d.affected_kpi,
                "resolved": d.resolved, "res_type": d.resolution_type, "impact": d.kpi_impact,
            }
        )

    # 4. KPI 이력 저장
    for kh in data.kpi_history:
        await db.execute(
            text("""
                INSERT INTO kpi_history
                    (session_id, stage_number, energy, stability, productivity, event_type)
                VALUES
                    (:sid, :sn, :energy, :stability, :productivity, :event)
            """),
            {
                "sid": data.session_id, "sn": kh.get("stage_number", 1),
                "energy": kh.get("energy", 50), "stability": kh.get("stability", 50),
                "productivity": kh.get("productivity", 50),
                "event": kh.get("event_type", "stage_complete"),
            }
        )

    # 5. 플레이어 통계 업데이트
    session_res = await db.execute(
        text("SELECT player_id FROM game_sessions WHERE id = :sid"),
        {"sid": data.session_id}
    )
    player_id = session_res.scalars().first()

    await db.execute(
        text("""
            UPDATE players SET
                total_games = total_games + 1,
                total_coins = total_coins + :coins,
                best_score = GREATEST(best_score, :score),
                best_grade = CASE
                    WHEN :score > best_score THEN :grade
                    ELSE best_grade
                END,
                best_energy = GREATEST(best_energy, :energy),
                best_stability = GREATEST(best_stability, :stability),
                best_productivity = GREATEST(best_productivity, :productivity)
            WHERE id = :pid
        """),
        {
            "pid": player_id, "coins": data.coins_earned, "score": data.total_score,
            "grade": data.grade, "energy": data.final_kpi.energy,
            "stability": data.final_kpi.stability, "productivity": data.final_kpi.productivity,
        }
    )

    # 6. 리더보드 갱신
    await db.execute(text("REFRESH MATERIALIZED VIEW CONCURRENTLY leaderboard"))

    await db.commit()
    return {"status": "saved", "session_id": data.session_id}


# ═══════════════════════════════════════════════════════════════
# STRATEGY & UPGRADE ENDPOINTS
# ═══════════════════════════════════════════════════════════════

@app.post("/api/games/strategy")
async def change_strategy(data: StrategyChangeInput, db: AsyncSession = Depends(get_db)):
    await db.execute(
        text("""
            INSERT INTO strategy_log (session_id, stage_number, strategy)
            VALUES (:sid, :sn, :strategy)
        """),
        {"sid": data.session_id, "sn": data.stage_number, "strategy": data.strategy}
    )
    await db.commit()
    return {"status": "ok"}


@app.post("/api/games/upgrade")
async def purchase_upgrade(data: UpgradePurchaseInput, db: AsyncSession = Depends(get_db)):
    await db.execute(
        text("""
            INSERT INTO upgrade_log
                (session_id, player_id, upgrade_id, upgrade_name, cost, kpi_target, boost_value)
            VALUES
                (:sid, :pid, :uid, :uname, :cost, :kpi, :boost)
        """),
        {
            "sid": data.session_id, "pid": data.player_id, "uid": data.upgrade_id,
            "uname": data.upgrade_name, "cost": data.cost, "kpi": data.kpi_target,
            "boost": data.boost_value,
        }
    )
    await db.commit()
    return {"status": "ok"}


# ═══════════════════════════════════════════════════════════════
# LEADERBOARD ENDPOINTS
# ═══════════════════════════════════════════════════════════════

@app.get("/api/leaderboard")
async def get_leaderboard(limit: int = 20, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        text("SELECT * FROM leaderboard ORDER BY rank_by_score LIMIT :limit"),
        {"limit": limit}
    )
    return [dict(r) for r in result.mappings().all()]


@app.get("/api/leaderboard/player/{player_id}")
async def get_player_rank(player_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        text("SELECT * FROM leaderboard WHERE player_id = :pid"),
        {"pid": player_id}
    )
    row = result.mappings().first()
    if not row:
        return {"rank_by_score": None, "message": "No games played yet"}
    return dict(row)


# ═══════════════════════════════════════════════════════════════
# ANALYTICS ENDPOINTS (Redash에서도 사용 가능)
# ═══════════════════════════════════════════════════════════════

@app.get("/api/analytics/kpi-trend/{session_id}")
async def get_kpi_trend(session_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        text("""
            SELECT stage_number, energy, stability, productivity, event_type, recorded_at
            FROM kpi_history
            WHERE session_id = :sid
            ORDER BY recorded_at
        """),
        {"sid": session_id}
    )
    return [dict(r) for r in result.mappings().all()]


@app.get("/api/analytics/stage-performance")
async def get_stage_performance(db: AsyncSession = Depends(get_db)):
    result = await db.execute(text("SELECT * FROM v_stage_performance"))
    return [dict(r) for r in result.mappings().all()]


@app.get("/api/analytics/defect-analysis")
async def get_defect_analysis(db: AsyncSession = Depends(get_db)):
    result = await db.execute(text("SELECT * FROM v_defect_analysis"))
    return [dict(r) for r in result.mappings().all()]


@app.get("/api/analytics/strategy-comparison")
async def get_strategy_comparison(db: AsyncSession = Depends(get_db)):
    result = await db.execute(text("SELECT * FROM v_strategy_comparison"))
    return [dict(r) for r in result.mappings().all()]


@app.get("/api/analytics/player-history/{player_id}")
async def get_player_history(player_id: int, limit: int = 20, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        text("""
            SELECT id, total_score, grade, total_stars, max_combo,
                   final_energy, final_stability, final_productivity,
                   stages_completed, yield_rate, strategy_used, end_type,
                   started_at, ended_at
            FROM game_sessions
            WHERE player_id = :pid
            ORDER BY started_at DESC
            LIMIT :limit
        """),
        {"pid": player_id, "limit": limit}
    )
    return [dict(r) for r in result.mappings().all()]


# ═══════════════════════════════════════════════════════════════
# REDASH INTEGRATION — 대시보드 임베드 URL
# ═══════════════════════════════════════════════════════════════

@app.get("/api/redash/dashboard-url")
async def get_redash_dashboard_url():
    """Redash 대시보드 공개 URL 반환 (iframe용)"""
    return {
        "redash_url": REDASH_URL,
        "dashboards": {
            "overview": f"{REDASH_URL}/public/dashboards/battery-overview",
            "kpi_analysis": f"{REDASH_URL}/public/dashboards/kpi-analysis",
            "defect_report": f"{REDASH_URL}/public/dashboards/defect-report",
            "leaderboard": f"{REDASH_URL}/public/dashboards/leaderboard",
        },
        "note": "대시보드가 생성된 후 public token으로 접근 가능합니다."
    }


@app.get("/api/redash/embed/{query_id}")
async def get_redash_embed(query_id: int):
    """Redash 쿼리 결과 프록시 (CORS 우회)"""
    if not REDASH_API_KEY:
        raise HTTPException(400, "REDASH_API_KEY not configured")

    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{REDASH_URL}/api/queries/{query_id}/results.json",
            headers={"Authorization": f"Key {REDASH_API_KEY}"},
            timeout=30.0,
        )
        if resp.status_code != 200:
            raise HTTPException(resp.status_code, "Redash query failed")
        return resp.json()
