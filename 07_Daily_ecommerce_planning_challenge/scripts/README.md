# 이커머스 챌린지 주간 집계 스크립트

## 개요

이 폴더에는 100일 이커머스 기획 챌린지의 일일 기록을 주간 단위로 집계하여 Root README.md에 자동으로 업데이트하는 스크립트들이 포함되어 있습니다.

## 파일 구조

```
scripts/
├── weekly_challenge_status.py  # 주간 집계 스크립트
├── update_readme.py             # README 업데이트 스크립트
└── README.md                    # 이 문서
```

## 스크립트 설명

### 1. weekly_challenge_status.py

`1_Daily_Records/dayXX` 폴더 구조를 탐색하여 주간 기획 개수를 집계합니다.

**작동 방식:**
- `1_Daily_Records/dayXX/README.md` 파일에서 날짜를 추출
- 지원하는 날짜 형식:
  - `날짜: 2026-01-23`
  - `Date: 2026-01-23`
  - `작성일: 2026-01-23`
  - `2026-01-23` (단독 날짜)
- ISO 주차(YYYY-WXX) 기준으로 집계
- 주간 개수를 막대 그래프로 시각화

**실행 방법:**
```bash
cd 07_Daily_ecommerce_planning_challenge/scripts
python weekly_challenge_status.py
```

**출력 예시:**
```
| Week      | Count | Graph        |
|-----------|-------|--------------|
| 2026-W03 |     2 | ██████       |
| 2026-W04 |     3 | ██████████   |
```

### 2. update_readme.py

Root README.md 파일의 이커머스 챌린지 섹션을 자동으로 업데이트합니다.

**작동 방식:**
- `weekly_challenge_status.py`를 호출하여 주간 통계 생성
- Root README.md에서 마커 사이의 내용을 업데이트
  - 시작 마커: `<!-- ECOMMERCE_CHALLENGE:START -->`
  - 종료 마커: `<!-- ECOMMERCE_CHALLENGE:END -->`

**실행 방법:**
```bash
cd 07_Daily_ecommerce_planning_challenge/scripts
python update_readme.py
```

**주의사항:**
- Root README.md에 마커가 반드시 존재해야 합니다
- 마커가 없으면 에러 메시지와 함께 종료됩니다

## GitHub Actions

매주 일요일 오전 10시(KST)에 자동으로 실행됩니다.

**워크플로우 파일:** `.github/workflows/ecommerce_challenge_weekly.yml`

**수동 실행:**
- GitHub Actions 탭에서 `Update Ecommerce Challenge Weekly Stats` 워크플로우 선택
- "Run workflow" 버튼 클릭

## 일일 기록 작성 시 주의사항

주간 집계가 정확하게 작동하려면 각 dayXX 폴더의 README.md 파일에 다음 형식 중 하나로 날짜를 기재해야 합니다:

```markdown
날짜: 2026-01-23
```

또는

```markdown
Date: 2026-01-23
```

또는

```markdown
작성일: 2026-01-23
```

날짜는 `YYYY-MM-DD` 형식을 사용해야 하며, README.md 파일의 상단 20줄 이내에 위치해야 합니다.

## 트러블슈팅

### 집계가 안 되는 경우

1. dayXX 폴더에 README.md 파일이 있는지 확인
2. README.md 파일에 날짜가 올바른 형식으로 기재되어 있는지 확인
3. 날짜가 파일 상단 20줄 이내에 있는지 확인

### 그래프가 표시되지 않는 경우

- Windows에서 실행 시 콘솔 인코딩 문제가 발생할 수 있습니다
- 스크립트는 이를 자동으로 처리하도록 설정되어 있습니다
- GitHub Actions에서는 이 문제가 발생하지 않습니다

## 테스트

현재 5개의 샘플 데이터가 포함되어 있습니다:
- day01 ~ day03: 2026-W04 (2026년 1월 20일 ~ 22일)
- day04 ~ day05: 2026-W03 (2026년 1월 13일 ~ 14일)

이 샘플 데이터는 실제 챌린지 시작 전에 삭제하면 됩니다.
