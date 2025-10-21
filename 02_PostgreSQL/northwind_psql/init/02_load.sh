#!/usr/bin/env bash
set -euo pipefail

# ---------- 설정 ----------
DB_NAME="${POSTGRES_DB:-northwind}"
ROLE_TO_GRANT="${TARGET_ROLE:-nwuser}"
ROLE_PW="${TARGET_ROLE_PASSWORD:-}"
SQL_FILE="/tmp/northwind.sql"
GRANTS_FILE="/docker-entrypoint-initdb.d/01_grants.psql"
# --------------------------

log()  { echo "[init] $*"; }
fail() { echo "[init][ERROR] $*" >&2; exit 1; }

# 0) PostgreSQL 서버 대기
log "waiting for postgres..."
until pg_isready -U "${POSTGRES_USER}" -d postgres >/dev/null 2>&1; do
  sleep 1
done

# 1) DB 존재 확인 및 생성
log "ensure database exists: ${DB_NAME}"
if ! psql -U "${POSTGRES_USER}" -d postgres -Atqc \
  "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1; then
  createdb -U "${POSTGRES_USER}" -E UTF8 -T template0 "${DB_NAME}"
fi

# 2) 덤프 파일 로드
log "load ${SQL_FILE} if public schema is empty"
[ -f "${SQL_FILE}" ] || fail "${SQL_FILE} not found. Check volume mount."

if ! psql -U "${POSTGRES_USER}" -d "${DB_NAME}" -Atqc \
  "SELECT 1 FROM information_schema.tables WHERE table_schema='public' LIMIT 1" | grep -q 1; then
  log "importing ${SQL_FILE} into ${DB_NAME} ..."
  psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d "${DB_NAME}" -f "${SQL_FILE}"
  log "import done."
else
  log "public already has tables. skip import."
fi

# 3) 사용자 생성 및 비밀번호 설정
log "ensure role exists: ${ROLE_TO_GRANT}"
ROLE_LIT=${ROLE_TO_GRANT//\'/\'\'}

psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d postgres \
  -c "DO \$\$ BEGIN
         IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '${ROLE_LIT}') THEN
           EXECUTE format('CREATE ROLE %I LOGIN', '${ROLE_LIT}');
         END IF;
       END \$\$;"

if [ -n "${ROLE_PW}" ]; then
  psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d postgres \
    -c "ALTER ROLE \"${ROLE_TO_GRANT}\" PASSWORD '${ROLE_PW}';"
fi

# 4) 권한 부여
log "apply grants to ${ROLE_TO_GRANT}"
[ -f "${GRANTS_FILE}" ] || fail "${GRANTS_FILE} not found."
psql -v ON_ERROR_STOP=1 \
     -U "${POSTGRES_USER}" -d "${DB_NAME}" \
     -v target_role="${ROLE_TO_GRANT}" \
     -v dbname="${DB_NAME}" \
     -f "${GRANTS_FILE}"

log "done."