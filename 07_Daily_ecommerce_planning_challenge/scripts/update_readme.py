#!/usr/bin/env python3
"""
Root README.md에 이커머스 챌린지 주간 집계를 업데이트하는 스크립트
"""

import os
import sys
import re

# 프로젝트 루트 디렉토리 계산
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CHALLENGE_DIR = os.path.dirname(SCRIPT_DIR)
ROOT_DIR = os.path.dirname(CHALLENGE_DIR)
ROOT_README_PATH = os.path.join(ROOT_DIR, "README.md")

# 마커
START_MARKER = "<!-- ECOMMERCE_CHALLENGE:START -->"
END_MARKER = "<!-- ECOMMERCE_CHALLENGE:END -->"

def get_weekly_stats():
    """weekly_challenge_status.py를 실행하여 주간 통계 가져오기"""
    sys.path.insert(0, SCRIPT_DIR)
    try:
        from weekly_challenge_status import collect_weekly_counts, build_markdown
        weekly_counts = collect_weekly_counts()
        return build_markdown(weekly_counts)
    except Exception as e:
        print(f"Error getting weekly stats: {e}")
        return "데이터를 불러올 수 없습니다."

def update_readme():
    """Root README.md 파일 업데이트"""
    if not os.path.exists(ROOT_README_PATH):
        print(f"Error: README.md not found at {ROOT_README_PATH}")
        return False

    # README 읽기
    with open(ROOT_README_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    # 마커 찾기
    start_idx = content.find(START_MARKER)
    end_idx = content.find(END_MARKER)

    if start_idx == -1 or end_idx == -1:
        print("Error: Markers not found in README.md")
        print("Please add the following markers to README.md:")
        print(START_MARKER)
        print(END_MARKER)
        return False

    # 주간 통계 가져오기
    stats_markdown = get_weekly_stats()

    # 새로운 내용 구성
    new_content = (
        content[:start_idx + len(START_MARKER)]
        + "\n\n"
        + stats_markdown
        + "\n\n> 매주 일요일 오전 10시 GitHub Action을 통해 자동 집계됩니다.\n\n"
        + content[end_idx:]
    )

    # 변경사항 확인
    if new_content == content:
        print("No changes needed.")
        return True

    # 파일 쓰기
    with open(ROOT_README_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"Successfully updated {ROOT_README_PATH}")
    return True

if __name__ == "__main__":
    success = update_readme()
    sys.exit(0 if success else 1)
