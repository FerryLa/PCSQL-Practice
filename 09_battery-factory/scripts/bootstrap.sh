#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# Battery Factory Game - 원클릭 부트스트랩
# ═══════════════════════════════════════════════════════════════
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║  🔋 Battery Factory - Full Stack Setup   ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ─── 1. Docker Compose 빌드 & 실행 ───
echo -e "${YELLOW}[1/5] Docker Compose 빌드 & 실행...${NC}"
docker compose up -d --build

# ─── 2. 서비스 헬스체크 대기 ───
echo -e "${YELLOW}[2/5] 서비스 시작 대기...${NC}"
echo "  Game DB 대기 중..."
until docker compose exec -T game-db pg_isready -U battery_admin -d battery_game 2>/dev/null; do
    sleep 2
done
echo -e "  ${GREEN}✅ Game DB 준비 완료${NC}"

echo "  Redash 대기 중..."
for i in $(seq 1 30); do
    if curl -s http://localhost:5000/ping > /dev/null 2>&1; then
        echo -e "  ${GREEN}✅ Redash 준비 완료${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "  ${RED}⚠️  Redash 응답 없음 (계속 진행)${NC}"
    fi
    sleep 3
done

echo "  FastAPI 대기 중..."
for i in $(seq 1 20); do
    if curl -s http://localhost:5001/health > /dev/null 2>&1; then
        echo -e "  ${GREEN}✅ FastAPI 준비 완료${NC}"
        break
    fi
    sleep 2
done

# ─── 3. Redash DB 초기화 ───
echo -e "${YELLOW}[3/5] Redash 데이터베이스 초기화...${NC}"
docker compose run --rm redash-server create_db 2>/dev/null || \
    echo "  ℹ️  이미 초기화되어 있거나 skip"

# ─── 4. 상태 확인 ───
echo -e "${YELLOW}[4/5] 서비스 상태 확인...${NC}"
docker compose ps

# ─── 5. 접속 정보 출력 ───
echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ 모든 서비스가 실행 중입니다!${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo "  📊 Redash:      http://localhost:5000"
echo "  🎮 Game API:    http://localhost:5001"
echo "  📋 API Docs:    http://localhost:5001/docs"
echo "  🗄️  Game DB:    localhost:5433 (battery_game)"
echo ""
echo -e "${YELLOW}📝 다음 단계:${NC}"
echo "  1. http://localhost:5000 접속 → 관리자 계정 생성"
echo "  2. 프로필 → API Key 복사"
echo "  3. .env 파일에 REDASH_API_KEY 설정"
echo "  4. Redash 쿼리/대시보드 자동 생성:"
echo "     python scripts/setup_redash.py --api-key YOUR_KEY"
echo ""
