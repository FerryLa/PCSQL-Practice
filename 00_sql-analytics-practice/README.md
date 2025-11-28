# SQL Analytics Practice (Programmers)

## 📊 Weekly SQL Solve Count

| Week      | Count | Graph        |
|-----------|-------|--------------|
| 2025-W47  |     3 | ████         |
| 2025-W48  |     7 | ██████████   |
| 2025-W49  |     2 | ██           |

**설명 :**
프로그래머스(Programmers)에서 푼 SQL 문제들을 정리하는 저장소입니다. 
문제 설명은 플랫폼에 두고, 이 레포에는 **문제 링크 + 내가 제출한 정답 SQL**만 남깁니다.

## 🧾 각 파일 형식

```text
-- Site   : Programmers
-- Title  : 문제 제목 (LEVEL x)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/문제번호
-- Date   : 2025-11-28  -- 문제 푼 날짜 (YYYY-MM-DD 형식)

SELECT ...
FROM ...
;

;
```
- 문제 설명은 적지 않습니다.
- 나중에 다시 보고 싶으면 링크를 타고 프로그래머스에서 문제를 확인합니다.
- 이 레포의 목적은 “내가 어떤 문제를 얼마나 꾸준히 풀었는지” 기록하는 데 있습니다.

---




## 📁 구조

```text
00_sql-analytics-practice/
  programmers/
    2025/
      2025-11/
        lv2_cats_and_dogs.sql
        lv3_new_vs_existing_revenue.sql
      2025-12/
        lv2_simple_join.sql
        lv3_window_fun.sql
    2026/
      2026-01/
        ...

```

- programmers/ 폴더 아래에 문제 1개당 파일 1개로 관리합니다.
- 파일명 예시는 자유지만, 보통 다음 형태를 사용합니다.



## ⏱ 운영 방식
- 하루에 최소 1문제 이상 풀고, 정답을 .sql 파일로 저장합니다.
- 커밋/푸시는 매일 혹은 며칠에 한 번 모아서 해도 상관 없습니다.


🎯 목표
- SQL 기본기 및 실전 감각 유지/강화
- 프로그래머스에서 푼 문제들을 깃허브에 기록하여 학습 히스토리 남기기
- 과한 포맷팅이나 해설 없이, 최소한의 노력으로 꾸준히 쌓이는 기록 유지하기


🛠️ 점진 목표
- matplotlib 써서 PNG 그래프 생성