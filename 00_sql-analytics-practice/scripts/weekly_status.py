#!/usr/bin/env python3
"""
프로그래머스 SQL 문제 풀이 주간 집계 스크립트
Root README.md에 자동 업데이트 기능 포함
"""

import os
import re
import sys
from datetime import datetime
from collections import Counter

# 디렉토리 설정
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_ANALYTICS_DIR = os.path.dirname(SCRIPT_DIR)
ROOT_DIR = os.path.dirname(SQL_ANALYTICS_DIR)
TARGET_DIR = os.path.join(SQL_ANALYTICS_DIR, "programmers")
ROOT_README_PATH = os.path.join(ROOT_DIR, "README.md")

# 마커
START_MARKER = "<!-- PROGRAMMERS_WEEKLY:START -->"
END_MARKER = "<!-- PROGRAMMERS_WEEKLY:END -->"

# Date 파싱 패턴
DATE_PATTERN = re.compile(r"--\s*Date\s*:\s*(\d{4}-\d{2}-\d{2})")


def extract_date(path: str):
    """파일 상단에서 Date 한 줄을 찾아 date 객체로 반환."""
    try:
        with open(path, encoding="utf-8") as f:
            for _ in range(10):
                line = f.readline()
                if not line:
                    break
                m = DATE_PATTERN.search(line)
                if m:
                    return datetime.strptime(m.group(1), "%Y-%m-%d").date()
    except UnicodeDecodeError:
        return None
    return None


def collect_weekly_counts():
    """
    programmers/{year}/{month} 구조를 따라가면서
    .sql 파일들을 뒤지고, Date 기준으로 주별 개수 집계.
    """
    weekly = Counter()

    if not os.path.isdir(TARGET_DIR):
        return weekly

    for year in os.listdir(TARGET_DIR):
        year_path = os.path.join(TARGET_DIR, year)
        if not os.path.isdir(year_path):
            continue

        for month in os.listdir(year_path):
            month_path = os.path.join(year_path, month)
            if not os.path.isdir(month_path):
                continue

            for fname in os.listdir(month_path):
                if not fname.endswith(".sql"):
                    continue

                file_path = os.path.join(month_path, fname)
                d = extract_date(file_path)
                if not d:
                    continue

                iso_year, iso_week, _ = d.isocalendar()
                key = f"{iso_year}-W{iso_week:02d}"
                weekly[key] += 1

    return dict(sorted(weekly.items()))


def build_markdown(weekly_counts):
    """주별 개수를 받아 마크다운 테이블 문자열 생성."""
    if not weekly_counts:
        return "| Week      | Count | Graph        |\n|-----------|-------|--------------|"

    lines = [
        "| Week      | Count | Graph        |",
        "|-----------|-------|--------------|",
    ]

    max_count = max(weekly_counts.values())
    for week, count in weekly_counts.items():
        bar_len = max(1, int(count / max_count * 10)) if max_count > 0 else 1
        bar = "█" * bar_len
        lines.append(f"| {week} | {count:5d} | {bar:<12} |")

    return "\n".join(lines)


def update_readme():
    """Root README.md 파일 업데이트"""
    if not os.path.exists(ROOT_README_PATH):
        print(f"Error: README.md not found at {ROOT_README_PATH}")
        return False

    with open(ROOT_README_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    start_idx = content.find(START_MARKER)
    end_idx = content.find(END_MARKER)

    if start_idx == -1 or end_idx == -1:
        print("Error: Markers not found in README.md")
        print("Please add the following markers to README.md:")
        print(START_MARKER)
        print(END_MARKER)
        return False

    weekly_counts = collect_weekly_counts()
    stats_markdown = build_markdown(weekly_counts)

    new_content = (
        content[:start_idx + len(START_MARKER)]
        + "\n\n"
        + stats_markdown
        + "\n\n> 매주 일요일 오전 9시 GitHub Action을 통해 자동 집계됩니다.\n\n"
        + content[end_idx:]
    )

    if new_content == content:
        print("No changes needed.")
        return True

    with open(ROOT_README_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"Successfully updated {ROOT_README_PATH}")
    return True


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--update-readme":
        success = update_readme()
        sys.exit(0 if success else 1)
    else:
        weekly_counts = collect_weekly_counts()
        markdown = build_markdown(weekly_counts)
        print(markdown)
