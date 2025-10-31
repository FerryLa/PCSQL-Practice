(MySQL)과제: EMPLOYEE와 DEPARTMENT를 이용해 각 부서 평균 급여보다 높은 급여를 받는 직원의
name, department, salary를 조회(부서명 오름차순, 급여 내림차순)

-- Title: Employees Above Department Average (집계+조인)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problemset/database/   -- 유사 스타일 참조
-- Schema hint:
--   EMPLOYEE(emp_id INT, name VARCHAR(100), salary INT, department_id INT)
--   DEPARTMENT(dept_id INT, name VARCHAR(100))
-- Sample rows:
--   INSERT INTO DEPARTMENT VALUES (1,'HR'),(2,'Engineering');
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',6000,1),(2,'Bob',5200,1),(3,'Carol',9000,2),(4,'Dave',7000,2),(5,'Eve',6500,2);

SELECT name, department, salary
FROM employees e
JOIN department d on e.department_id = d.dept_id
JOIN(
department
)
GROUP BY department
HAVING



- [답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간:
-- 🛑오답 이유:
-- 📜복기 :
