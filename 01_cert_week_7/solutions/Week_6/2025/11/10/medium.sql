(MySQL)과제: EMPLOYEE에서 각 부서(department_id)별 상위 2명의 급여를 받는 직원의 이름과 급여를 조회하라. 동률은 모두 포함하라.

-- Title: Department Top Two Salaries (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/department-top-three-salaries/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
-- DEPARTMENT(id INT, name VARCHAR(100))
-- Sample rows:
-- INSERT INTO DEPARTMENT VALUES (1,'Engineering'),(2,'Finance');
-- INSERT INTO EMPLOYEE VALUES
-- (1,'Alice',9000,1),(2,'Bob',8500,1),(3,'Carol',8500,1),
-- (4,'Dave',8000,1),(5,'Eve',9200,2),(6,'Frank',8800,2);

SELECT d.name AS department, e.name AS name, salary
FROM EMPLOYEE e
JOIN department d ON e.department_id = d.id
WHERE
(
SELECT COUNT(DISTINCT e2.salary)
FROM EMPLOYEE e2
WHERE e2.department_id = e.department_id
AND e2.salary > e.salary
) < 2
ORDER BY d.name DESC;


[답지]
-- SELECT ...
-- FROM ...
-- JOIN ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간:
-- 🛑오답 이유:
-- 📜복기 :