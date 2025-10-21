```markdown
# Northwind PostgreSQL 환경 구축

Docker Compose로 PostgreSQL + pgAdmin을 로컬에 띄우고, `northwind.sql`을 자동 적재하는 개발용 환경입니다.

---

## 요구 사항
- Docker Desktop (Compose v2)
- Git Bash/WSL/PowerShell 중 하나

---

## 디렉터리 구조
project-root/
├── docker-compose.yml
├── .env
├── init/
│   ├── 01_grants.psql
│   └── 02_load.sh
└── northwind.sql
```



````

---

## .env 예시
```env
# Postgres 기본값
POSTGRES_DB=northwind
POSTGRES_USER=admin
POSTGRES_PASSWORD=changeme

# 앱(일반) 계정
TARGET_ROLE=nwuser
TARGET_ROLE_PASSWORD=app_pw

# 포트
PG_PORT=5432
PGADMIN_PORT=5050

# pgAdmin 로그인
PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD=admin123
````

> `.env`는 따옴표 없이 저장하세요. CRLF 문제가 의심되면 `dos2unix .env` 실행.

---

## 실행

```bash
docker compose up -d
docker compose ps
docker compose logs -f db   # 초기 적재/권한 로그 확인
```

정상 로그 예시

```
[init] waiting for postgres...
[init] ensure database exists: northwind
[init] importing /tmp/northwind.sql ...
[init] import done.
[init] ensure role exists: nwuser
[init] apply grants to nwuser
[init] done.
```

---

## 접속 방법

### psql (컨테이너 내부)

```bash
docker exec -it northwind-pg psql -U "$POSTGRES_USER" -d northwind -c "\dt"
docker exec -it northwind-pg psql -U nwuser -d northwind -c "select count(*) from products;"
```

### pgAdmin

* 주소: `http://localhost:5050`
* 로그인: `.env`의 이메일/비밀번호
* 서버 추가:

  * Host: `db`(동일 네트워크) 또는 `localhost`
  * Port: `5432`
  * Username: `nwuser` (또는 `admin`)
  * Password: `.env`의 비밀번호

### IntelliJ / DataGrip

* Host: `localhost`
* Port: `5432`
* **Database: `northwind`**
* User/Password: `.env` 값
* URL 칸에 값이 있다면 `jdbc:postgresql://localhost:5432/northwind` 로 정확히 설정
* `Schemas…`에서 `northwind → public` 체크 후 Synchronize

---

## 스크립트 설명

### `init/02_load.sh`

* 서버 준비 대기
* 대상 DB(`POSTGRES_DB`) 존재 확인/생성
* `northwind.sql`이 비어 있을 때 import
* 일반 계정(`TARGET_ROLE`) 생성 및 비밀번호 지정(옵션)
* 마지막에 `01_grants.psql`을 변수 주입해 실행

### `init/01_grants.psql` (발췌)

```sql
-- 1) DB 접속 권한
GRANT CONNECT ON DATABASE :dbname TO :target_role;

-- 2) 스키마 사용 권한
GRANT USAGE ON SCHEMA public TO :target_role;

-- 3) 기존 객체 권한
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO :target_role;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO :target_role;

-- 4) 앞으로 생길 객체 기본 권한
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO :target_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO :target_role;

-- 5) 기본 보안 강화
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
```

---

## 자주 쓰는 명령

초기화부터 다시(볼륨 포함 삭제):

```bash
docker compose down -v
docker compose up -d
```

덤프 수동 적재(자동 스킵 시):

```bash
docker exec -it northwind-pg \
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d northwind \
  -f /tmp/northwind.sql
```

계정 비밀번호 재설정:

```bash
docker exec -it northwind-pg \
  psql -U "$POSTGRES_USER" -d postgres \
  -c "ALTER ROLE \"nwuser\" WITH LOGIN PASSWORD '새비번';"
```

---

## 트러블슈팅

* **테이블이 안 보임**
  DataGrip이 `postgres` DB에 붙어 있을 수 있습니다. Database를 `northwind`로 바꾸고 `Schemas…`에서 `public` 체크.

* **`[28P01] password authentication failed`**
  비밀번호 재설정 후 psql로 먼저 접속 성공을 확인합니다.

* **`/docker-entrypoint-initdb.d`가 안 실행됨**
  로그에 `Skipping initialization`이 보이면 기존 볼륨 때문에 스킵된 것입니다. `docker compose down -v`로 초기화하거나 `02_load.sh`를 수동 실행하세요.

  ```bash
  docker exec -it northwind-pg bash -c '/docker-entrypoint-initdb.d/02_load.sh'
  ```

* **포트가 안 뜸**
  `docker compose ps`에서 `0.0.0.0:5432->5432/tcp` 확인. 충돌 시 `.env`의 `PG_PORT` 값을 바꾸고 재기동.

---

## 라이선스

예제 스키마는 Northwind 샘플을 사용합니다. 이 리포지토리는 필요 시 MIT 등으로 지정하십시오.

```
```
