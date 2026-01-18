# 05_calendar - Looking Ahead 달력 자동화

Velog 스타일의 "Looking Ahead" 달력표를 자동 생성하는 스크립트입니다.

## 파일 구조

```
05_calendar/
├── README.md                    # 이 파일
├── events_data.json             # 행사 데이터 (JSON)
├── generate_looking_ahead.py    # 달력 생성 스크립트
└── LOOKING_AHEAD.md            # 생성된 달력 (출력)
```

## 사용법

### 기본 실행 (3개월 앞 행사, 8주 앞 자격시험)
```bash
cd 05_calendar
python generate_looking_ahead.py
```

### 1년치 전체 일정 보기 (추천!)
```bash
python generate_looking_ahead.py --all
```

### 전체 데이터베이스 일정 보기 (2년치)
```bash
python generate_looking_ahead.py --full
```

### 사용자 정의 기간 설정
```bash
# 6개월 앞 행사, 12주 앞 자격시험
python generate_looking_ahead.py --months 6 --weeks 12
```

### Velog 달력 업데이트
```bash
python generate_looking_ahead.py --all --update-velog
```

## 사용 옵션

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `--months N` | 행사 조회 기간 (개월) | 3 |
| `--weeks N` | 자격시험 조회 기간 (주) | 8 |
| `--all` | 1년치 전체 일정 표시 | - |
| `--full` | 전체 데이터베이스 일정 표시 (2년) | - |
| `--update-velog` | velog_calendar.md 업데이트 | - |

## 행사 데이터 수정

`events_data.json` 파일을 편집하여 행사를 추가/수정할 수 있습니다.

### 카테고리
- `domestic`: 국내 행사
- `international`: 대외 행사 (해외)
- `academic`: 학술 행사
- `certifications`: 자격시험 일정

### 행사 형식
```json
{
  "date": "2026-01-06~09",
  "name": "CES 2026",
  "location": "US",
  "city": "라스베이거스",
  "description": "세계 최대 IT 전시회"
}
```

### 국가 코드 (country_flags)
| 코드 | 국가 | 이모지 |
|------|------|--------|
| KR | 한국 | 🇰🇷 |
| US | 미국 | 🇺🇸 |
| CH | 스위스 | 🇨🇭 |
| SG | 싱가포르 | 🇸🇬 |
| FR | 프랑스 | 🇫🇷 |
| HK | 홍콩 | 🇭🇰 |
| GB | 영국 | 🇬🇧 |
| ES | 스페인 | 🇪🇸 |
| AE | UAE | 🇦🇪 |
| AT | 오스트리아 | 🇦🇹 |
| DE | 독일 | 🇩🇪 |
| SE | 스웨덴 | 🇸🇪 |
| AU | 호주 | 🇦🇺 |

## GitHub Action 자동화

매주 일요일 오전 9시 자동 업데이트를 위한 workflow:

```yaml
# .github/workflows/update-calendar.yml
name: Update Looking Ahead Calendar

on:
  schedule:
    - cron: '0 0 * * 0'  # 매주 일요일 UTC 00:00 (KST 09:00)
  workflow_dispatch:

jobs:
  update-calendar:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Generate Calendar
        run: |
          cd 05_calendar
          python generate_looking_ahead.py --update-readme
      
      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add -A
          git diff --quiet && git diff --staged --quiet || git commit -m "📅 Update Looking Ahead calendar"
          git push
```

## 출력 예시

### Looking Ahead

**국내 행사**
| 일자 | 행사명 | 장소 | 주요 내용 |
|:----:|:------:|:----:|:---------|
| 2026-01-30 | **AI SEOUL 2026** | <sub>KR</sub> 서울 | AI 산업 전반 컨퍼런스 |

**대외 행사(현지시간)**
| 일자 | 행사명 | 장소 | 주요 내용 |
|:----:|:------:|:----:|:---------|
| 2026-01-06~09 | **CES 2026** | <sub>US</sub> 라스베이거스 | 세계 최대 IT 전시회 |