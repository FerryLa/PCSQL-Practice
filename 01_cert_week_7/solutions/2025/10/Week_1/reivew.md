# 오답노트

`오답노트는 간단하게 쓰겠습니다.. 시간이 너무 늦었네요.`

별 5개
가독성 + 정확성 + 단순성 + 응용1 + 응용2

## 1. Python

Week_1/sql/problemY.sql
`4번 5번은 풀지 못했지만 3번에서 리스트로 만든 중복제거라는 큰 틀을 얻었어요.`

```py
# 1번 (★★☆☆☆)
# AND를 활용해서 if문을 제거하여 정규화가 가능했음
def pass_or_fail(kor: int, eng: int, math: int) -> str:
        avg = (kor + eng + math) / 3
        return "PASS" if (avg >= 60 and kor >= 40 and eng >= 40 and math >= 40) else "FAIL"

# 2번 (★★☆☆☆)
# 심화 o1버젼으로 작성 가능하네
def sum_of_multiples_o1(n: int) -> int:
    def s(k: int) -> int:
        m = n // k
        return k * m * (m + 1) // 2
    return s(3) + s(5) - s(15)

# 3번 (★★☆☆☆)
def unique_sorted(nums: List[int]) -> List[int]:
    return sorted(set(nums))

```

---

## 2. SQL

Week_1/sql/problemY.sql

```sql
1번 (★☆★☆☆)
-- 마지막 문장 뒤 세미콜론(;) 단순 실수 확인
SELECT emp_name
FROM employees
WHERE phone IS NOT NULL
ORDER BY emp_name ASC;

2번 (★☆★★☆)
-- 세미콜론(;) 잦은 단순 실수 : 신경써야함
SELECT
  COUNT(*)      AS total_cnt,
  MIN(salary)   AS min_salary,
  MAX(salary)   AS max_salary,
  AVG(salary)   AS avg_salary
FROM employees;

3번 (★☆★☆☆)
-- 오답: 기본 문법을 몰랐음 BETWEEN <숫자> AND <숫자>
SELECT emp_id, emp_name
FROM employees
WHERE emp_name LIKE 'K%'
  AND salary BETWEEN 380 AND 500
  AND phone IS NULL;


```
