# PCSQL-PRACTICE

<details>
<summary>월별 달력 일정표</summary>

### 2026년 1월

| 일 | 월 | 화 | 수 | 목 | 금 | 토 |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|     |     |     | 1   | 2   | 3   | 4   |
| 5   | 6   | 7   | 8   | 9   | 10  | 11  |
| 12  | 13  | 14  | 15  | 16  | 17  | 18  |
| 19  | 20  | 21  | 22  | 23  | 24  | 25  |
| 26  | 27  | 28  | 29  | 30  | 31  |     |

**주요 일정:**
- 1월 6-9: CES 2026 (라스베이거스)
- 1월 19-23: WEF 다보스 2026 (스위스)
- 1월 20-27: AAAI-26 (싱가포르)
- 1월 30: AI SEOUL 2026 (서울)

---

### 2026년 2월

| 일 | 월 | 화 | 수 | 목 | 금 | 토 |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 8   | 9   | 10  | 11  | 12  | 13  | 14  |
| 15  | 16  | 17  | 18  | 19  | 20  | 21  |
| 22  | 23  | 24  | 25  | 26  | 27  | 28  |

**주요 일정:**
- 2월 4-5: AI & Big Data (런던)
- 2월 5-6: NFT Paris
- 2월 7: ADsP, ADP 필기시험
- 2월 9-10: AI Revolution (싱가포르)
- 2월 11-12: Consensus Hong Kong
- 2월 17-21: ETHDenver 2026

---

### 2026년 3월

| 일 | 월 | 화 | 수 | 목 | 금 | 토 |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 8   | 9   | 10  | 11  | 12  | 13  | 14  |
| 15  | 16  | 17  | 18  | 19  | 20  | 21  |
| 22  | 23  | 24  | 25  | 26  | 27  | 28  |
| 29  | 30  | 31  |     |     |     |     |

**주요 일정:**
- 3월 14: SQLD 필기시험
- 3월 16-19: NVIDIA GTC 2026 (산호세)

---

### 2026년 4월 ~ 12월

> 전체 월별 달력은 `05_calendar/generate_looking_ahead.py --all-events` 실행 시 확인 가능

</details>

<details>
<summary>프로그래머스 일일 코딩</summary>

### 프로그래머스 코딩 집계 (자동 업데이트)

<!-- PROGRAMMERS_WEEKLY:START -->

| Week      | Count | Graph        |
|-----------|-------|--------------|
| 2025-W48 |     2 | █            |
| 2025-W49 |     9 | ████████     |
| 2025-W50 |     9 | ████████     |
| 2025-W51 |     7 | ██████       |
| 2025-W52 |    10 | █████████    |
| 2026-W01 |     7 | ██████       |
| 2026-W02 |     7 | ██████       |
| 2026-W03 |     9 | ████████     |
| 2026-W04 |    11 | ██████████   |
| 2026-W05 |     6 | █████        |

> 매주 일요일 오전 9시 GitHub Action을 통해 자동 집계됩니다.

<!-- PROGRAMMERS_WEEKLY:END -->

</details>

<details>
<summary>100일 이커머스 기획 챌린지</summary>

### 이커머스 기획 챌린지 집계 (자동 업데이트)

<!-- ECOMMERCE_CHALLENGE:START -->

| Week      | Count | Graph        |
|-----------|-------|--------------|
| 2026-W02 |     2 | ██████       |
| 2026-W03 |     3 | ██████████   |
| 2026-W04 |     2 | ██████       |

> 매주 일요일 오전 10시 GitHub Action을 통해 자동 집계됩니다.

<!-- ECOMMERCE_CHALLENGE:END -->

</details>

- **SQL Analytics Practice (00_sql-analytics-practice)**
  프로그래머스 일일 코딩 문제 풀이 및 자동화 스크립트 관리

---

## 프로젝트 개요

**PCSQL-PRACTICE**는 매일 SQL 학습 습관을 통해 쿼리 역량을 강화하고,
PostgreSQL DB 구축 경험과 Timer, Calendar 등 다양한 아이디어를 실험하는 GitHub Tools 모음입니다.

- **SQL Analytics Practice (00_sql-analytics-practice)**
  프로그래머스 일일 코딩 문제 풀이 및 자동화 스크립트 관리

- **Certification Plan (01_cert_week_7)**
  단기 7주 플랜 학습 기록

- **PostgreSQL / MySQL (02_postgresql, 03_mysql)**
  데이터베이스 구축 및 실습

- **Timer & Calendar (04_timer, 05_calendar)**
  일정 관리 및 자동화 달력 생성

- **Dual Translation (06_dual_translation)**
  번역 및 데이터 처리 실험

- **100일 이커머스 기획 챌린지 (07_Daily_ecommerce_planning_challenge)**
  매일 하나의 이커머스 아이디어를 15분 안에 기획하여 실무 감각 강화

---

## 실행 방법

1. **프로그래머스 일일 코딩 자동화**
   - `00_sql-analytics-practice` 폴더 내 스크립트 실행
   - GitHub Action이 자동으로 주간 집계 수행

2. **월별 달력 일정표 (Looking Ahead)**
   ```bash
   cd 05_calendar
   python generate_looking_ahead.py --update-readme
   ```
   - `events_data.json` 수정 시 행사 추가/변경 가능
   - `--update-readme` 옵션으로 root README.md 자동 반영

---

## 라이선스

MIT License
