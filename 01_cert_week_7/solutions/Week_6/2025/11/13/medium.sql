(MySQL)과제: EMPLOYEE 테이블에서 부서(department_id)별로 급여 합계를 구하고, 합계가 20000 이상인 부서를만 조회하라

-- Title: Department Salary Totals Over 20000 (변형)
-- Difficulty: MEDIUM
-- Link: https://example.local/sql/dep-total-salary
-- Schema hint:
--   EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
-- Sample rows:
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',9000,1),(2,'Bob',8000,1),(3,'Carol',7500,2),(4,'Dave',7200,2),
--     (5,'Eve',6800,1),(6,'Frank',9100,3);

SELECT department_id
FROM
(
SELECT department_id, SUM(salary) AS salary
FROM EMPLOYEE
GROUP BY department_id
) AS s
WHERE s.salary >= 20000


- [답지]
-- 서브쿼리 쓸거면 최소한 이렇게
SELECT department_id, salary AS total_salary
FROM (
  SELECT department_id, SUM(salary) AS salary
  FROM EMPLOYEE
  GROUP BY department_id
) AS s
WHERE s.salary >= 20000;

-- 정석은 이렇게
SELECT
  department_id,
  SUM(salary) AS total_salary
FROM EMPLOYEE
GROUP BY department_id
HAVING SUM(salary) >= 20000
ORDER BY total_salary DESC, department_id ASC;


-- ⌛ 경과 시간: 03:00
-- 🛑 오답 이유: 너무 어렵게 생각했다. 이것도 집계로 처리할 수 있는 항목, 그리고 세미콜론, 그리고 ORDER BY
-- 📜 복기 :

SELECT department_id, SUM(salary) total_salary
FROM EMPLOYEE
GROUP BY department_id
HAVING SUM(salary) >= 20000
ORDER BY total_salary DESC, department_id ASC;
