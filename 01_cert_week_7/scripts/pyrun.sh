#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

VENV=".venv"
if [[ -x "$VENV/Scripts/python.exe" ]]; then
  PY="$VENV/Scripts/python.exe"
elif [[ -x "$VENV/bin/python" ]]; then
  PY="$VENV/bin/python"
else
  PY="python"
fi

if [[ "${DEBUG:-0}" != "0" ]]; then
  echo "[DEBUG] ROOT_DIR=$ROOT_DIR" >&2
  echo "[DEBUG] PY=$PY" >&2
  echo "[DEBUG] ARGS: $*" >&2
fi

# 한글 적용
export PYTHONIOENCODING=UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

exec "$PY" "$@"
