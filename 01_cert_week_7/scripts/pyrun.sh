#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

VENV=".venv"
if [[ -f "$VENV/bin/activate" ]]; then
  source "$VENV/bin/activate"
else
  source "$VENV/Scripts/activate"
fi

# 사용: scripts/pyrun.sh solutions/2025/10/05/python/python.py
python "$@"
