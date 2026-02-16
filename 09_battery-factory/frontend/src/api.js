/**
 * Battery Factory Game - API Client
 * FastAPI 백엔드 (/api) 와 통신하는 모듈
 *
 * Vite proxy 설정에 의해 /api → http://backend:5001 로 프록시됩니다.
 * Docker 외부에서 개발 시: http://localhost:5001/api
 */

const BASE = "";  // Vite proxy 사용 시 빈 문자열, 직접 연결 시 "http://localhost:5001"

async function request(method, path, body = null) {
  const options = {
    method,
    headers: { "Content-Type": "application/json" },
  };
  if (body) options.body = JSON.stringify(body);

  const res = await fetch(`${BASE}${path}`, options);
  if (!res.ok) {
    const text = await res.text();
    console.error(`API ${method} ${path} → ${res.status}:`, text);
    throw new Error(`API error: ${res.status}`);
  }
  return res.json();
}

// ─── Player ───
export async function createPlayer(nickname) {
  return request("POST", "/api/players", { nickname });
}

export async function getPlayer(playerId) {
  return request("GET", `/api/players/${playerId}`);
}

// ─── Game Session ───
export async function startGame(playerId) {
  return request("POST", "/api/games/start", { player_id: playerId });
}

export async function endGame(data) {
  return request("POST", "/api/games/end", data);
}

// ─── Strategy & Upgrade ───
export async function changeStrategy(sessionId, stageNumber, strategy) {
  return request("POST", "/api/games/strategy", {
    session_id: sessionId,
    stage_number: stageNumber,
    strategy,
  });
}

export async function purchaseUpgrade(data) {
  return request("POST", "/api/games/upgrade", data);
}

// ─── Leaderboard ───
export async function getLeaderboard(limit = 20) {
  return request("GET", `/api/leaderboard?limit=${limit}`);
}

export async function getPlayerRank(playerId) {
  return request("GET", `/api/leaderboard/player/${playerId}`);
}

// ─── Analytics ───
export async function getKpiTrend(sessionId) {
  return request("GET", `/api/analytics/kpi-trend/${sessionId}`);
}

export async function getStagePerformance() {
  return request("GET", "/api/analytics/stage-performance");
}

export async function getDefectAnalysis() {
  return request("GET", "/api/analytics/defect-analysis");
}

export async function getStrategyComparison() {
  return request("GET", "/api/analytics/strategy-comparison");
}

export async function getPlayerHistory(playerId, limit = 20) {
  return request("GET", `/api/analytics/player-history/${playerId}?limit=${limit}`);
}

// ─── Redash ───
export async function getRedashDashboardUrl() {
  return request("GET", "/api/redash/dashboard-url");
}

export async function getRedashEmbed(queryId) {
  return request("GET", `/api/redash/embed/${queryId}`);
}

// ─── Health ───
export async function healthCheck() {
  return request("GET", "/health");
}
