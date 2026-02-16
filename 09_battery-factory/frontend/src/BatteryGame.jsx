import { useState, useEffect, useCallback, useRef, useMemo } from "react";

// ═══════════════════════════════════════════════════════════════
// CONFIGURATION & CONSTANTS
// ═══════════════════════════════════════════════════════════════

const GAME_CONFIG = {
  MAX_LIVES: 3,
  STAGE_TIME_LIMIT: 45,
  COMBO_FEVER_THRESHOLD: 8,
  FEVER_DURATION: 8000,
  FEVER_MULTIPLIER: 2,
  QUALITY_INSPECTION_CHANCE: 0.25,
  STAR_THRESHOLDS: { three: 0.85, two: 0.65, one: 0.4 },
};

const KPI_NAMES = {
  energy: "에너지 밀도",
  stability: "안전성",
  productivity: "생산성",
};

const KPI_COLORS = {
  energy: "#e74c3c",
  stability: "#3498db",
  productivity: "#2ecc71",
};

const KPI_ICONS = {
  energy: "⚡",
  stability: "🛡️",
  productivity: "⚙️",
};

const STAGES = [
  {
    id: 1, name: "소재 혼합", subtitle: "슬러리 만들기", icon: "🧪",
    description: "양극재, 도전재, 바인더, 용매를 순서대로 믹서에 넣으세요!",
    kpiEffect: { energy: 0.3, stability: 0.2, productivity: 0.1 },
    materials: [
      { id: "cathode", name: "양극재", emoji: "🔴", color: "#e74c3c" },
      { id: "conductive", name: "도전재", emoji: "⚫", color: "#2c3e50" },
      { id: "binder", name: "바인더", emoji: "🟡", color: "#f39c12" },
      { id: "solvent", name: "용매", emoji: "🔵", color: "#3498db" },
    ],
  },
  {
    id: 2, name: "코팅 공정", subtitle: "집전체에 슬러리 코팅", icon: "🖌️",
    description: "슬러리를 알루미늄 포일 위에 균일하게 코팅하세요!",
    kpiEffect: { energy: 0.25, stability: 0.15, productivity: 0.2 },
  },
  {
    id: 3, name: "프레싱 공정", subtitle: "전극 압연", icon: "🔧",
    description: "전극을 목표 두께로 정확하게 압연하세요!",
    kpiEffect: { energy: 0.35, stability: 0.1, productivity: 0.15 },
  },
  {
    id: 4, name: "절단 공정", subtitle: "전극 커팅", icon: "✂️",
    description: "정확한 크기로 전극을 절단하세요!",
    kpiEffect: { energy: 0.1, stability: 0.15, productivity: 0.35 },
  },
  {
    id: 5, name: "조립 공정", subtitle: "셀 조립", icon: "🔋",
    description: "양극→분리막→음극→분리막 순서로 적층하세요!",
    kpiEffect: { energy: 0.2, stability: 0.35, productivity: 0.1 },
    layers: [
      { id: "cathode", name: "양극", color: "#e74c3c", emoji: "🔴" },
      { id: "sep1", name: "분리막", color: "#ecf0f1", emoji: "⬜" },
      { id: "anode", name: "음극", color: "#2ecc71", emoji: "🟢" },
      { id: "sep2", name: "분리막", color: "#ecf0f1", emoji: "⬜" },
    ],
  },
  {
    id: 6, name: "활성화 공정", subtitle: "전해액 주입 & 충전", icon: "⚡",
    description: "전해액을 주입하고 충전 게이지를 100%까지 채우세요!",
    kpiEffect: { energy: 0.15, stability: 0.3, productivity: 0.15 },
  },
];

const BONUS_STAGE = {
  id: 7, name: "보너스: 건식 전극", subtitle: "차세대 공정 체험", icon: "🌟",
  description: "용매 없이 분말을 직접 코팅하는 건식 공정!",
  kpiEffect: { energy: 0.4, stability: 0.2, productivity: 0.3 },
};

const UPGRADES = [
  { id: "mixer_pro", name: "고급 믹서", desc: "혼합 정밀도 +15%", cost: 300, icon: "🧫", kpi: "energy", boost: 0.15 },
  { id: "coat_laser", name: "레이저 코팅", desc: "코팅 균일도 +20%", cost: 500, icon: "🔬", kpi: "stability", boost: 0.2 },
  { id: "auto_press", name: "자동 프레스", desc: "프레싱 속도 +25%", cost: 450, icon: "🏭", kpi: "productivity", boost: 0.25 },
  { id: "ai_inspect", name: "AI 검사 모듈", desc: "불량률 -30%", cost: 700, icon: "🤖", kpi: "stability", boost: 0.3 },
  { id: "dry_tech", name: "건식 기술 연구", desc: "전체 KPI +10%", cost: 1000, icon: "🧬", kpi: "all", boost: 0.1 },
  { id: "redash_pro", name: "Redash 프로", desc: "분석 정밀도 +20%", cost: 600, icon: "📊", kpi: "insight", boost: 0.2 },
];

const INSPECTION_EVENTS = [
  { id: "dendrite", name: "덴드라이트 검출", desc: "리튬 석출 발견! 안전성 위험", severity: "critical", kpi: "stability" },
  { id: "coating_defect", name: "코팅 불균일", desc: "코팅 두께 편차 초과", severity: "warning", kpi: "energy" },
  { id: "contamination", name: "이물질 혼입", desc: "금속 입자 검출됨", severity: "critical", kpi: "stability" },
  { id: "thickness_var", name: "두께 편차", desc: "전극 두께 공차 초과", severity: "warning", kpi: "productivity" },
  { id: "moisture", name: "수분 침투", desc: "허용치 이상 수분 감지", severity: "warning", kpi: "stability" },
  { id: "alignment", name: "전극 정렬 오류", desc: "양극/음극 오정렬 감지", severity: "critical", kpi: "energy" },
];

// ═══════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════

const clamp = (val, min, max) => Math.max(min, Math.min(max, val));
const lerp = (a, b, t) => a + (b - a) * t;
const rand = (min, max) => Math.random() * (max - min) + min;
const randInt = (min, max) => Math.floor(rand(min, max + 1));

function generateSparkline(data, width = 120, height = 30) {
  if (!data || data.length < 2) return "";
  const max = Math.max(...data);
  const min = Math.min(...data);
  const range = max - min || 1;
  const step = width / (data.length - 1);
  return data.map((v, i) => {
    const x = i * step;
    const y = height - ((v - min) / range) * height;
    return `${i === 0 ? "M" : "L"}${x.toFixed(1)},${y.toFixed(1)}`;
  }).join(" ");
}

// ═══════════════════════════════════════════════════════════════
// MINI SPARKLINE CHART COMPONENT
// ═══════════════════════════════════════════════════════════════

function SparkLine({ data, color = "#00b894", width = 100, height = 28, label }) {
  const path = generateSparkline(data, width, height);
  const latest = data[data.length - 1];
  const prev = data.length > 1 ? data[data.length - 2] : latest;
  const trend = latest > prev ? "▲" : latest < prev ? "▼" : "─";
  const trendColor = latest > prev ? "#00b894" : latest < prev ? "#e74c3c" : "#636e72";

  return (
    <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
      <svg width={width} height={height} style={{ overflow: "visible" }}>
        <defs>
          <linearGradient id={`grad-${color.replace("#","")}`} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={color} stopOpacity="0.3" />
            <stop offset="100%" stopColor={color} stopOpacity="0.02" />
          </linearGradient>
        </defs>
        {path && (
          <>
            <path d={path + ` L${width},${height} L0,${height} Z`}
              fill={`url(#grad-${color.replace("#","")})`} />
            <path d={path} fill="none" stroke={color} strokeWidth="1.5"
              strokeLinecap="round" strokeLinejoin="round" />
            <circle cx={width} cy={height - ((latest - Math.min(...data)) / (Math.max(...data) - Math.min(...data) || 1)) * height}
              r="2.5" fill={color} />
          </>
        )}
      </svg>
      {label && (
        <span style={{ fontSize: 10, color: trendColor, fontWeight: 700 }}>
          {trend} {latest?.toFixed?.(0) ?? latest}
        </span>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// REDASH DASHBOARD - CORE IN-GAME MECHANIC
// ═══════════════════════════════════════════════════════════════

function RedashDashboard({ gameData, isOpen, onClose, onDecision, upgrades }) {
  const [redashUrl, setRedashUrl] = useState(
    localStorage?.getItem?.("redash_url") || ""
  );
  const [redashInput, setRedashInput] = useState(redashUrl);
  const [iframeLoaded, setIframeLoaded] = useState(false);
  const [autoConnecting, setAutoConnecting] = useState(false);
  const [leaderboardData, setLeaderboardData] = useState([]);
  const [dataLoading, setDataLoading] = useState(false);

  const hasPro = upgrades.includes("redash_pro");
  const insightBoost = hasPro ? 1.2 : 1;

  // 백엔드에서 리더보드 데이터 가져오기
  useEffect(() => {
    if (!isOpen) return;
    setDataLoading(true);
    fetch("/api/leaderboard?limit=20")
      .then(res => res.json())
      .then(data => setLeaderboardData(Array.isArray(data) ? data : []))
      .catch(() => setLeaderboardData([]))
      .finally(() => setDataLoading(false));
  }, [isOpen]);

  // 백엔드에서 Redash URL 자동 가져오기
  useEffect(() => {
    if (redashUrl || autoConnecting) return;
    setAutoConnecting(true);

    fetch("/api/redash/dashboard-url")
      .then(res => res.json())
      .then(data => {
        if (data.url) {
          setRedashUrl(data.url);
          setRedashInput(data.url);
          try { localStorage?.setItem?.("redash_url", data.url); } catch {}
        }
      })
      .catch(() => {
        // 백엔드 연결 실패시 무시 (오프라인 모드)
      })
      .finally(() => setAutoConnecting(false));
  }, []);

  if (!isOpen) return null;

  const saveRedashUrl = () => {
    const cleaned = redashInput.trim();
    setRedashUrl(cleaned);
    setIframeLoaded(false);
    try { localStorage?.setItem?.("redash_url", cleaned); } catch {}
  };

  return (
    <div style={{
      position: "fixed", inset: 0, zIndex: 10000,
      background: "rgba(10,10,25,0.95)", backdropFilter: "blur(8px)",
      display: "flex", alignItems: "center", justifyContent: "center",
    }}>
      <div style={{
        width: "90%", maxWidth: 700, maxHeight: "90vh",
        background: "linear-gradient(145deg, #0d1117, #161b22)",
        borderRadius: 20, border: "1px solid #30363d",
        boxShadow: "0 24px 80px rgba(0,0,0,0.6)",
        display: "flex", flexDirection: "column",
        overflow: "hidden",
      }}>
        {/* Header */}
        <div style={{
          padding: "20px 24px",
          borderBottom: "1px solid #30363d",
          textAlign: "center",
        }}>
          <div style={{ fontSize: 48, marginBottom: 8 }}>📊</div>
          <h2 style={{ color: "#e6edf3", margin: 0, fontSize: 22 }}>
            Redash 실시간 대시보드 {hasPro && <span style={{ color: "#f39c12", fontSize: 14 }}>✨ PRO</span>}
          </h2>
        </div>

        {/* Content */}
        <div style={{ padding: 24, flex: 1, overflowY: "auto" }}>
          {/* Pro 혜택 안내 */}
          {hasPro && (
            <div style={{
              padding: 12, background: "linear-gradient(90deg, #f39c1222, #fdcb6e22)",
              borderRadius: 8, border: "1px solid #f39c12", marginBottom: 16,
              fontSize: 11, color: "#f39c12", textAlign: "center",
            }}>
              ✨ Redash Pro 활성화: 분석 정밀도 +20%, 고급 차트 잠금 해제
            </div>
          )}

          {/* KPI 요약 */}
          <div style={{
            padding: 16, background: "#161b22", borderRadius: 12,
            border: "1px solid #30363d", marginBottom: 20,
          }}>
            <div style={{ fontSize: 11, color: "#8b949e", marginBottom: 12 }}>
              현재 게임 KPI {hasPro && <span style={{ color: "#f39c12" }}>(정밀도 ×{insightBoost.toFixed(1)})</span>}
            </div>
            <div style={{ display: "flex", justifyContent: "space-around" }}>
              <div>
                <div style={{ fontSize: 20, color: "#e74c3c" }}>⚡</div>
                <div style={{ fontSize: 11, color: "#8b949e" }}>
                  에너지: {Math.round(gameData.currentKpi.energy * insightBoost)}
                </div>
              </div>
              <div>
                <div style={{ fontSize: 20, color: "#3498db" }}>🛡️</div>
                <div style={{ fontSize: 11, color: "#8b949e" }}>
                  안전성: {Math.round(gameData.currentKpi.stability * insightBoost)}
                </div>
              </div>
              <div>
                <div style={{ fontSize: 20, color: "#2ecc71" }}>⚙️</div>
                <div style={{ fontSize: 11, color: "#8b949e" }}>
                  생산성: {Math.round(gameData.currentKpi.productivity * insightBoost)}
                </div>
              </div>
            </div>
          </div>

          {/* URL 입력 */}
          <div style={{
            padding: 16, background: "#0d1117", borderRadius: 12,
            border: redashUrl ? "1px solid #00b89433" : "1px solid #30363d",
            marginBottom: 16,
          }}>
            <div style={{
              display: "flex", alignItems: "center", justifyContent: "space-between",
              marginBottom: 10,
            }}>
              <div style={{ fontSize: 13, fontWeight: 700, color: "#e6edf3" }}>
                🔴 Redash Public URL
              </div>
              {redashUrl && (
                <div style={{
                  padding: "2px 8px", borderRadius: 6, fontSize: 9,
                  background: "#00b89411", border: "1px solid #00b89433",
                  color: "#00b894", fontWeight: 600,
                }}>
                  ✅ 연결됨
                </div>
              )}
            </div>
            {autoConnecting ? (
              <div style={{ fontSize: 11, color: "#8b949e", padding: "10px", textAlign: "center" }}>
                🔄 백엔드에서 Redash URL 자동 가져오는 중...
              </div>
            ) : (
              <>
                <div style={{ fontSize: 11, color: "#8b949e", marginBottom: 12, lineHeight: 1.6 }}>
                  Redash에서 Dashboard → Share → "Allow public access" → Public URL 복사
                </div>
                <div style={{ display: "flex", gap: 8 }}>
                  <input
                    value={redashInput}
                    onChange={e => setRedashInput(e.target.value)}
                    onKeyDown={e => e.key === "Enter" && saveRedashUrl()}
                    placeholder="http://localhost:5000/public/dashboards/..."
                    style={{
                      flex: 1, padding: "10px 12px", borderRadius: 8,
                      background: "#161b22", border: "1px solid #30363d",
                      color: "#e6edf3", fontSize: 12, outline: "none",
                      fontFamily: "monospace",
                    }}
                  />
                  <button
                    onClick={saveRedashUrl}
                    disabled={!redashInput.trim()}
                    style={{
                      padding: "10px 20px", borderRadius: 8, border: "none",
                      background: redashInput.trim()
                        ? "linear-gradient(135deg, #00b894, #00cec9)"
                        : "#21262d",
                      color: redashInput.trim() ? "#fff" : "#8b949e",
                      fontSize: 12, fontWeight: 700,
                      cursor: redashInput.trim() ? "pointer" : "not-allowed",
                    }}>
                    연결
                  </button>
                </div>
              </>
            )}
          </div>

          {/* Iframe */}
          {redashUrl && (
            <div style={{
              borderRadius: 12, overflow: "hidden",
              border: "1px solid #30363d", minHeight: 400,
              background: "#0d1117",
            }}>
              <iframe
                src={redashUrl}
                style={{
                  width: "100%", height: 400, border: "none",
                  display: iframeLoaded ? "block" : "none",
                }}
                onLoad={() => setIframeLoaded(true)}
                sandbox="allow-scripts allow-same-origin"
              />
              {!iframeLoaded && (
                <div style={{
                  height: 400, display: "flex", alignItems: "center",
                  justifyContent: "center", color: "#8b949e", fontSize: 12,
                }}>
                  📊 대시보드 로딩 중...
                </div>
              )}
            </div>
          )}

          {/* 리더보드 데이터 (Redash 대체) */}
          <div style={{
            padding: 16, background: "#0d1117", borderRadius: 12,
            border: "1px solid #30363d", marginTop: 16,
          }}>
            <div style={{
              display: "flex", alignItems: "center", justifyContent: "space-between",
              marginBottom: 12,
            }}>
              <div style={{ fontSize: 14, fontWeight: 700, color: "#e6edf3" }}>
                👑 리더보드 (Top 20)
              </div>
              {dataLoading && (
                <div style={{ fontSize: 10, color: "#8b949e" }}>🔄 로딩 중...</div>
              )}
            </div>

            {leaderboardData.length > 0 ? (
              <div style={{ overflowX: "auto" }}>
                <table style={{
                  width: "100%", fontSize: 11, color: "#e6edf3",
                  borderCollapse: "collapse",
                }}>
                  <thead>
                    <tr style={{ borderBottom: "1px solid #30363d" }}>
                      <th style={{ padding: "8px 4px", textAlign: "center", color: "#8b949e" }}>순위</th>
                      <th style={{ padding: "8px 4px", textAlign: "left", color: "#8b949e" }}>닉네임</th>
                      <th style={{ padding: "8px 4px", textAlign: "right", color: "#8b949e" }}>점수</th>
                      <th style={{ padding: "8px 4px", textAlign: "center", color: "#8b949e" }}>등급</th>
                      <th style={{ padding: "8px 4px", textAlign: "right", color: "#8b949e" }}>게임수</th>
                      <th style={{ padding: "8px 4px", textAlign: "right", color: "#8b949e" }}>에너지</th>
                      <th style={{ padding: "8px 4px", textAlign: "right", color: "#8b949e" }}>안전성</th>
                      <th style={{ padding: "8px 4px", textAlign: "right", color: "#8b949e" }}>생산성</th>
                    </tr>
                  </thead>
                  <tbody>
                    {leaderboardData.map((row, idx) => (
                      <tr key={idx} style={{
                        borderBottom: "1px solid #21262d",
                        background: idx % 2 === 0 ? "#0d111711" : "transparent",
                      }}>
                        <td style={{ padding: "8px 4px", textAlign: "center", fontWeight: 700 }}>
                          {row.rank_by_score <= 3 ? ["🥇", "🥈", "🥉"][row.rank_by_score - 1] : row.rank_by_score}
                        </td>
                        <td style={{ padding: "8px 4px", fontWeight: 600 }}>{row.nickname}</td>
                        <td style={{ padding: "8px 4px", textAlign: "right", color: "#f39c12" }}>
                          {row.best_score?.toLocaleString()}
                        </td>
                        <td style={{ padding: "8px 4px", textAlign: "center" }}>
                          <span style={{
                            padding: "2px 6px", borderRadius: 4, fontSize: 9,
                            background: row.best_grade === "S+" || row.best_grade === "S" ? "#e74c3c22" : "#3498db22",
                            color: row.best_grade === "S+" || row.best_grade === "S" ? "#e74c3c" : "#3498db",
                          }}>
                            {row.best_grade}
                          </span>
                        </td>
                        <td style={{ padding: "8px 4px", textAlign: "right", color: "#8b949e" }}>
                          {row.total_games}
                        </td>
                        <td style={{ padding: "8px 4px", textAlign: "right", color: "#e74c3c" }}>
                          {Math.round(row.best_energy)}
                        </td>
                        <td style={{ padding: "8px 4px", textAlign: "right", color: "#3498db" }}>
                          {Math.round(row.best_stability)}
                        </td>
                        <td style={{ padding: "8px 4px", textAlign: "right", color: "#2ecc71" }}>
                          {Math.round(row.best_productivity)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <div style={{
                padding: 20, textAlign: "center", color: "#8b949e", fontSize: 11,
              }}>
                {dataLoading ? "데이터 로딩 중..." : "게임을 플레이하면 리더보드에 등록됩니다!"}
              </div>
            )}
          </div>
        </div>

        {/* Footer */}
        <div style={{
          padding: "16px 24px",
          borderTop: "1px solid #30363d",
          textAlign: "center",
        }}>
          <button
            onClick={onClose}
            style={{
              padding: "12px 32px", borderRadius: 12, border: "none",
              background: "linear-gradient(135deg, #00b894, #00cec9)",
              color: "#fff", fontSize: 14, fontWeight: 700,
              cursor: "pointer",
            }}>
            닫기
          </button>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// QUALITY INSPECTION EVENT
// ═══════════════════════════════════════════════════════════════

function QualityInspection({ event, onResolve, onFail, timeLeft }) {
  const [choice, setChoice] = useState(null);

  const options = [
    { id: "fix", label: "⚙️ 즉시 수리", desc: "시간 -5초, 안전성 유지", cost: 0 },
    { id: "skip", label: "⏭️ 무시하고 진행", desc: "시간 유지, 안전성↓↓", cost: 0 },
    { id: "item", label: "💎 아이템 사용", desc: "시간&안전 모두 유지", cost: 100 },
  ];

  return (
    <div style={{
      position: "absolute", inset: 0, zIndex: 5000,
      background: "rgba(15,15,25,0.9)", backdropFilter: "blur(6px)",
      display: "flex", alignItems: "center", justifyContent: "center",
      animation: "fadeIn 0.3s",
    }}>
      <div style={{
        background: "linear-gradient(145deg, #1a1a2e, #16213e)",
        borderRadius: 20, padding: 24, maxWidth: 380, width: "90%",
        border: event.severity === "critical" ? "2px solid #e74c3c" : "2px solid #f39c12",
        boxShadow: `0 16px 48px rgba(0,0,0,0.4), 0 0 30px ${event.severity === "critical" ? "#e74c3c22" : "#f39c1222"}`,
      }}>
        <div style={{ textAlign: "center", marginBottom: 16 }}>
          <div style={{ fontSize: 42, marginBottom: 8 }}>
            {event.severity === "critical" ? "🚨" : "⚠️"}
          </div>
          <div style={{ fontSize: 16, fontWeight: 800, color: "#e6edf3" }}>
            품질 검사 이벤트!
          </div>
          <div style={{
            display: "inline-block", marginTop: 6, padding: "3px 10px",
            borderRadius: 12, fontSize: 10, fontWeight: 700,
            background: event.severity === "critical" ? "#e74c3c22" : "#f39c1222",
            color: event.severity === "critical" ? "#e74c3c" : "#f39c12",
            border: `1px solid ${event.severity === "critical" ? "#e74c3c44" : "#f39c1244"}`,
          }}>
            {event.severity === "critical" ? "CRITICAL" : "WARNING"}
          </div>
        </div>

        <div style={{
          padding: 12, background: "#0d1117", borderRadius: 10, marginBottom: 16,
          border: "1px solid #30363d",
        }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: "#e6edf3", marginBottom: 4 }}>
            {event.name}
          </div>
          <div style={{ fontSize: 11, color: "#8b949e" }}>{event.desc}</div>
        </div>

        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          {options.map(o => (
            <button key={o.id}
              onClick={() => { setChoice(o.id); o.id === "skip" ? onFail(event) : onResolve(event, o.id); }}
              style={{
                padding: "10px 14px", borderRadius: 12, cursor: "pointer",
                background: "#21262d", border: "1px solid #30363d",
                display: "flex", alignItems: "center", gap: 10,
                transition: "all 0.2s", textAlign: "left",
              }}
              onMouseEnter={e => { e.currentTarget.style.borderColor = "#00b894"; e.currentTarget.style.background = "#00b89411"; }}
              onMouseLeave={e => { e.currentTarget.style.borderColor = "#30363d"; e.currentTarget.style.background = "#21262d"; }}
            >
              <span style={{ fontSize: 12, fontWeight: 700, color: "#e6edf3" }}>{o.label}</span>
              <span style={{ fontSize: 10, color: "#8b949e", flex: 1 }}>{o.desc}</span>
              {o.cost > 0 && <span style={{ fontSize: 10, color: "#f39c12" }}>💰{o.cost}</span>}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// UPGRADE SHOP
// ═══════════════════════════════════════════════════════════════

function UpgradeShop({ coins, ownedUpgrades, onBuy, onClose }) {
  return (
    <div style={{
      position: "fixed", inset: 0, zIndex: 10000,
      background: "rgba(10,10,25,0.85)", backdropFilter: "blur(8px)",
      display: "flex", alignItems: "center", justifyContent: "center",
    }}>
      <div style={{
        width: "90%", maxWidth: 500, background: "linear-gradient(145deg, #0d1117, #161b22)",
        borderRadius: 20, overflow: "hidden", border: "1px solid #30363d",
        boxShadow: "0 24px 80px rgba(0,0,0,0.6)",
      }}>
        <div style={{
          padding: "16px 20px", display: "flex", alignItems: "center", justifyContent: "space-between",
          borderBottom: "1px solid #30363d",
        }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: "#e6edf3" }}>🏪 업그레이드 상점</div>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <span style={{ fontSize: 13, color: "#f39c12", fontWeight: 700 }}>💰 {coins}</span>
            <button onClick={onClose} style={{
              background: "#21262d", border: "1px solid #30363d", borderRadius: 8,
              color: "#8b949e", cursor: "pointer", padding: "4px 10px", fontSize: 16,
            }}>✕</button>
          </div>
        </div>
        <div style={{ padding: 16, maxHeight: 400, overflow: "auto" }}>
          {UPGRADES.map(u => {
            const owned = ownedUpgrades.includes(u.id);
            const canBuy = coins >= u.cost && !owned;
            return (
              <div key={u.id} style={{
                display: "flex", alignItems: "center", gap: 12, padding: 12, marginBottom: 8,
                background: owned ? "#00b89411" : "#161b22", borderRadius: 12,
                border: owned ? "1px solid #00b89433" : "1px solid #30363d",
                opacity: owned ? 0.7 : 1,
              }}>
                <div style={{ fontSize: 28 }}>{u.icon}</div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: "#e6edf3" }}>{u.name}</div>
                  <div style={{ fontSize: 10, color: "#8b949e" }}>{u.desc}</div>
                </div>
                <button onClick={() => canBuy && onBuy(u)}
                  disabled={!canBuy}
                  style={{
                    padding: "6px 14px", borderRadius: 8, border: "none",
                    background: owned ? "#00b894" : canBuy ? "#f39c12" : "#21262d",
                    color: owned || canBuy ? "#fff" : "#484f58",
                    fontSize: 11, fontWeight: 700, cursor: canBuy ? "pointer" : "default",
                  }}>
                  {owned ? "보유 ✓" : `💰 ${u.cost}`}
                </button>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// LEADERBOARD
// ═══════════════════════════════════════════════════════════════

function Leaderboard({ playerScore, playerKpi, onClose }) {
  const fakeLeaders = useMemo(() => [
    { rank: 1, name: "Dr.Battery🏆", score: 4850, energy: 92, stability: 88, productivity: 85, badge: "🥇" },
    { rank: 2, name: "CellMaster", score: 4520, energy: 85, stability: 91, productivity: 82, badge: "🥈" },
    { rank: 3, name: "VoltageKing", score: 4200, energy: 90, stability: 78, productivity: 88, badge: "🥉" },
    { rank: 4, name: "LiIonPro", score: 3980, energy: 82, stability: 85, productivity: 80, badge: "4" },
    { rank: 5, name: "AnodeMaster", score: 3750, energy: 78, stability: 83, productivity: 86, badge: "5" },
  ], []);

  const playerRank = fakeLeaders.filter(l => l.score > playerScore).length + 1;

  return (
    <div style={{
      position: "fixed", inset: 0, zIndex: 10000,
      background: "rgba(10,10,25,0.85)", backdropFilter: "blur(8px)",
      display: "flex", alignItems: "center", justifyContent: "center",
    }}>
      <div style={{
        width: "90%", maxWidth: 500, background: "linear-gradient(145deg, #0d1117, #161b22)",
        borderRadius: 20, overflow: "hidden", border: "1px solid #30363d",
        boxShadow: "0 24px 80px rgba(0,0,0,0.6)",
      }}>
        <div style={{
          padding: "16px 20px", borderBottom: "1px solid #30363d",
          display: "flex", justifyContent: "space-between", alignItems: "center",
        }}>
          <span style={{ fontSize: 15, fontWeight: 700, color: "#e6edf3" }}>🏆 글로벌 랭킹</span>
          <button onClick={onClose} style={{
            background: "#21262d", border: "1px solid #30363d", borderRadius: 8,
            color: "#8b949e", cursor: "pointer", padding: "4px 10px", fontSize: 16,
          }}>✕</button>
        </div>
        <div style={{ padding: 16 }}>
          {/* Player entry */}
          <div style={{
            padding: 12, marginBottom: 12, borderRadius: 12,
            background: "linear-gradient(135deg, #00b89411, #00cec911)",
            border: "2px solid #00b89444",
          }}>
            <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
              <span style={{ fontSize: 18, fontWeight: 800, color: "#00b894" }}>#{playerRank}</span>
              <span style={{ fontSize: 13, fontWeight: 700, color: "#e6edf3", flex: 1 }}>나 (You)</span>
              <span style={{ fontSize: 15, fontWeight: 800, color: "#f39c12" }}>{playerScore}점</span>
            </div>
            <div style={{ display: "flex", gap: 8, marginTop: 6 }}>
              {Object.entries(KPI_NAMES).map(([k, name]) => (
                <span key={k} style={{ fontSize: 9, color: KPI_COLORS[k], fontWeight: 600 }}>
                  {KPI_ICONS[k]} {Math.round(playerKpi[k])}
                </span>
              ))}
            </div>
          </div>

          {/* Top players */}
          {fakeLeaders.map(l => (
            <div key={l.rank} style={{
              display: "flex", alignItems: "center", gap: 10, padding: "8px 10px",
              marginBottom: 4, borderRadius: 8, background: "#161b22",
            }}>
              <span style={{ fontSize: 14, width: 24, textAlign: "center" }}>{l.badge}</span>
              <span style={{ fontSize: 12, color: "#e6edf3", flex: 1, fontWeight: 600 }}>{l.name}</span>
              <div style={{ display: "flex", gap: 6 }}>
                {["energy", "stability", "productivity"].map(k => (
                  <span key={k} style={{ fontSize: 9, color: KPI_COLORS[k] }}>{l[k]}</span>
                ))}
              </div>
              <span style={{ fontSize: 12, fontWeight: 700, color: "#f39c12", width: 50, textAlign: "right" }}>
                {l.score}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}


// ═══════════════════════════════════════════════════════════════
// STAGE COMPONENTS (Simplified but functional)
// ═══════════════════════════════════════════════════════════════

function MixingStage({ onComplete, addScore, strategy }) {
  const [added, setAdded] = useState([]);
  const [mixing, setMixing] = useState(false);
  const [mixProgress, setMixProgress] = useState(0);
  const materials = STAGES[0].materials;
  const nextIdx = added.length;

  const handleAdd = (mat, idx) => {
    if (mixing || idx !== nextIdx) return;
    setAdded([...added, mat.id]);
    addScore(25, "energy");
  };

  useEffect(() => {
    if (added.length === 4) {
      setMixing(true);
      let p = 0;
      const iv = setInterval(() => {
        p += 3;
        setMixProgress(p);
        if (p >= 100) { clearInterval(iv); addScore(100, "energy"); setTimeout(onComplete, 500); }
      }, 40);
      return () => clearInterval(iv);
    }
  }, [added]);

  return (
    <div style={{ textAlign: "center", padding: 16 }}>
      <div style={{
        width: 160, height: 160, margin: "0 auto 24px", borderRadius: "50%",
        background: mixing
          ? "conic-gradient(#e74c3c, #2c3e50, #f39c12, #3498db, #e74c3c)"
          : `radial-gradient(circle, ${added.length > 0 ? "#dfe6e9" : "#f8f9fa"} 60%, #b2bec3)`,
        border: "5px solid #636e72", display: "flex", alignItems: "center",
        justifyContent: "center", flexDirection: "column", position: "relative",
        animation: mixing ? "spin 1s linear infinite" : "none",
        boxShadow: "0 8px 24px rgba(0,0,0,0.15), inset 0 -4px 8px rgba(0,0,0,0.1)",
      }}>
        {!mixing ? (
          <>
            <div style={{ fontSize: 32 }}>🧫</div>
            <div style={{ fontSize: 12, color: "#636e72", fontWeight: 600 }}>{added.length}/4</div>
          </>
        ) : (
          <div style={{ fontSize: 13, color: "#fff", fontWeight: "bold" }}>혼합 {mixProgress}%</div>
        )}
      </div>
      <div style={{ display: "flex", gap: 12, justifyContent: "center", flexWrap: "wrap" }}>
        {materials.map((mat, idx) => {
          const isAdded = added.includes(mat.id);
          const isNext = idx === nextIdx;
          return (
            <button key={mat.id} onClick={() => handleAdd(mat, idx)}
              disabled={isAdded || mixing}
              style={{
                padding: "12px 16px", borderRadius: 14,
                border: isNext ? `3px solid ${mat.color}` : "3px solid #dfe6e9",
                background: isAdded ? "#dfe6e9" : "#fff",
                cursor: isAdded ? "default" : "pointer", opacity: isAdded ? 0.4 : 1,
                fontSize: 14, fontWeight: 600, display: "flex", flexDirection: "column",
                alignItems: "center", gap: 4,
                transform: isNext && !isAdded ? "scale(1.05)" : "scale(1)",
                animation: isNext && !isAdded ? "pulse 1.5s infinite" : "none",
                boxShadow: isNext ? `0 4px 12px ${mat.color}40` : "none",
              }}>
              <span style={{ fontSize: 28 }}>{mat.emoji}</span>
              <span style={{ color: "#2d3436", fontSize: 12 }}>{mat.name}</span>
              {isNext && !isAdded && <span style={{ fontSize: 10, color: mat.color }}>▲ 다음</span>}
            </button>
          );
        })}
      </div>
      {mixing && (
        <div style={{ marginTop: 20, height: 10, borderRadius: 5, background: "#dfe6e9", maxWidth: 280, margin: "20px auto 0" }}>
          <div style={{ width: `${mixProgress}%`, height: "100%", background: "linear-gradient(90deg, #e74c3c, #f39c12, #3498db)", borderRadius: 5 }} />
        </div>
      )}
    </div>
  );
}

function CoatingStage({ onComplete, addScore }) {
  const [gauge, setGauge] = useState(0);
  const [dir, setDir] = useState(1);
  const [coatings, setCoatings] = useState(0);
  const [results, setResults] = useState([]);
  const needed = 3;
  const ivRef = useRef(null);

  useEffect(() => {
    ivRef.current = setInterval(() => {
      setGauge(g => {
        const next = g + dir * 2.5;
        if (next >= 100 || next <= 0) setDir(d => -d);
        return clamp(next, 0, 100);
      });
    }, 30);
    return () => clearInterval(ivRef.current);
  }, [dir]);

  const handleClick = () => {
    if (coatings >= needed) return;
    const diff = Math.abs(gauge - 50);
    let pts = 0, label = "";
    if (diff < 5) { pts = 100; label = "PERFECT!"; }
    else if (diff < 15) { pts = 60; label = "GREAT!"; }
    else if (diff < 25) { pts = 30; label = "GOOD"; }
    else { pts = 10; label = "MISS"; }
    addScore(pts, "stability");
    setResults([...results, { label, pts }]);
    const nc = coatings + 1;
    setCoatings(nc);
    if (nc >= needed) { clearInterval(ivRef.current); setTimeout(onComplete, 700); }
  };

  return (
    <div style={{ textAlign: "center", padding: 16 }}>
      <div style={{
        width: "88%", maxWidth: 380, height: 50, margin: "0 auto 16px",
        background: "linear-gradient(90deg, #bdc3c7, #ecf0f1, #bdc3c7)",
        borderRadius: 8, border: "2px solid #95a5a6", position: "relative", overflow: "hidden",
      }}>
        {results.map((a, i) => (
          <div key={i} style={{
            position: "absolute", left: `${i * (100/needed)}%`, width: `${100/needed}%`, height: "100%",
            background: a.pts >= 60 ? "linear-gradient(180deg, #e74c3c88, #c0392b88)" : "linear-gradient(180deg, #e74c3c44, #c0392b44)",
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: 11, fontWeight: "bold", color: "#fff", textShadow: "0 1px 2px rgba(0,0,0,0.5)",
          }}>{a.label}</div>
        ))}
        <div style={{ position: "absolute", top: 4, left: 8, fontSize: 10, color: "#7f8c8d", fontWeight: 600 }}>
          알루미늄 포일 (집전체)
        </div>
      </div>
      <div style={{
        width: "88%", maxWidth: 380, height: 36, margin: "0 auto 12px",
        background: "#2d3436", borderRadius: 18, position: "relative", overflow: "hidden",
      }}>
        <div style={{ position: "absolute", left: "40%", width: "20%", height: "100%", background: "#00b89422", borderLeft: "2px dashed #00b894", borderRight: "2px dashed #00b894" }} />
        <div style={{
          position: "absolute", left: `${gauge}%`, top: 0, width: 4, height: "100%",
          background: "#f39c12", borderRadius: 2, transition: "left 0.03s linear", boxShadow: "0 0 8px #f39c12",
        }} />
        <div style={{ position: "absolute", width: "100%", textAlign: "center", top: 9, fontSize: 13, color: "#fff", fontWeight: 600 }}>
          코팅 {Math.min(coatings + 1, needed)}/{needed}
        </div>
      </div>
      <button onClick={handleClick} disabled={coatings >= needed}
        style={{
          padding: "14px 44px", fontSize: 16, fontWeight: "bold", borderRadius: 28,
          border: "none", background: coatings >= needed ? "#95a5a6" : "linear-gradient(135deg, #00b894, #00cec9)",
          color: "#fff", cursor: coatings >= needed ? "default" : "pointer", boxShadow: "0 4px 12px rgba(0,184,148,0.4)",
        }}>🖌️ 코팅!</button>
    </div>
  );
}

function PressingStage({ onComplete, addScore }) {
  const [thickness, setThickness] = useState(100);
  const [pressing, setPressing] = useState(false);
  const [done, setDone] = useState(false);
  const target = 30;
  const holdRef = useRef(null);

  const startPress = () => {
    if (done) return;
    setPressing(true);
    holdRef.current = setInterval(() => setThickness(t => Math.max(0, t - 1)), 30);
  };
  const stopPress = () => {
    setPressing(false);
    clearInterval(holdRef.current);
    const diff = Math.abs(thickness - target);
    let pts = diff < 3 ? 150 : diff < 8 ? 100 : diff < 15 ? 50 : 20;
    addScore(pts, "energy");
    setDone(true);
    setTimeout(onComplete, 800);
  };
  useEffect(() => () => clearInterval(holdRef.current), []);

  const perfect = Math.abs(thickness - target) < 3;
  const great = Math.abs(thickness - target) < 8;

  return (
    <div style={{ textAlign: "center", padding: 16 }}>
      <div style={{ position: "relative", width: 260, height: 160, margin: "0 auto 20px" }}>
        <div style={{
          position: "absolute", top: pressing ? 50 : 25, left: 30, width: 200, height: 36, borderRadius: 18,
          background: "linear-gradient(180deg, #636e72, #b2bec3, #636e72)", border: "2px solid #2d3436",
          transition: "top 0.15s", animation: pressing ? "rollerSpin 0.5s linear infinite" : "none",
        }} />
        <div style={{
          position: "absolute", top: 82, left: 20, width: 220, height: Math.max(6, thickness * 0.5),
          background: perfect ? "linear-gradient(90deg, #00b894, #55efc4)" : great ? "linear-gradient(90deg, #fdcb6e, #ffeaa7)" : "linear-gradient(90deg, #e74c3c, #fab1a0)",
          borderRadius: 3, transition: "height 0.05s, background 0.3s",
          display: "flex", alignItems: "center", justifyContent: "center", fontSize: 10, fontWeight: "bold", color: "#2d3436",
        }}>두께: {thickness}μm → 목표: {target}μm</div>
        <div style={{
          position: "absolute", bottom: pressing ? 42 : 15, left: 30, width: 200, height: 36, borderRadius: 18,
          background: "linear-gradient(180deg, #636e72, #b2bec3, #636e72)", border: "2px solid #2d3436",
          transition: "bottom 0.15s",
        }} />
      </div>
      <div style={{
        width: "75%", maxWidth: 260, height: 20, margin: "0 auto 16px",
        background: "#2d3436", borderRadius: 10, position: "relative", overflow: "hidden",
      }}>
        <div style={{
          position: "absolute", left: `${target - 3}%`, width: "6%", height: "100%",
          background: "#00b89444", borderLeft: "2px solid #00b894", borderRight: "2px solid #00b894",
        }} />
        <div style={{
          width: `${thickness}%`, height: "100%", borderRadius: 10,
          background: perfect ? "#00b894" : great ? "#fdcb6e" : "#e74c3c", transition: "width 0.05s",
        }} />
      </div>
      <button
        onMouseDown={startPress} onMouseUp={stopPress} onMouseLeave={stopPress}
        onTouchStart={startPress} onTouchEnd={stopPress}
        disabled={done}
        style={{
          padding: "14px 44px", fontSize: 16, fontWeight: "bold", borderRadius: 28, border: "none",
          background: done ? "#95a5a6" : pressing ? "#e74c3c" : "linear-gradient(135deg, #00b894, #00cec9)",
          color: "#fff", cursor: done ? "default" : "pointer", boxShadow: "0 4px 12px rgba(0,184,148,0.4)",
          transform: pressing ? "scale(0.96)" : "scale(1)", transition: "all 0.1s",
        }}>
        {done ? "✅ 완료!" : pressing ? "🔧 누르는 중..." : "🔧 꾹 누르세요!"}
      </button>
      <style>{`@keyframes rollerSpin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}

function CuttingStage({ onComplete, addScore }) {
  const [cuts, setCuts] = useState([]);
  const [targetX, setTargetX] = useState(50);
  const needed = 4;

  useEffect(() => { setTargetX(20 + Math.random() * 60); }, [cuts.length]);

  const handleCut = (e) => {
    if (cuts.length >= needed) return;
    const rect = e.currentTarget.getBoundingClientRect();
    const x = ((e.clientX - rect.left) / rect.width) * 100;
    const diff = Math.abs(x - targetX);
    let pts = diff < 5 ? 100 : diff < 12 ? 60 : diff < 20 ? 30 : 10;
    addScore(pts, "productivity");
    const nc = [...cuts, { x, pts, target: targetX }];
    setCuts(nc);
    if (nc.length >= needed) setTimeout(onComplete, 700);
  };

  return (
    <div style={{ textAlign: "center", padding: 16 }}>
      <div style={{ fontSize: 13, color: "#636e72", marginBottom: 12, fontWeight: 600 }}>
        ✂️ 빨간 선에 맞춰 클릭하세요! ({cuts.length}/{needed})
      </div>
      <div onClick={handleCut} style={{
        width: "90%", maxWidth: 400, height: 100, margin: "0 auto 16px",
        background: "linear-gradient(180deg, #dfe6e9, #b2bec3)", borderRadius: 10,
        border: "2px solid #95a5a6", position: "relative", cursor: "crosshair", overflow: "hidden",
      }}>
        {/* Target line */}
        <div style={{
          position: "absolute", left: `${targetX}%`, top: 0, width: 2, height: "100%",
          background: "#e74c3c", boxShadow: "0 0 8px #e74c3c88",
          animation: "pulse 1s infinite",
        }} />
        {/* Cut marks */}
        {cuts.map((c, i) => (
          <div key={i} style={{
            position: "absolute", left: `${c.x}%`, top: 0, width: 2, height: "100%",
            background: c.pts >= 60 ? "#00b894" : "#f39c12",
          }}>
            <span style={{
              position: "absolute", top: -16, left: -12, fontSize: 10, fontWeight: 700,
              color: c.pts >= 60 ? "#00b894" : "#f39c12",
            }}>+{c.pts}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function AssemblyStage({ onComplete, addScore }) {
  const [placed, setPlaced] = useState([]);
  const layers = STAGES[4].layers;
  const nextIdx = placed.length;

  const handlePlace = (layer, idx) => {
    if (idx !== nextIdx) return;
    const newPlaced = [...placed, layer.id];
    setPlaced(newPlaced);
    addScore(40, "stability");
    if (newPlaced.length === 4) { addScore(80, "stability"); setTimeout(onComplete, 700); }
  };

  return (
    <div style={{ textAlign: "center", padding: 16 }}>
      <div style={{
        width: 180, margin: "0 auto 20px", padding: 12, borderRadius: 12,
        background: "#f8f9fa", border: "2px solid #dfe6e9", minHeight: 80,
      }}>
        {placed.length === 0 && <div style={{ fontSize: 11, color: "#b2bec3", padding: 16 }}>적층 영역</div>}
        {placed.map((id, i) => {
          const l = layers.find(la => la.id === id);
          return (
            <div key={i} style={{
              padding: "6px 12px", marginBottom: 3, borderRadius: 6,
              background: l.color, fontSize: 12, fontWeight: 600,
              color: l.id.includes("sep") ? "#2d3436" : "#fff",
              animation: "slideIn 0.3s ease-out",
            }}>
              {l.emoji} {l.name}
            </div>
          );
        })}
      </div>
      <div style={{ display: "flex", gap: 10, justifyContent: "center", flexWrap: "wrap" }}>
        {layers.map((l, idx) => {
          const isPlaced = placed.includes(l.id) && (l.id.includes("sep") ? placed.filter(p => p === l.id).length > 0 : true);
          const isNext = idx === nextIdx;
          return (
            <button key={`${l.id}-${idx}`} onClick={() => handlePlace(l, idx)}
              disabled={idx !== nextIdx}
              style={{
                padding: "10px 16px", borderRadius: 12,
                border: isNext ? `3px solid ${l.color === "#ecf0f1" ? "#636e72" : l.color}` : "3px solid #dfe6e9",
                background: idx < nextIdx ? "#dfe6e9" : "#fff",
                opacity: idx < nextIdx ? 0.4 : 1, cursor: isNext ? "pointer" : "default",
                fontSize: 13, fontWeight: 600, display: "flex", flexDirection: "column",
                alignItems: "center", gap: 3,
                animation: isNext ? "pulse 1.5s infinite" : "none",
              }}>
              <span style={{ fontSize: 24 }}>{l.emoji}</span>
              <span style={{ fontSize: 11 }}>{l.name}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}

function ActivationStage({ onComplete, addScore }) {
  const [phase, setPhase] = useState("inject"); // inject -> charge
  const [charge, setCharge] = useState(0);
  const [injected, setInjected] = useState(false);

  const handleInject = () => {
    setInjected(true);
    addScore(50, "stability");
    setTimeout(() => setPhase("charge"), 600);
  };

  useEffect(() => {
    if (phase !== "charge") return;
    const iv = setInterval(() => {
      setCharge(c => {
        if (c >= 100) {
          clearInterval(iv);
          return 100;
        }
        return c + 2;
      });
    }, 50);
    return () => clearInterval(iv);
  }, [phase]);

  useEffect(() => {
    if (charge >= 100) {
      addScore(100, "energy");
      setTimeout(onComplete, 500);
    }
  }, [charge]);

  return (
    <div style={{ textAlign: "center", padding: 16 }}>
      {phase === "inject" ? (
        <>
          <div style={{ fontSize: 48, marginBottom: 16, animation: injected ? "pulse 0.5s" : "none" }}>
            {injected ? "✅" : "🧪"}
          </div>
          <div style={{ fontSize: 13, color: "#636e72", marginBottom: 16 }}>전해액을 주입하세요!</div>
          <button onClick={handleInject} disabled={injected}
            style={{
              padding: "14px 44px", fontSize: 16, fontWeight: "bold", borderRadius: 28, border: "none",
              background: injected ? "#95a5a6" : "linear-gradient(135deg, #3498db, #2980b9)",
              color: "#fff", cursor: injected ? "default" : "pointer",
            }}>
            {injected ? "주입 완료!" : "💧 전해액 주입"}
          </button>
        </>
      ) : (
        <>
          <div style={{ fontSize: 48, marginBottom: 12 }}>⚡</div>
          <div style={{ fontSize: 13, color: "#636e72", marginBottom: 16 }}>충전 중... {charge}%</div>
          <div style={{
            width: "80%", maxWidth: 300, height: 24, margin: "0 auto",
            background: "#2d3436", borderRadius: 12, overflow: "hidden",
          }}>
            <div style={{
              width: `${charge}%`, height: "100%", borderRadius: 12,
              background: charge >= 80 ? "linear-gradient(90deg, #00b894, #55efc4)" : "linear-gradient(90deg, #f39c12, #fdcb6e)",
              transition: "width 0.1s",
            }} />
          </div>
        </>
      )}
    </div>
  );
}

function DryElectrodeStage({ onComplete, addScore }) {
  const [powder, setPowder] = useState([]);
  const spots = useMemo(() => Array.from({ length: 6 }, (_, i) => ({
    x: 10 + (i % 3) * 32, y: 20 + Math.floor(i / 3) * 40,
  })), []);

  const handleSpot = (i) => {
    if (powder.includes(i)) return;
    const np = [...powder, i];
    setPowder(np);
    addScore(35, "productivity");
    if (np.length >= spots.length) { addScore(100, "energy"); setTimeout(onComplete, 700); }
  };

  return (
    <div style={{ textAlign: "center", padding: 20, background: "#1a1a2e", borderRadius: 12 }}>
      <h2 style={{ color: "#fdcb6e", marginBottom: 16, fontSize: 18 }}>
        🌟 건식 전극 공정 - 분말 코팅
      </h2>
      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(3, 1fr)",
        gap: 12,
        maxWidth: 400,
        margin: "0 auto 20px"
      }}>
        {spots.map((s, i) => (
          <button
            key={i}
            onClick={() => handleSpot(i)}
            style={{
              padding: "20px",
              fontSize: 24,
              borderRadius: 12,
              border: powder.includes(i) ? "3px solid #00b894" : "3px dashed #e17055",
              background: powder.includes(i) ? "#00b894" : "#2d2d44",
              color: "#fff",
              cursor: powder.includes(i) ? "default" : "pointer",
              transition: "all 0.3s",
            }}
          >
            {powder.includes(i) ? "✅" : "🔘"}
          </button>
        ))}
      </div>
      <div style={{
        fontSize: 16,
        fontWeight: 700,
        color: powder.length === spots.length ? "#00b894" : "#fdcb6e",
        marginTop: 16
      }}>
        진행률: {powder.length}/{spots.length} ({Math.round((powder.length / spots.length) * 100)}%)
      </div>
    </div>
  );
}


// ═══════════════════════════════════════════════════════════════
// MAIN GAME COMPONENT
// ═══════════════════════════════════════════════════════════════

export default function BatteryGame() {
  // Core state
  const [screen, setScreen] = useState("title");
  const [currentStage, setCurrentStage] = useState(0);
  const [score, setScore] = useState(0);
  const [showStageIntro, setShowStageIntro] = useState(false);

  // Enhanced systems
  const [lives, setLives] = useState(GAME_CONFIG.MAX_LIVES);
  const [timer, setTimer] = useState(GAME_CONFIG.STAGE_TIME_LIMIT);
  const [combo, setCombo] = useState(0);
  const [maxCombo, setMaxCombo] = useState(0);
  const [isFever, setIsFever] = useState(false);
  const [feverTimer, setFeverTimer] = useState(null);
  const [coins, setCoins] = useState(200);
  const [ownedUpgrades, setOwnedUpgrades] = useState([]);
  const [strategy, setStrategy] = useState("balanced");
  const [highScore, setHighScore] = useState(0);

  // KPI state
  const [currentKpi, setCurrentKpi] = useState({ energy: 50, stability: 50, productivity: 50 });
  const [kpiHistory, setKpiHistory] = useState({ energy: [50], stability: [50], productivity: [50] });

  // Stage tracking
  const [stageResults, setStageResults] = useState([]);
  const [defectLog, setDefectLog] = useState([]);
  const [yieldRate, setYieldRate] = useState(100);
  const [stageScore, setStageScore] = useState(0);

  // UI state
  const [showRedash, setShowRedash] = useState(false);
  const [showShop, setShowShop] = useState(false);
  const [showLeaderboard, setShowLeaderboard] = useState(false);
  const [inspectionEvent, setInspectionEvent] = useState(null);
  const [scorePopups, setScorePopups] = useState([]);

  const timerRef = useRef(null);

  // Timer system
  useEffect(() => {
    if (screen !== "stage" || showStageIntro || inspectionEvent || showRedash) return;
    timerRef.current = setInterval(() => {
      setTimer(t => {
        if (t <= 1) {
          clearInterval(timerRef.current);
          handleTimerExpired();
          return 0;
        }
        return t - 1;
      });
    }, 1000);
    return () => clearInterval(timerRef.current);
  }, [screen, showStageIntro, currentStage, inspectionEvent, showRedash]);

  const handleTimerExpired = () => {
    setLives(l => {
      const newLives = l - 1;
      if (newLives <= 0) {
        saveGameData();
        setScreen("gameover");
      }
      return Math.max(0, newLives);
    });
    setCombo(0);
    if (lives > 1) {
      setTimer(GAME_CONFIG.STAGE_TIME_LIMIT);
    }
  };

  // Score system with KPI integration
  const addScore = useCallback((pts, kpiType = "energy") => {
    const multiplier = isFever ? GAME_CONFIG.FEVER_MULTIPLIER : 1;
    const strategyBonus = getStrategyBonus(strategy, kpiType);
    const upgradeBonus = getUpgradeBonus(ownedUpgrades, kpiType);
    const finalPts = Math.round(pts * multiplier * (1 + strategyBonus + upgradeBonus));

    setScore(s => s + finalPts);
    setStageScore(s => s + finalPts);
    setCoins(c => c + Math.floor(finalPts * 0.1));
    setCombo(c => {
      const nc = c + 1;
      setMaxCombo(m => Math.max(m, nc));
      if (nc >= GAME_CONFIG.COMBO_FEVER_THRESHOLD && !isFever) triggerFever();
      return nc;
    });

    // Update KPI
    const kpiDelta = (finalPts / 100) * 5;
    setCurrentKpi(prev => {
      const updated = { ...prev };
      if (kpiType === "all") {
        updated.energy = clamp(prev.energy + kpiDelta * 0.8, 0, 100);
        updated.stability = clamp(prev.stability + kpiDelta * 0.8, 0, 100);
        updated.productivity = clamp(prev.productivity + kpiDelta * 0.8, 0, 100);
      } else {
        updated[kpiType] = clamp(prev[kpiType] + kpiDelta, 0, 100);
        // Tradeoff: boosting one slightly reduces others
        const others = Object.keys(updated).filter(k => k !== kpiType);
        others.forEach(k => { updated[k] = clamp(updated[k] - kpiDelta * 0.15, 0, 100); });
      }
      return updated;
    });
  }, [isFever, strategy, ownedUpgrades]);

  function getStrategyBonus(strat, kpiType) {
    const map = {
      energy_focus: { energy: 0.2, stability: -0.1, productivity: 0 },
      safety_focus: { stability: 0.2, productivity: -0.1, energy: 0 },
      speed_focus: { productivity: 0.2, energy: -0.1, stability: 0 },
      balanced: { energy: 0.05, stability: 0.05, productivity: 0.05 },
    };
    return (map[strat]?.[kpiType]) || 0;
  }

  function getUpgradeBonus(upgrades, kpiType) {
    return upgrades.reduce((sum, uid) => {
      const u = UPGRADES.find(up => up.id === uid);
      if (!u) return sum;
      if (u.kpi === kpiType || u.kpi === "all") return sum + u.boost * 0.5;
      return sum;
    }, 0);
  }

  const triggerFever = () => {
    setIsFever(true);
    if (feverTimer) clearTimeout(feverTimer);
    const t = setTimeout(() => setIsFever(false), GAME_CONFIG.FEVER_DURATION);
    setFeverTimer(t);
  };

  // Stage completion
  const handleStageComplete = () => {
    clearInterval(timerRef.current);

    // Record KPI history
    setKpiHistory(prev => ({
      energy: [...prev.energy, currentKpi.energy],
      stability: [...prev.stability, currentKpi.stability],
      productivity: [...prev.productivity, currentKpi.productivity],
    }));

    // Calculate star rating
    const maxPossible = 500;
    const ratio = stageScore / maxPossible;
    const stars = ratio >= GAME_CONFIG.STAR_THRESHOLDS.three ? 3 : ratio >= GAME_CONFIG.STAR_THRESHOLDS.two ? 2 : ratio >= GAME_CONFIG.STAR_THRESHOLDS.one ? 1 : 0;
    setStageResults(prev => [...prev, { rating: Math.round(ratio * 100), stars, stageScore }]);

    // Random quality inspection
    if (Math.random() < GAME_CONFIG.QUALITY_INSPECTION_CHANCE && currentStage < 6) {
      const event = INSPECTION_EVENTS[randInt(0, INSPECTION_EVENTS.length - 1)];
      setInspectionEvent({ ...event, stage: currentStage + 1 });
      return;
    }

    advanceStage();
  };

  const advanceStage = () => {
    setStageScore(0);
    if (currentStage < 6) {
      setCurrentStage(s => s + 1);
      setTimer(GAME_CONFIG.STAGE_TIME_LIMIT);
      setShowStageIntro(true);
    } else {
      if (score > highScore) setHighScore(score);
      setScreen("clear");
    }
  };

  const handleInspectionResolve = (event, choice) => {
    if (choice === "fix") {
      setTimer(t => Math.max(5, t - 5));
      setDefectLog(prev => [...prev, { ...event, resolved: true }]);
    } else if (choice === "item") {
      setCoins(c => Math.max(0, c - 100));
      setDefectLog(prev => [...prev, { ...event, resolved: true }]);
    }
    setInspectionEvent(null);
    advanceStage();
  };

  const handleInspectionFail = (event) => {
    setLives(l => Math.max(0, l - 1));
    setCurrentKpi(prev => ({ ...prev, [event.kpi]: clamp(prev[event.kpi] - 15, 0, 100) }));
    setYieldRate(y => clamp(y - 8, 0, 100));
    setDefectLog(prev => [...prev, { ...event, resolved: false }]);
    setCombo(0);
    setInspectionEvent(null);
    if (lives <= 1) {
      saveGameData();
      setScreen("gameover");
      return;
    }
    advanceStage();
  };

  const handleBuyUpgrade = (upgrade) => {
    if (coins < upgrade.cost || ownedUpgrades.includes(upgrade.id)) return;
    setCoins(c => c - upgrade.cost);
    setOwnedUpgrades(prev => [...prev, upgrade.id]);
  };

  // 게임 종료 시 데이터 저장
  const saveGameData = useCallback(async () => {
    const nickname = localStorage?.getItem?.("player_nickname") || `플레이어${Date.now() % 10000}`;

    // 등급 계산
    let grade = "F";
    if (score >= 9000) grade = "S+";
    else if (score >= 8000) grade = "S";
    else if (score >= 7000) grade = "A";
    else if (score >= 6000) grade = "B";
    else if (score >= 5000) grade = "C";
    else if (score >= 4000) grade = "D";

    const gameData = {
      nickname,
      total_score: score,
      grade,
      final_energy: currentKpi.energy,
      final_stability: currentKpi.stability,
      final_productivity: currentKpi.productivity,
      yield_rate: yieldRate,
      strategy_used: strategy,
      total_stars: stageResults.reduce((sum, r) => sum + (r.stars || 0), 0),
      max_combo: maxCombo,
      stages_completed: currentStage,
      lives_remaining: lives,
      coins_earned: coins,
    };

    try {
      const response = await fetch("/api/games/quick-save", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(gameData),
      });
      if (response.ok) {
        console.log("✅ 게임 데이터 저장 완료");
      } else {
        const error = await response.text();
        console.error("❌ 게임 데이터 저장 실패:", response.status, error);
      }
    } catch (error) {
      console.error("❌ 게임 데이터 저장 실패:", error);
    }
  }, [score, currentKpi, yieldRate, strategy, stageResults, maxCombo, currentStage, lives, coins]);

  const startGame = () => {
    setScore(0); setStageResults([]); setCurrentStage(0); setCombo(0); setMaxCombo(0);
    setLives(GAME_CONFIG.MAX_LIVES); setTimer(GAME_CONFIG.STAGE_TIME_LIMIT);
    setCurrentKpi({ energy: 50, stability: 50, productivity: 50 });
    setKpiHistory({ energy: [50], stability: [50], productivity: [50] });
    setDefectLog([]); setYieldRate(100); setStageScore(0);
    setIsFever(false); setStrategy("balanced"); setInspectionEvent(null);
    setShowStageIntro(true); setScreen("stage");
  };

  const stageData = currentStage < 6 ? STAGES[currentStage] : BONUS_STAGE;

  // ─── TITLE SCREEN ───
  if (screen === "title") {
    return (
      <div style={{
        minHeight: "100vh",
        background: "linear-gradient(160deg, #0a0e17 0%, #0d1926 30%, #0f1f2e 60%, #0a1628 100%)",
        display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center",
        fontFamily: "'Noto Sans KR', 'Segoe UI', system-ui, sans-serif",
        padding: 20, position: "relative", overflow: "hidden",
      }}>
        {/* Animated background particles */}
        {Array.from({ length: 12 }).map((_, i) => (
          <div key={i} style={{
            position: "absolute", fontSize: randInt(16, 32), opacity: 0.06 + (i % 3) * 0.03,
            left: `${(i * 8.3) % 100}%`, top: `${(i * 13.7) % 100}%`,
            animation: `float ${3 + i * 0.7}s ease-in-out infinite alternate`,
            color: ["#e74c3c", "#3498db", "#2ecc71", "#f39c12"][i % 4],
          }}>
            {["⚡", "🔋", "🧪", "🔬", "📊", "🔧", "✂️", "🏭", "💎", "⚙️", "🛡️", "🌟"][i]}
          </div>
        ))}

        <div style={{
          background: "linear-gradient(145deg, rgba(22,27,34,0.95), rgba(13,17,23,0.98))",
          borderRadius: 28, padding: "40px 36px 36px", textAlign: "center",
          boxShadow: "0 20px 60px rgba(0,0,0,0.5), 0 0 40px rgba(0,184,148,0.05)",
          maxWidth: 440, width: "100%",
          border: "1px solid #30363d",
          position: "relative", zIndex: 1,
        }}>
          <div style={{
            fontSize: 56, marginBottom: 8,
            filter: "drop-shadow(0 4px 12px rgba(0,184,148,0.3))",
          }}>🔋</div>
          <h1 style={{ fontSize: 28, fontWeight: 800, color: "#e6edf3", margin: "0 0 2px", letterSpacing: -0.5 }}>
            배터리 팩토리
          </h1>
          <h2 style={{ fontSize: 13, fontWeight: 500, color: "#8b949e", margin: "0 0 6px" }}>
            Battery Factory Simulation
          </h2>
          <div style={{ fontSize: 10, color: "#484f58", marginBottom: 24 }}>
            Powered by <span style={{ color: "#e74c3c", fontWeight: 700 }}>Redash</span> Analytics
          </div>

          {/* KPI Preview */}
          <div style={{ display: "flex", gap: 10, justifyContent: "center", marginBottom: 20 }}>
            {Object.entries(KPI_NAMES).map(([k, name]) => (
              <div key={k} style={{
                padding: "8px 14px", borderRadius: 12,
                background: `${KPI_COLORS[k]}11`, border: `1px solid ${KPI_COLORS[k]}33`,
                display: "flex", flexDirection: "column", alignItems: "center", gap: 2,
              }}>
                <span style={{ fontSize: 16 }}>{KPI_ICONS[k]}</span>
                <span style={{ fontSize: 9, color: KPI_COLORS[k], fontWeight: 600 }}>{name}</span>
              </div>
            ))}
          </div>

          {/* Stage badges */}
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6, justifyContent: "center", marginBottom: 24 }}>
            {[...STAGES, BONUS_STAGE].map((s, i) => (
              <span key={i} style={{
                padding: "3px 10px", borderRadius: 16, fontSize: 10, fontWeight: 600,
                background: i === 6 ? "#fdcb6e11" : "#21262d",
                color: i === 6 ? "#f39c12" : "#8b949e",
                border: i === 6 ? "1px solid #f39c1233" : "1px solid #30363d",
              }}>
                {s.icon} {s.name}
              </span>
            ))}
          </div>

          <button onClick={startGame}
            style={{
              padding: "16px 56px", fontSize: 18, fontWeight: 800, borderRadius: 28,
              border: "none", letterSpacing: 1, cursor: "pointer",
              background: "linear-gradient(135deg, #00b894, #00a885)",
              color: "#fff", boxShadow: "0 6px 24px rgba(0,184,148,0.35)",
              transition: "all 0.2s", marginBottom: 12,
            }}
            onMouseEnter={e => { e.target.style.transform = "translateY(-2px)"; e.target.style.boxShadow = "0 10px 32px rgba(0,184,148,0.5)"; }}
            onMouseLeave={e => { e.target.style.transform = "translateY(0)"; e.target.style.boxShadow = "0 6px 24px rgba(0,184,148,0.35)"; }}
          >▶ 공정 시작</button>

          <button onClick={() => setShowRedash(true)}
            style={{
              padding: "12px 32px", fontSize: 14, fontWeight: 700, borderRadius: 20,
              border: "1px solid #30363d", cursor: "pointer",
              background: "linear-gradient(135deg, #e74c3c, #f39c12)",
              color: "#fff", boxShadow: "0 4px 16px rgba(231,76,60,0.25)",
              transition: "all 0.2s",
            }}
            onMouseEnter={e => { e.target.style.transform = "translateY(-2px)"; e.target.style.boxShadow = "0 6px 20px rgba(231,76,60,0.4)"; }}
            onMouseLeave={e => { e.target.style.transform = "translateY(0)"; e.target.style.boxShadow = "0 4px 16px rgba(231,76,60,0.25)"; }}
          >📊 리더보드 & 분석</button>

          {highScore > 0 && (
            <div style={{ marginTop: 14, fontSize: 12, color: "#f39c12", fontWeight: 600 }}>
              🏆 최고: {highScore}점
            </div>
          )}
        </div>

        <div style={{ marginTop: 16, fontSize: 10, color: "#484f58", zIndex: 1, textAlign: "center" }}>
          리튬이온 배터리 제조 시뮬레이션 · 7단계 공정 체험
        </div>

        {showRedash && (
          <RedashDashboard
            gameData={{ kpiHistory, stageResults, currentKpi, coins, defectLog, yieldRate }}
            isOpen={showRedash} onClose={() => setShowRedash(false)}
            onDecision={setStrategy} upgrades={ownedUpgrades}
          />
        )}

        <style>{`
          @keyframes float { 0% { transform: translateY(0px) rotate(0deg); } 100% { transform: translateY(-20px) rotate(10deg); } }
        `}</style>
      </div>
    );
  }

  // ─── GAME CLEAR SCREEN ───
  if (screen === "clear") {
    const avgKpi = (currentKpi.energy + currentKpi.stability + currentKpi.productivity) / 3;
    const grade = avgKpi >= 85 ? "S" : avgKpi >= 70 ? "A" : avgKpi >= 55 ? "B" : avgKpi >= 40 ? "C" : "D";
    const totalStars = stageResults.reduce((s, r) => s + r.stars, 0);

    return (
      <div style={{
        minHeight: "100vh",
        background: "linear-gradient(160deg, #0a0e17, #0d1926, #0f1f2e)",
        display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center",
        fontFamily: "'Noto Sans KR', 'Segoe UI', system-ui, sans-serif",
        padding: 20,
      }}>
        <div style={{
          background: "linear-gradient(145deg, rgba(22,27,34,0.95), rgba(13,17,23,0.98))",
          borderRadius: 24, padding: "32px 28px", textAlign: "center",
          maxWidth: 440, width: "100%", border: "1px solid #30363d",
          boxShadow: "0 20px 60px rgba(0,0,0,0.5), 0 0 40px rgba(0,184,148,0.08)",
        }}>
          <div style={{ fontSize: 48, marginBottom: 8 }}>🎉</div>
          <h2 style={{ fontSize: 22, fontWeight: 800, color: "#e6edf3", margin: "0 0 4px" }}>공정 완료!</h2>
          <div style={{
            display: "inline-block", padding: "4px 20px", borderRadius: 20, marginBottom: 16,
            fontSize: 36, fontWeight: 900,
            background: grade === "S" ? "linear-gradient(135deg, #f39c12, #e74c3c)" : "linear-gradient(135deg, #00b894, #00cec9)",
            color: "#fff",
          }}>{grade}</div>

          <div style={{
            display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 10, marginBottom: 16,
          }}>
            <div style={{ padding: 10, background: "#161b22", borderRadius: 10, border: "1px solid #30363d" }}>
              <div style={{ fontSize: 20, fontWeight: 800, color: "#f39c12" }}>{score}</div>
              <div style={{ fontSize: 9, color: "#8b949e" }}>총점</div>
            </div>
            <div style={{ padding: 10, background: "#161b22", borderRadius: 10, border: "1px solid #30363d" }}>
              <div style={{ fontSize: 20, fontWeight: 800, color: "#00b894" }}>{totalStars}⭐</div>
              <div style={{ fontSize: 9, color: "#8b949e" }}>별 수집</div>
            </div>
            <div style={{ padding: 10, background: "#161b22", borderRadius: 10, border: "1px solid #30363d" }}>
              <div style={{ fontSize: 20, fontWeight: 800, color: "#9b59b6" }}>{maxCombo}x</div>
              <div style={{ fontSize: 9, color: "#8b949e" }}>최대 콤보</div>
            </div>
          </div>

          {/* KPI Final */}
          {Object.entries(KPI_NAMES).map(([k, name]) => (
            <div key={k} style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 6 }}>
              <span style={{ fontSize: 10, color: "#8b949e", width: 56 }}>{KPI_ICONS[k]} {name}</span>
              <div style={{ flex: 1, height: 8, background: "#21262d", borderRadius: 4, overflow: "hidden" }}>
                <div style={{ width: `${currentKpi[k]}%`, height: "100%", background: KPI_COLORS[k], borderRadius: 4 }} />
              </div>
              <span style={{ fontSize: 11, fontWeight: 700, color: KPI_COLORS[k], width: 28 }}>
                {Math.round(currentKpi[k])}
              </span>
            </div>
          ))}

          <div style={{ display: "flex", gap: 8, marginTop: 20, justifyContent: "center", flexWrap: "wrap" }}>
            <button onClick={() => setShowRedash(true)} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20, border: "none",
              background: "linear-gradient(135deg, #e74c3c, #f39c12)", color: "#fff", cursor: "pointer",
            }}>📊 Redash 분석</button>
            <button onClick={() => setShowLeaderboard(true)} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20,
              background: "#21262d", color: "#e6edf3", cursor: "pointer", border: "1px solid #30363d",
            }}>🏆 랭킹</button>
            <button onClick={startGame} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20, border: "none",
              background: "linear-gradient(135deg, #00b894, #00cec9)", color: "#fff", cursor: "pointer",
            }}>🔄 재도전</button>
            <button onClick={() => setScreen("title")} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20,
              background: "transparent", color: "#8b949e", cursor: "pointer", border: "1px solid #30363d",
            }}>🏠 타이틀</button>
          </div>
        </div>

        {showRedash && (
          <RedashDashboard
            gameData={{ kpiHistory, stageResults, currentKpi, coins, defectLog, yieldRate }}
            isOpen={showRedash} onClose={() => setShowRedash(false)}
            onDecision={setStrategy} upgrades={ownedUpgrades}
          />
        )}
        {showLeaderboard && (
          <Leaderboard playerScore={score} playerKpi={currentKpi} onClose={() => setShowLeaderboard(false)} />
        )}
      </div>
    );
  }

  // ─── GAME OVER SCREEN ───
  if (screen === "gameover") {
    return (
      <div style={{
        minHeight: "100vh",
        background: "linear-gradient(160deg, #1a0a0a, #2d1117, #1a0a0a)",
        display: "flex", alignItems: "center", justifyContent: "center",
        fontFamily: "'Noto Sans KR', 'Segoe UI', system-ui, sans-serif",
      }}>
        <div style={{
          background: "linear-gradient(145deg, rgba(45,17,23,0.95), rgba(26,10,10,0.98))",
          borderRadius: 24, padding: "36px 32px", textAlign: "center",
          maxWidth: 400, width: "90%", border: "1px solid #e74c3c33",
          boxShadow: "0 20px 60px rgba(0,0,0,0.5), 0 0 40px rgba(231,76,60,0.1)",
        }}>
          <div style={{ fontSize: 56, marginBottom: 12 }}>💥</div>
          <h2 style={{ fontSize: 22, fontWeight: 800, color: "#e74c3c", margin: "0 0 8px" }}>공정 중단!</h2>
          <p style={{ fontSize: 13, color: "#8b949e", marginBottom: 20 }}>
            Stage {currentStage + 1}에서 라이프가 소진되었습니다
          </p>
          <div style={{ fontSize: 20, fontWeight: 800, color: "#f39c12", marginBottom: 20 }}>
            최종 점수: {score}점
          </div>
          <div style={{ display: "flex", gap: 8, justifyContent: "center" }}>
            <button onClick={() => setShowRedash(true)} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20, border: "none",
              background: "linear-gradient(135deg, #e74c3c, #f39c12)", color: "#fff", cursor: "pointer",
            }}>📊 분석</button>
            <button onClick={startGame} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20, border: "none",
              background: "linear-gradient(135deg, #00b894, #00cec9)", color: "#fff", cursor: "pointer",
            }}>🔄 재도전</button>
            <button onClick={() => setScreen("title")} style={{
              padding: "10px 20px", fontSize: 13, fontWeight: 700, borderRadius: 20,
              background: "transparent", color: "#8b949e", cursor: "pointer", border: "1px solid #30363d",
            }}>🏠 홈</button>
          </div>
        </div>
        {showRedash && (
          <RedashDashboard
            gameData={{ kpiHistory, stageResults, currentKpi, coins, defectLog, yieldRate }}
            isOpen={showRedash} onClose={() => setShowRedash(false)}
            onDecision={setStrategy} upgrades={ownedUpgrades}
          />
        )}
      </div>
    );
  }

  // ─── GAME STAGE SCREEN ───
  return (
    <div style={{
      minHeight: "100vh",
      background: "linear-gradient(180deg, #0d1926, #0a1628, #0f1f2e)",
      fontFamily: "'Noto Sans KR', 'Segoe UI', system-ui, sans-serif",
      display: "flex", flexDirection: "column", position: "relative",
    }}>
      {/* ── Top HUD ── */}
      <div style={{
        padding: "10px 16px", display: "flex", alignItems: "center", justifyContent: "space-between",
        background: "rgba(13,17,23,0.9)", backdropFilter: "blur(10px)",
        borderBottom: "1px solid #21262d",
      }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
          <span style={{ fontSize: 18 }}>{stageData.icon}</span>
          <div>
            <div style={{ fontSize: 12, fontWeight: 700, color: "#e6edf3" }}>
              Stage {stageData.id}: {stageData.name}
            </div>
            <div style={{ fontSize: 9, color: "#8b949e" }}>{stageData.subtitle}</div>
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          {/* Timer */}
          <div style={{
            padding: "4px 10px", borderRadius: 10,
            background: timer <= 10 ? "#e74c3c22" : "#21262d",
            border: `1px solid ${timer <= 10 ? "#e74c3c" : "#30363d"}`,
            display: "flex", alignItems: "center", gap: 4,
          }}>
            <span style={{ fontSize: 10 }}>⏱️</span>
            <span style={{
              fontSize: 13, fontWeight: 800,
              color: timer <= 10 ? "#e74c3c" : timer <= 20 ? "#f39c12" : "#e6edf3",
              animation: timer <= 10 ? "pulse 0.5s infinite" : "none",
            }}>{timer}s</span>
          </div>
          {/* Score */}
          <span style={{ fontSize: 14, fontWeight: 800, color: "#00b894" }}>{score}</span>
        </div>
      </div>

      {/* ── Second HUD Row ── */}
      <div style={{
        padding: "6px 16px", display: "flex", alignItems: "center", justifyContent: "space-between",
        background: "rgba(13,17,23,0.7)", borderBottom: "1px solid #21262d11",
      }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
          {/* Lives */}
          <div style={{ display: "flex", gap: 2 }}>
            {Array.from({ length: GAME_CONFIG.MAX_LIVES }).map((_, i) => (
              <span key={i} style={{ fontSize: 14, opacity: i < lives ? 1 : 0.2 }}>❤️</span>
            ))}
          </div>
          {/* Combo */}
          {combo > 0 && (
            <div style={{
              padding: "2px 8px", borderRadius: 8, fontSize: 10, fontWeight: 700,
              background: isFever ? "linear-gradient(135deg, #e74c3c, #f39c12)" : "#21262d",
              color: isFever ? "#fff" : "#f39c12",
              border: isFever ? "none" : "1px solid #f39c1233",
              animation: isFever ? "pulse 0.3s infinite" : combo >= 5 ? "pulse 1s infinite" : "none",
            }}>
              {isFever ? "🔥 FEVER!" : `${combo}x 콤보`}
            </div>
          )}
          {/* Coins */}
          <span style={{ fontSize: 10, color: "#f39c12", fontWeight: 600 }}>💰{coins}</span>
        </div>
        <div style={{ display: "flex", gap: 6 }}>
          <button onClick={() => setShowRedash(true)} style={{
            padding: "4px 10px", borderRadius: 8, border: "1px solid #e74c3c33",
            background: "#e74c3c11", color: "#e74c3c", fontSize: 10, fontWeight: 700,
            cursor: "pointer", display: "flex", alignItems: "center", gap: 3,
          }}>
            <span style={{ fontWeight: 800 }}>R</span> 대시보드
          </button>
          <button onClick={() => setShowShop(true)} style={{
            padding: "4px 10px", borderRadius: 8, border: "1px solid #30363d",
            background: "#21262d", color: "#8b949e", fontSize: 10, fontWeight: 600,
            cursor: "pointer",
          }}>🏪</button>
        </div>
      </div>

      {/* ── KPI Mini Bar ── */}
      <div style={{ padding: "4px 16px", display: "flex", gap: 6, background: "rgba(13,17,23,0.5)" }}>
        {Object.entries(KPI_NAMES).map(([k, name]) => (
          <div key={k} style={{ flex: 1, display: "flex", alignItems: "center", gap: 4 }}>
            <span style={{ fontSize: 8, color: "#8b949e" }}>{KPI_ICONS[k]}</span>
            <div style={{ flex: 1, height: 4, background: "#21262d", borderRadius: 2, overflow: "hidden" }}>
              <div style={{
                width: `${currentKpi[k]}%`, height: "100%", background: KPI_COLORS[k],
                borderRadius: 2, transition: "width 0.3s",
              }} />
            </div>
            <span style={{ fontSize: 8, color: KPI_COLORS[k], fontWeight: 700, width: 18 }}>
              {Math.round(currentKpi[k])}
            </span>
          </div>
        ))}
      </div>

      {/* ── Stage Progress ── */}
      <div style={{ height: 3, background: "#21262d" }}>
        <div style={{
          width: `${((currentStage) / 7) * 100}%`, height: "100%",
          background: "linear-gradient(90deg, #00b894, #00cec9)", transition: "width 0.5s",
        }} />
      </div>

      {/* ── Stage Intro Overlay ── */}
      {showStageIntro && (
        <div style={{
          position: "absolute", inset: 0, background: "rgba(0,0,0,0.6)",
          display: "flex", alignItems: "center", justifyContent: "center", zIndex: 999,
          backdropFilter: "blur(6px)",
        }} onClick={() => setShowStageIntro(false)}>
          <div style={{
            background: "linear-gradient(145deg, #161b22, #0d1117)",
            borderRadius: 24, padding: "32px 28px", textAlign: "center",
            maxWidth: 380, width: "90%", animation: "slideIn 0.4s ease-out",
            boxShadow: "0 16px 48px rgba(0,0,0,0.4)", border: "1px solid #30363d",
          }}>
            <div style={{ fontSize: 52, marginBottom: 8 }}>{stageData.icon}</div>
            <h2 style={{ fontSize: 20, fontWeight: 800, color: "#e6edf3", margin: "0 0 4px" }}>
              Stage {stageData.id}
            </h2>
            <h3 style={{ fontSize: 16, fontWeight: 600, color: "#00b894", margin: "0 0 10px" }}>
              {stageData.name}
            </h3>
            <p style={{ fontSize: 12, color: "#8b949e", margin: "0 0 8px", lineHeight: 1.6 }}>
              {stageData.description}
            </p>
            {/* KPI Impact Preview */}
            <div style={{ display: "flex", gap: 6, justifyContent: "center", marginBottom: 16 }}>
              {Object.entries(stageData.kpiEffect || {}).map(([k, v]) => (
                <span key={k} style={{
                  padding: "3px 8px", borderRadius: 8, fontSize: 9, fontWeight: 600,
                  background: `${KPI_COLORS[k]}11`, color: KPI_COLORS[k],
                  border: `1px solid ${KPI_COLORS[k]}33`,
                }}>
                  {KPI_ICONS[k]} {(v * 100).toFixed(0)}%
                </span>
              ))}
            </div>
            <button onClick={e => { e.stopPropagation(); setShowStageIntro(false); }}
              style={{
                padding: "12px 44px", fontSize: 15, fontWeight: 800, borderRadius: 28,
                border: "none", background: "linear-gradient(135deg, #00b894, #00cec9)",
                color: "#fff", cursor: "pointer", boxShadow: "0 4px 16px rgba(0,184,148,0.4)",
              }}>▶ 시작!</button>
          </div>
        </div>
      )}

      {/* ── Quality Inspection Overlay ── */}
      {inspectionEvent && (
        <QualityInspection
          event={inspectionEvent}
          onResolve={handleInspectionResolve}
          onFail={handleInspectionFail}
          timeLeft={timer}
        />
      )}

      {/* ── Stage Content ── */}
      <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", padding: "12px 8px" }}>
        <div style={{
          background: "rgba(255,255,255,0.92)", borderRadius: 20,
          padding: "20px 14px", maxWidth: 520, width: "100%",
          boxShadow: "0 8px 32px rgba(0,0,0,0.15)",
        }}>
          {!showStageIntro && !inspectionEvent && currentStage === 0 && <MixingStage onComplete={handleStageComplete} addScore={addScore} strategy={strategy} />}
          {!showStageIntro && !inspectionEvent && currentStage === 1 && <CoatingStage onComplete={handleStageComplete} addScore={addScore} />}
          {!showStageIntro && !inspectionEvent && currentStage === 2 && <PressingStage onComplete={handleStageComplete} addScore={addScore} />}
          {!showStageIntro && !inspectionEvent && currentStage === 3 && <CuttingStage onComplete={handleStageComplete} addScore={addScore} />}
          {!showStageIntro && !inspectionEvent && currentStage === 4 && <AssemblyStage onComplete={handleStageComplete} addScore={addScore} />}
          {!showStageIntro && !inspectionEvent && currentStage === 5 && <ActivationStage onComplete={handleStageComplete} addScore={addScore} />}
          {!showStageIntro && !inspectionEvent && currentStage === 6 && <DryElectrodeStage onComplete={handleStageComplete} addScore={addScore} />}
        </div>
      </div>

      {/* ── Bottom Stage Indicators ── */}
      <div style={{
        display: "flex", justifyContent: "center", gap: 5, padding: "10px 8px",
        background: "rgba(13,17,23,0.8)",
      }}>
        {[...STAGES, BONUS_STAGE].map((s, i) => (
          <div key={i} style={{
            width: 26, height: 26, borderRadius: "50%",
            background: i < currentStage ? "#00b894" : i === currentStage ? "#161b22" : "rgba(255,255,255,0.05)",
            border: i === currentStage ? "2px solid #00b894" : i < currentStage ? "2px solid #00b894" : "2px solid #30363d",
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: i < currentStage ? 10 : 9, fontWeight: 700,
            color: i < currentStage ? "#fff" : i === currentStage ? "#00b894" : "#484f58",
            transition: "all 0.3s",
          }}>
            {i < currentStage ? "✓" : i + 1}
          </div>
        ))}
      </div>

      {/* ── Modals ── */}
      {showRedash && (
        <RedashDashboard
          gameData={{ kpiHistory, stageResults, currentKpi, coins, defectLog, yieldRate }}
          isOpen={showRedash} onClose={() => setShowRedash(false)}
          onDecision={setStrategy} upgrades={ownedUpgrades}
        />
      )}
      {showShop && (
        <UpgradeShop coins={coins} ownedUpgrades={ownedUpgrades}
          onBuy={handleBuyUpgrade} onClose={() => setShowShop(false)} />
      )}

      <style>{`
        @keyframes pulse { 0%, 100% { transform: scale(1); opacity: 1; } 50% { transform: scale(1.05); opacity: 0.8; } }
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        @keyframes slideIn { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes floatUp { 0% { transform: translateY(0); opacity: 1; } 100% { transform: translateY(-40px); opacity: 0; } }
      `}</style>
    </div>
  );
}
