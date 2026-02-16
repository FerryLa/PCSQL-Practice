-- ═══════════════════════════════════════════════════════════════
-- Battery Factory Game - Database Schema
-- 배터리 제조 시뮬레이션 게임 데이터 스키마
-- ═══════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────
-- 1. 플레이어 (Players)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS players (
    id              SERIAL PRIMARY KEY,
    nickname        VARCHAR(50) NOT NULL UNIQUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_games     INTEGER DEFAULT 0,
    best_score      INTEGER DEFAULT 0,
    best_grade      VARCHAR(2) DEFAULT 'D',
    total_coins     INTEGER DEFAULT 0,
    -- KPI 최고 기록
    best_energy     REAL DEFAULT 0,
    best_stability  REAL DEFAULT 0,
    best_productivity REAL DEFAULT 0
);

CREATE INDEX idx_players_best_score ON players(best_score DESC);
CREATE INDEX idx_players_nickname ON players(nickname);

-- ─────────────────────────────────────────────
-- 2. 게임 세션 (Game Sessions)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS game_sessions (
    id              SERIAL PRIMARY KEY,
    player_id       INTEGER NOT NULL REFERENCES players(id),
    started_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ended_at        TIMESTAMP WITH TIME ZONE,
    -- 최종 결과
    total_score     INTEGER DEFAULT 0,
    grade           VARCHAR(2),      -- S, A, B, C, D
    total_stars     INTEGER DEFAULT 0,
    max_combo       INTEGER DEFAULT 0,
    -- 최종 KPI (0~100)
    final_energy    REAL DEFAULT 50,
    final_stability REAL DEFAULT 50,
    final_productivity REAL DEFAULT 50,
    -- 공정 메타데이터
    stages_completed INTEGER DEFAULT 0,
    lives_remaining  INTEGER DEFAULT 3,
    yield_rate       REAL DEFAULT 100,
    coins_earned     INTEGER DEFAULT 0,
    strategy_used    VARCHAR(30) DEFAULT 'balanced',
    -- 게임 종료 타입
    end_type         VARCHAR(20) DEFAULT 'clear'  -- clear, gameover, quit
);

CREATE INDEX idx_sessions_player ON game_sessions(player_id);
CREATE INDEX idx_sessions_score ON game_sessions(total_score DESC);
CREATE INDEX idx_sessions_started ON game_sessions(started_at DESC);

-- ─────────────────────────────────────────────
-- 3. 스테이지 결과 (Stage Results)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS stage_results (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER NOT NULL REFERENCES game_sessions(id) ON DELETE CASCADE,
    stage_number    INTEGER NOT NULL CHECK (stage_number BETWEEN 1 AND 7),
    stage_name      VARCHAR(50) NOT NULL,
    -- 성과
    stage_score     INTEGER DEFAULT 0,
    rating          INTEGER DEFAULT 0,   -- 0~100
    stars           INTEGER DEFAULT 0,   -- 0~3
    time_spent      REAL DEFAULT 0,      -- seconds
    -- KPI 스냅샷 (이 스테이지 완료 시점)
    energy_snapshot    REAL DEFAULT 50,
    stability_snapshot REAL DEFAULT 50,
    productivity_snapshot REAL DEFAULT 50,
    -- 콤보 정보
    max_combo_in_stage INTEGER DEFAULT 0,
    fever_triggered    BOOLEAN DEFAULT FALSE,
    completed_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_stage_session ON stage_results(session_id);
CREATE INDEX idx_stage_number ON stage_results(stage_number);

-- ─────────────────────────────────────────────
-- 4. KPI 이력 (KPI History - 시계열)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS kpi_history (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER NOT NULL REFERENCES game_sessions(id) ON DELETE CASCADE,
    recorded_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    stage_number    INTEGER NOT NULL,
    -- KPI 값 (0~100)
    energy          REAL NOT NULL,
    stability       REAL NOT NULL,
    productivity    REAL NOT NULL,
    -- 이벤트 컨텍스트
    event_type      VARCHAR(30)  -- stage_complete, inspection, upgrade, strategy_change
);

CREATE INDEX idx_kpi_session ON kpi_history(session_id);
CREATE INDEX idx_kpi_time ON kpi_history(recorded_at);

-- ─────────────────────────────────────────────
-- 5. 불량 이력 (Defect Log)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS defect_log (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER NOT NULL REFERENCES game_sessions(id) ON DELETE CASCADE,
    stage_number    INTEGER NOT NULL,
    defect_type     VARCHAR(50) NOT NULL,   -- dendrite, coating_defect, etc
    defect_name     VARCHAR(100) NOT NULL,
    severity        VARCHAR(20) NOT NULL,    -- critical, warning
    affected_kpi    VARCHAR(20) NOT NULL,    -- energy, stability, productivity
    resolved        BOOLEAN DEFAULT FALSE,
    resolution_type VARCHAR(20),             -- fix, item, skip
    kpi_impact      REAL DEFAULT 0,          -- KPI 감소량
    occurred_at     TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_defect_session ON defect_log(session_id);
CREATE INDEX idx_defect_type ON defect_log(defect_type);

-- ─────────────────────────────────────────────
-- 6. 업그레이드 구매 이력 (Upgrade Log)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS upgrade_log (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER NOT NULL REFERENCES game_sessions(id) ON DELETE CASCADE,
    player_id       INTEGER NOT NULL REFERENCES players(id),
    upgrade_id      VARCHAR(50) NOT NULL,
    upgrade_name    VARCHAR(100) NOT NULL,
    cost            INTEGER NOT NULL,
    kpi_target      VARCHAR(20),
    boost_value     REAL DEFAULT 0,
    purchased_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_upgrade_session ON upgrade_log(session_id);
CREATE INDEX idx_upgrade_player ON upgrade_log(player_id);

-- ─────────────────────────────────────────────
-- 7. 전략 변경 이력 (Strategy Log)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS strategy_log (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER NOT NULL REFERENCES game_sessions(id) ON DELETE CASCADE,
    stage_number    INTEGER NOT NULL,
    strategy        VARCHAR(30) NOT NULL,   -- energy_focus, safety_focus, speed_focus, balanced
    changed_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_strategy_session ON strategy_log(session_id);

-- ─────────────────────────────────────────────
-- 8. 리더보드 뷰 (Materialized View)
-- ─────────────────────────────────────────────
CREATE MATERIALIZED VIEW IF NOT EXISTS leaderboard AS
SELECT
    p.id AS player_id,
    p.nickname,
    p.best_score,
    p.best_grade,
    p.total_games,
    p.best_energy,
    p.best_stability,
    p.best_productivity,
    ROUND((p.best_energy * 0.4 + p.best_stability * 0.35 + p.best_productivity * 0.25)::numeric, 1) AS weighted_kpi,
    RANK() OVER (ORDER BY p.best_score DESC) AS rank_by_score,
    RANK() OVER (ORDER BY (p.best_energy * 0.4 + p.best_stability * 0.35 + p.best_productivity * 0.25) DESC) AS rank_by_kpi
FROM players p
WHERE p.total_games > 0
ORDER BY p.best_score DESC;

CREATE UNIQUE INDEX idx_leaderboard_player ON leaderboard(player_id);

-- ─────────────────────────────────────────────
-- 9. Redash용 분석 뷰 (Views for Redash Queries)
-- ─────────────────────────────────────────────

-- KPI 트렌드 분석 뷰
CREATE OR REPLACE VIEW v_kpi_trend AS
SELECT
    gs.player_id,
    p.nickname,
    kh.session_id,
    kh.stage_number,
    kh.energy,
    kh.stability,
    kh.productivity,
    kh.event_type,
    kh.recorded_at,
    gs.strategy_used,
    gs.grade
FROM kpi_history kh
JOIN game_sessions gs ON kh.session_id = gs.id
JOIN players p ON gs.player_id = p.id
ORDER BY kh.recorded_at;

-- 공정별 성과 분석 뷰
CREATE OR REPLACE VIEW v_stage_performance AS
SELECT
    sr.stage_number,
    sr.stage_name,
    COUNT(*) AS total_plays,
    ROUND(AVG(sr.rating)::numeric, 1) AS avg_rating,
    ROUND(AVG(sr.stars)::numeric, 2) AS avg_stars,
    ROUND(AVG(sr.time_spent)::numeric, 1) AS avg_time,
    ROUND(AVG(sr.energy_snapshot)::numeric, 1) AS avg_energy,
    ROUND(AVG(sr.stability_snapshot)::numeric, 1) AS avg_stability,
    ROUND(AVG(sr.productivity_snapshot)::numeric, 1) AS avg_productivity,
    SUM(CASE WHEN sr.fever_triggered THEN 1 ELSE 0 END) AS fever_count
FROM stage_results sr
GROUP BY sr.stage_number, sr.stage_name
ORDER BY sr.stage_number;

-- 불량 유형별 분석 뷰
CREATE OR REPLACE VIEW v_defect_analysis AS
SELECT
    dl.defect_type,
    dl.defect_name,
    dl.severity,
    dl.affected_kpi,
    COUNT(*) AS occurrence_count,
    SUM(CASE WHEN dl.resolved THEN 1 ELSE 0 END) AS resolved_count,
    ROUND(
        (SUM(CASE WHEN dl.resolved THEN 1 ELSE 0 END)::numeric / COUNT(*)::numeric) * 100, 1
    ) AS resolution_rate,
    ROUND(AVG(ABS(dl.kpi_impact))::numeric, 1) AS avg_kpi_impact
FROM defect_log dl
GROUP BY dl.defect_type, dl.defect_name, dl.severity, dl.affected_kpi
ORDER BY occurrence_count DESC;

-- 전략별 성과 비교 뷰
CREATE OR REPLACE VIEW v_strategy_comparison AS
SELECT
    gs.strategy_used,
    COUNT(*) AS games_played,
    ROUND(AVG(gs.total_score)::numeric, 0) AS avg_score,
    ROUND(AVG(gs.final_energy)::numeric, 1) AS avg_energy,
    ROUND(AVG(gs.final_stability)::numeric, 1) AS avg_stability,
    ROUND(AVG(gs.final_productivity)::numeric, 1) AS avg_productivity,
    ROUND(AVG(gs.yield_rate)::numeric, 1) AS avg_yield,
    ROUND(AVG(gs.total_stars)::numeric, 1) AS avg_stars,
    SUM(CASE WHEN gs.end_type = 'clear' THEN 1 ELSE 0 END) AS clear_count,
    SUM(CASE WHEN gs.end_type = 'gameover' THEN 1 ELSE 0 END) AS gameover_count
FROM game_sessions gs
GROUP BY gs.strategy_used
ORDER BY avg_score DESC;

-- ─────────────────────────────────────────────
-- 10. 샘플 데이터 (Demo용)
-- ─────────────────────────────────────────────
INSERT INTO players (nickname, total_games, best_score, best_grade, best_energy, best_stability, best_productivity, total_coins)
VALUES
    ('Dr.Battery🏆', 45, 4850, 'S', 92, 88, 85, 15200),
    ('CellMaster',   38, 4520, 'A', 85, 91, 82, 12800),
    ('VoltageKing',  32, 4200, 'A', 90, 78, 88, 11500),
    ('LiIonPro',     28, 3980, 'B', 82, 85, 80, 9800),
    ('AnodeMaster',  25, 3750, 'B', 78, 83, 86, 8500);
