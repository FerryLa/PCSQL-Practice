
## 2. Weekly Progress 스크립트 (`weekly_progress.py`)

import os
import re
from datetime import datetime
from collections import Counter

# 레포 루트 기준: programmers/ 아래를 탐색
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
TARGET_DIR = os.path.join(ROOT_DIR, "programmers")

# -- Date   : YYYY-MM-DD 형식 파싱용
DATE_PATTERN = re.compile(r"--\s*Date\s*:\s*(\d{4}-\d{2}-\d{2})")

def extract_date(path: str):
    """파일 상단에서 Date 한 줄을 찾아 date 객체로 반환."""
    try:
        with open(path, encoding="utf-8") as f:
            # 헤더는 보통 상단 몇 줄 안에 있으니 10줄만 본다
            for _ in range(10):
                line = f.readline()
                if not line:
                    break
                m = DATE_PATTERN.search(line)
                if m:
                    return datetime.strptime(m.group(1), "%Y-%m-%d").date()
    except UnicodeDecodeError:
        # 인코딩 꼬인 파일 같은 건 그냥 무시
        return None
    return None

def collect_weekly_counts():
    """
    programmers/{year}/{month} 구조를 따라가면서
    .sql 파일들을 뒤지고, Date 기준으로 주별 개수 집계.
    """
    weekly = Counter()

    if not os.path.isdir(TARGET_DIR):
        return weekly  # programmers 폴더 없으면 빈 결과

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
                key = f"{iso_year}-W{iso_week:02d}"  # 예: 2025-W48
                weekly[key] += 1

    # 주차 기준으로 정렬된 dict 반환
    return dict(sorted(weekly.items()))

def build_markdown(weekly_counts):
    """주별 개수를 받아 README에 붙일 수 있는 마크다운 문자열 생성."""
    if not weekly_counts:
        return "## 📊 Weekly SQL Solve Count\n\n데이터가 없습니다.\n"

    lines = [
        "## 📊 Weekly SQL Solve Count",
        "",
        "| Week      | Count | Graph        |",
        "|-----------|-------|--------------|",
    ]

    max_count = max(weekly_counts.values())
    for week, count in weekly_counts.items():
        # 가장 많이 푼 주를 기준으로 막대 길이 스케일 (최대 10)
        bar_len = max(1, int(count / max_count * 10)) if max_count > 0 else 1
        bar = "█" * bar_len
        lines.append(f"| {week} | {count:5d} | {bar:<12} |")

    return "\n".join(lines)

if __name__ == "__main__":
    weekly_counts = collect_weekly_counts()
    markdown = build_markdown(weekly_counts)
    print(markdown)
