#!/usr/bin/env bash
set -euo pipefail

# 0) 레포 루트로 이동 (어디서 실행해도 안전)
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "${REPO_ROOT:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi
cd "$REPO_ROOT"

# 1) 기본 솔루션 루트: 01_cert_week_7/solutions
#    필요하면 실행 시 SOL_ROOT="다른/경로"로 덮어쓰기 가능
SOL_ROOT="${SOL_ROOT:-01_cert_week_7/solutions}"

# 2) 날짜: 인자 없으면 KST 오늘
DAY="${1:-$(TZ=Asia/Seoul date +%Y-%m-%d)}"
Y=${DAY:0:4}; M=${DAY:5:2}; D=${DAY:8:2}
BASE="$SOL_ROOT/$Y/$M/$D"

# 3) 디렉터리 생성
mkdir -p "$BASE/python" "$BASE/sql" "$BASE/java"

# 4) 깃이 폴더를 추적하도록 빈 파일 추가(원치 않으면 주석 처리)
touch "$BASE/python/.keep" "$BASE/sql/.keep" "$BASE/java/.keep"

echo "Created: $REPO_ROOT/$BASE"
