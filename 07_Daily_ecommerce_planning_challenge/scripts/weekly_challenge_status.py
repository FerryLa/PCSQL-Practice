#!/usr/bin/env python3
"""
이커머스 기획 챌린지 주간 집계 스크립트
1_Daily_Records/dayXX 폴더 구조를 기준으로 주별 기획 개수를 집계합니다.
"""

import os
import re
from datetime import datetime
from collections import Counter

# 스크립트 위치 기준 상위 폴더로 이동
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TARGET_DIR = os.path.join(ROOT_DIR, "1_Daily_Records")

# README.md 파일에서 날짜를 추출하기 위한 패턴들
# 예: 2026-01-23, 날짜: 2026-01-23, Date: 2026-01-23
DATE_PATTERNS = [
    re.compile(r"날짜\s*[:：]\s*(\d{4}-\d{2}-\d{2})"),
    re.compile(r"Date\s*[:：]\s*(\d{4}-\d{2}-\d{2})", re.IGNORECASE),
    re.compile(r"작성일\s*[:：]\s*(\d{4}-\d{2}-\d{2})"),
    re.compile(r"^\s*(\d{4}-\d{2}-\d{2})\s*$"),  # 날짜만 있는 줄
]

def extract_date_from_readme(path: str):
    """README.md 파일에서 날짜 추출"""
    try:
        with open(path, encoding="utf-8") as f:
            # 상단 20줄 정도만 확인
            for _ in range(20):
                line = f.readline()
                if not line:
                    break

                for pattern in DATE_PATTERNS:
                    m = pattern.search(line)
                    if m:
                        try:
                            return datetime.strptime(m.group(1), "%Y-%m-%d").date()
                        except ValueError:
                            continue
    except (UnicodeDecodeError, FileNotFoundError):
        return None
    return None

def extract_date_from_folder_name(folder_name: str):
    """폴더명에서 day 번호를 추출하여 기본 날짜 계산 (대체 방법)"""
    # dayXX 형식에서 XX를 추출
    match = re.match(r"day(\d+)", folder_name)
    if match:
        day_num = int(match.group(1))
        # 챌린지 시작일을 기준으로 계산 (예: 2026-01-01부터 시작)
        # 실제 시작일은 첫 번째 day01 폴더의 README.md에서 추출하는 것이 좋습니다
        return day_num
    return None

def collect_weekly_counts():
    """
    1_Daily_Records/dayXX 구조를 따라가면서
    README.md 파일에서 날짜를 추출하여 주별 개수 집계
    """
    weekly = Counter()

    if not os.path.isdir(TARGET_DIR):
        return weekly  # 폴더가 없으면 빈 결과

    for folder_name in os.listdir(TARGET_DIR):
        folder_path = os.path.join(TARGET_DIR, folder_name)

        # dayXX 형식의 폴더만 처리
        if not os.path.isdir(folder_path):
            continue
        if not folder_name.startswith("day"):
            continue

        # README.md 파일에서 날짜 추출
        readme_path = os.path.join(folder_path, "README.md")
        if not os.path.exists(readme_path):
            continue

        date_obj = extract_date_from_readme(readme_path)
        if not date_obj:
            continue

        # ISO 주차 계산
        iso_year, iso_week, _ = date_obj.isocalendar()
        key = f"{iso_year}-W{iso_week:02d}"  # 예: 2026-W04
        weekly[key] += 1

    # 주차 기준으로 정렬된 dict 반환
    return dict(sorted(weekly.items()))

def build_markdown(weekly_counts):
    """주별 개수를 받아 마크다운 테이블 생성"""
    if not weekly_counts:
        return "데이터가 없습니다."

    lines = [
        "| Week      | Count | Graph        |",
        "|-----------|-------|--------------|",
    ]

    max_count = max(weekly_counts.values())
    for week, count in weekly_counts.items():
        # 최대값 기준으로 막대 길이 스케일 (최대 10칸)
        bar_len = max(1, int(count / max_count * 10)) if max_count > 0 else 1
        bar = "█" * bar_len
        lines.append(f"| {week} | {count:5d} | {bar:<12} |")

    return "\n".join(lines)

if __name__ == "__main__":
    import sys
    # Windows 콘솔 인코딩 문제 해결
    if sys.stdout.encoding != 'utf-8':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

    weekly_counts = collect_weekly_counts()
    markdown = build_markdown(weekly_counts)
    print(markdown)
