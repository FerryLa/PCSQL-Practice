#!/usr/bin/env bash
# venv 생성/재사용 + requirements 설치 + 간단 헬스체크
# 사용: bash scripts/mkvenv.sh [--path .venv] [--req requirements.txt]
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

VENV_PATH=".venv"
REQ_FILE="requirements.txt"

# 옵션 파싱
while [[ $# -gt 0 ]]; do
  case "$1" in
    --path) VENV_PATH="$2"; shift 2 ;;
    --req)  REQ_FILE="$2"; shift 2 ;;
    *) echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
  esac
done

# 파이썬 실행기 찾기
if command -v py >/dev/null 2>&1; then
  PY="py"
elif command -v python3 >/dev/null 2>&1; then
  PY="python3"
elif command -v python >/dev/null 2>&1; then
  PY="python"
else
  echo "python 실행기를 못 찾음. 먼저 Python 설치하세요." >&2
  exit 1
fi

# venv 생성(있으면 재사용)
if [[ ! -f "$VENV_PATH/bin/activate" && ! -f "$VENV_PATH/Scripts/activate" ]]; then
  echo "[*] Creating venv at $VENV_PATH"
  "$PY" -m venv "$VENV_PATH"
else
  echo "[*] Reusing existing venv at $VENV_PATH"
fi

# OS별 활성화 스크립트 경로
if [[ -f "$VENV_PATH/bin/activate" ]]; then
  # Unix 계열
  # shellcheck disable=SC1090
  source "$VENV_PATH/bin/activate"
else
  # Git Bash on Windows
  # shellcheck disable=SC1091
  source "$VENV_PATH/Scripts/activate"
fi

python -m pip install --upgrade pip setuptools wheel

if [[ -f "$REQ_FILE" ]]; then
  echo "[*] Installing from $REQ_FILE"
  pip install -r "$REQ_FILE"
else
  echo "[*] $REQ_FILE 없음. 넘어갑니다."
fi

echo "---- sanity check ----"
python -c 'import sys,platform;print("PY",platform.python_version());print("EXE",sys.executable)'
echo "----------------------"

echo "[✓] Done. IntelliJ 인터프리터: $(python -c "import sys;print(sys.executable)")"
