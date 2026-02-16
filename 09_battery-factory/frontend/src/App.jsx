import { useState, useEffect, useCallback, useRef } from "react";
import BatteryGame from "./BatteryGame.jsx";
import * as api from "./api.js";

/**
 * App.jsx — 게임 래퍼
 *
 * 역할:
 *  1. 닉네임 입력 → 플레이어 생성/조회 (POST /api/players)
 *  2. 게임 시작 시 세션 생성 (POST /api/games/start)
 *  3. BatteryGame 컴포넌트에 콜백 전달
 *  4. 게임 종료 시 전체 결과를 백엔드로 전송 (POST /api/games/end)
 *  5. API 미연결 시에도 게임은 오프라인으로 작동
 */

export default function App() {
  const [player, setPlayer] = useState(null);
  const [nickname, setNickname] = useState("");
  const [sessionId, setSessionId] = useState(null);
  const [apiConnected, setApiConnected] = useState(null); // null=체크중, true/false
  const [error, setError] = useState(null);

  // ─── 백엔드 연결 체크 ───
  useEffect(() => {
    api.healthCheck()
      .then(() => setApiConnected(true))
      .catch(() => setApiConnected(false));
  }, []);

  // ─── 플레이어 로그인 ───
  const handleLogin = async () => {
    if (!nickname.trim()) return;
    setError(null);

    if (apiConnected) {
      try {
        const p = await api.createPlayer(nickname.trim());
        setPlayer(p);
      } catch (e) {
        setError("서버 연결 실패. 오프라인 모드로 진행합니다.");
        setPlayer({ id: 0, nickname: nickname.trim(), total_games: 0, best_score: 0 });
      }
    } else {
      // 오프라인 모드
      setPlayer({ id: 0, nickname: nickname.trim(), total_games: 0, best_score: 0 });
    }
  };

  // ─── 게임 시작 콜백 (BatteryGame에서 호출) ───
  const handleGameStart = useCallback(async () => {
    if (!apiConnected || !player?.id) return null;
    try {
      const { session_id } = await api.startGame(player.id);
      setSessionId(session_id);
      return session_id;
    } catch {
      return null;
    }
  }, [apiConnected, player]);

  // ─── 게임 종료 콜백 (BatteryGame에서 호출) ───
  const handleGameEnd = useCallback(async (gameResult) => {
    if (!apiConnected || !sessionId) {
      console.log("오프라인 모드: 결과 로컬 저장만", gameResult);
      return;
    }

    try {
      await api.endGame({
        session_id: sessionId,
        total_score: gameResult.score,
        grade: gameResult.grade,
        total_stars: gameResult.totalStars,
        max_combo: gameResult.maxCombo,
        final_kpi: {
          energy: gameResult.kpi.energy,
          stability: gameResult.kpi.stability,
          productivity: gameResult.kpi.productivity,
        },
        stages_completed: gameResult.stagesCompleted,
        lives_remaining: gameResult.livesRemaining,
        yield_rate: gameResult.yieldRate,
        coins_earned: gameResult.coinsEarned,
        strategy_used: gameResult.strategy,
        end_type: gameResult.endType,
        stage_results: gameResult.stageResults.map((sr, i) => ({
          stage_number: i + 1,
          stage_name: sr.name || `Stage ${i + 1}`,
          stage_score: sr.stageScore || 0,
          rating: sr.rating || 0,
          stars: sr.stars || 0,
          time_spent: sr.timeSpent || 0,
          kpi_snapshot: {
            energy: sr.kpiSnapshot?.energy || 50,
            stability: sr.kpiSnapshot?.stability || 50,
            productivity: sr.kpiSnapshot?.productivity || 50,
          },
          max_combo_in_stage: sr.maxCombo || 0,
          fever_triggered: sr.feverTriggered || false,
        })),
        defects: gameResult.defects.map(d => ({
          stage_number: d.stage || 1,
          defect_type: d.id || "unknown",
          defect_name: d.name || "Unknown",
          severity: d.severity || "warning",
          affected_kpi: d.kpi || "stability",
          resolved: d.resolved || false,
          resolution_type: d.resolutionType || null,
          kpi_impact: d.kpiImpact || 0,
        })),
        kpi_history: gameResult.kpiHistory.map((kh, i) => ({
          stage_number: i + 1,
          energy: kh.energy || 50,
          stability: kh.stability || 50,
          productivity: kh.productivity || 50,
          event_type: kh.eventType || "stage_complete",
        })),
      });
      console.log("✅ 게임 결과 서버 저장 완료");
    } catch (e) {
      console.error("게임 결과 저장 실패:", e);
    }
  }, [apiConnected, sessionId]);

  // ─── 전략 변경 콜백 ───
  const handleStrategyChange = useCallback(async (stageNumber, strategy) => {
    if (!apiConnected || !sessionId) return;
    try {
      await api.changeStrategy(sessionId, stageNumber, strategy);
    } catch {}
  }, [apiConnected, sessionId]);

  // ─── 업그레이드 구매 콜백 ───
  const handleUpgradePurchase = useCallback(async (upgrade) => {
    if (!apiConnected || !sessionId || !player?.id) return;
    try {
      await api.purchaseUpgrade({
        session_id: sessionId,
        player_id: player.id,
        upgrade_id: upgrade.id,
        upgrade_name: upgrade.name,
        cost: upgrade.cost,
        kpi_target: upgrade.kpi,
        boost_value: upgrade.boost,
      });
    } catch {}
  }, [apiConnected, sessionId, player]);

  // ─── 리더보드 조회 콜백 ───
  const handleGetLeaderboard = useCallback(async () => {
    if (!apiConnected) return null;
    try {
      return await api.getLeaderboard();
    } catch {
      return null;
    }
  }, [apiConnected]);

  // ─── 로그인 화면 ───
  if (!player) {
    return (
      <div style={{
        minHeight: "100vh",
        background: "linear-gradient(160deg, #0a0e17 0%, #0d1926 30%, #0f1f2e 60%, #0a1628 100%)",
        display: "flex", flexDirection: "column",
        alignItems: "center", justifyContent: "center",
        fontFamily: "'Noto Sans KR', system-ui, sans-serif",
        padding: 20,
      }}>
        <div style={{
          background: "linear-gradient(145deg, rgba(22,27,34,0.95), rgba(13,17,23,0.98))",
          borderRadius: 24, padding: "40px 36px", textAlign: "center",
          maxWidth: 400, width: "100%", border: "1px solid #30363d",
          boxShadow: "0 20px 60px rgba(0,0,0,0.5)",
        }}>
          <div style={{ fontSize: 56, marginBottom: 8 }}>🔋</div>
          <h1 style={{ fontSize: 24, fontWeight: 800, color: "#e6edf3", margin: "0 0 4px" }}>
            배터리 팩토리
          </h1>
          <p style={{ fontSize: 12, color: "#8b949e", marginBottom: 24 }}>
            닉네임을 입력하고 공정을 시작하세요
          </p>

          {/* 연결 상태 */}
          <div style={{
            display: "inline-flex", alignItems: "center", gap: 6,
            padding: "4px 12px", borderRadius: 12, marginBottom: 20,
            background: apiConnected === null ? "#21262d" : apiConnected ? "#00b89411" : "#f39c1211",
            border: `1px solid ${apiConnected === null ? "#30363d" : apiConnected ? "#00b89433" : "#f39c1233"}`,
          }}>
            <div style={{
              width: 6, height: 6, borderRadius: "50%",
              background: apiConnected === null ? "#8b949e" : apiConnected ? "#00b894" : "#f39c12",
              animation: apiConnected === null ? "pulse 1s infinite" : "none",
            }} />
            <span style={{
              fontSize: 10, fontWeight: 600,
              color: apiConnected === null ? "#8b949e" : apiConnected ? "#00b894" : "#f39c12",
            }}>
              {apiConnected === null ? "서버 연결 확인 중..." :
               apiConnected ? "서버 연결됨 (데이터 저장 활성)" :
               "오프라인 모드 (로컬 플레이)"}
            </span>
          </div>

          {/* 닉네임 입력 */}
          <div style={{ display: "flex", gap: 8, marginBottom: 16 }}>
            <input
              value={nickname}
              onChange={e => setNickname(e.target.value)}
              onKeyDown={e => e.key === "Enter" && handleLogin()}
              placeholder="닉네임 입력..."
              maxLength={20}
              style={{
                flex: 1, padding: "12px 16px", borderRadius: 12,
                background: "#0d1117", border: "1px solid #30363d",
                color: "#e6edf3", fontSize: 14, outline: "none",
              }}
              onFocus={e => { e.target.style.borderColor = "#00b894"; }}
              onBlur={e => { e.target.style.borderColor = "#30363d"; }}
              autoFocus
            />
            <button
              onClick={handleLogin}
              disabled={!nickname.trim()}
              style={{
                padding: "12px 24px", borderRadius: 12, border: "none",
                background: nickname.trim() ? "linear-gradient(135deg, #00b894, #00cec9)" : "#21262d",
                color: nickname.trim() ? "#fff" : "#484f58",
                fontSize: 14, fontWeight: 700, cursor: nickname.trim() ? "pointer" : "default",
                transition: "all 0.2s",
              }}>
              시작 ▶
            </button>
          </div>

          {error && (
            <div style={{ fontSize: 11, color: "#f39c12", marginBottom: 8 }}>
              ⚠️ {error}
            </div>
          )}

          <div style={{ fontSize: 10, color: "#484f58", lineHeight: 1.6 }}>
            Powered by FastAPI + PostgreSQL + <span style={{ color: "#e74c3c" }}>Redash</span>
          </div>
        </div>

        <style>{`
          @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
          }
        `}</style>
      </div>
    );
  }

  // ─── 게임 실행 ───
  return (
    <BatteryGame
      player={player}
      apiConnected={apiConnected}
      onGameStart={handleGameStart}
      onGameEnd={handleGameEnd}
      onStrategyChange={handleStrategyChange}
      onUpgradePurchase={handleUpgradePurchase}
      onGetLeaderboard={handleGetLeaderboard}
    />
  );
}
