(MySQL)과제: EMPLOYEE에서 부서별 상위 3명 급여와 이름을 조회. 같은 급여 동률은 모두 포함, department → salary 내림차순 정렬

-- Title: [플랫폼 스타일] Department Top Three Salaries (확장)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/department-top-three-salaries/
-- Schema hint:
--   EMPLOYEE(emp_id INT, name VARCHAR(100), salary INT, department_id INT)
--   DEPARTMENT(dept_id INT, name VARCHAR(100))
-- Sample rows:
--   INSERT INTO DEPARTMENT VALUES (1,'HR'),(2,'Engineering');
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',9000,2),(2,'Bob',9000,2),(3,'Carol',8800,2),
--     (4,'Dave',7200,2),(5,'Eve',6000,1),(6,'Frank',5900,1);

WITH
SELECT e.salary, e.name,
FROM employee e
JOIN department d on e.department_id = d.department_id
WHERE department_id
GROUP BY d.name
ORDER BY d.salary DESC

- [답지]
SELECT
    d.name AS department,
    e.name AS employee,
    e.salary
FROM employee e
JOIN department d ON d.dept_id = e.department_id
WHERE (
    SELECT COUNT(DISTINCT e2.salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id
    AND e2.salary > e.salary
    ) < 3
ORDER BY department, salary DESC, employee;



-- ⌛경과 시간: 5분초과
-- 🛑오답 이유: 윈도 함수 잘 모름... 공부해야 함
-- 📜복기 : 문제를 요약하자면
-- 부서별로 급여 순위를 매기고, 동점은 같은 순위로 묶는다,
-- 순위 3윆까지 포함된 사람을 전부 뽑는다, 출력은 (부서 이름, 직원이름, 급여) 정렬은 부서
```
Windo 함수란
원래는 두 테이블을 합쳐야 부서 이름을 볼 수 있다.
행단위 결과일 뿐, 아직 순위 같은 건 없다.

윈도 함수는 한 행을 보면서, 같은 그룹(창, window) 안의 다른 행들과 비교하는 함수다.
문법 핵심은 OVER (PARTITION BY ... ORDER BY ...)

DENSE_RANK 쓰는 이유
3형제:
- ROW_NUMBER() 1,2,3... 단순 번호. 동정이어도 서로 다른 번호가 매겨진다.employee
- RANK() 1,1,3... 동점 후에 건너뛴다.
- DENSE_RANK() 1,1,2... 동점 개수와 무관하게 순위 번호가 빽뺵하다.
 이 문제는 "동점 급여를 전부 포함"이므로 DENSE_RANK()가 정답'
 ```
WITH ranked AS (
 SELECT
    d.name AS department,
    e.name AS employee,
    e.salary,
    DENSE_RANK() OVER (
        PARTITION BY e.department_id
        ORDER BY e.salary DESC
      ) AS rnk
    FROM employee e
    JOIN department d
    ON d.dept_id = e.department_id;
)
SELECT department, employee, salary
FROM ranked
WHERE rnk <= 3
ORDER BY department, salary DESC, employee;

```
요약하자면 동점 순위에서 RANK는 건너뛰기 동점 순위, DENSE_RANK는 동점 개수 모두 포함
윈도 함수는 한 번더 해보며 배워야겠음