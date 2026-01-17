#!/bin/bash

# 설정
IDEA_FILE="3_Idea_Pool/ideas.txt"
USED_FILE="3_Idea_Pool/used_ideas.txt"
DAILY_DIR="1_Daily_Records"
TEMPLATE="# Day {N} – {IDEA}

## 1. 한 줄 요약

(이 서비스가 해결하려는 핵심을 사용자 말로 1문장)

## 2. 이 문제는 언제 발생하는가

*
*

## 3. 기존 해결 방식과 불편함

**기존 대안:**
*

**불편 포인트:**
*
*

## 4. 핵심 가설 (1개)

만약 ________________라면, 사용자는 ________________할 것이다.

## 5. 최소 화면 1개 설명

(화면 이름: )

노출 순서:
1.
2.
3.

## 6. 가장 위험한 지점

(실패 가능성 1순위를 사람/행동/운영 관점에서)

## 7. 오늘의 기획자 인사이트

(다른 서비스에도 재활용 가능한 배운 점 1줄)
"

# 아이디어 파일 확인
if [ ! -f "$IDEA_FILE" ]; then
    echo "❌ $IDEA_FILE 파일이 없습니다."
    exit 1
fi

# 사용한 아이디어 파일 생성 (없으면)
touch "$USED_FILE"

# 사용하지 않은 아이디어만 필터링
AVAILABLE_IDEAS=$(comm -23 <(sort "$IDEA_FILE") <(sort "$USED_FILE"))

if [ -z "$AVAILABLE_IDEAS" ]; then
    echo "🎉 모든 아이디어를 사용했습니다!"
    echo "💡 3_Idea_Pool/ideas.txt에 새 아이디어를 추가하거나"
    echo "🔄 used_ideas.txt를 삭제해서 리셋하세요."
    exit 1
fi

# 랜덤 아이디어 선택
IDEA=$(echo "$AVAILABLE_IDEAS" | shuf -n 1)

if [ -z "$IDEA" ]; then
    echo "❌ 아이디어를 선택할 수 없습니다."
    exit 1
fi

# 다음 Day 번호 계산
LAST_DAY=$(ls -d "$DAILY_DIR"/day* 2>/dev/null | wc -l)
NEXT_DAY=$((LAST_DAY + 1))
DAY_NUM=$(printf "%02d" $NEXT_DAY)
DAY_DIR="$DAILY_DIR/day$DAY_NUM"

# 디렉토리 생성
mkdir -p "$DAY_DIR"

# README 생성
echo "$TEMPLATE" | sed "s/{N}/$DAY_NUM/g" | sed "s/{IDEA}/$IDEA/g" > "$DAY_DIR/README.md"

# 사용한 아이디어 기록
echo "$IDEA" >> "$USED_FILE"

# 남은 아이디어 개수 계산
TOTAL=$(wc -l < "$IDEA_FILE")
USED=$(wc -l < "$USED_FILE")
REMAINING=$((TOTAL - USED))

# 결과 출력
echo "✅ Day $DAY_NUM 생성 완료"
echo "📌 오늘의 아이디어: $IDEA"
echo "📂 경로: $DAY_DIR/README.md"
echo "📊 남은 아이디어: $REMAINING/$TOTAL"
