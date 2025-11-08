(MySQL)과제: EMPLOYEE 테이블에서 부서별(department_id) 최고 급여자 이름과 급여를 조회하라

-- Title: Top Earners by Department (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/department-highest-salary/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
-- DEPARTMENT(id INT, name VARCHAR(100))
-- Sample rows:
-- INSERT INTO DEPARTMENT VALUES (1,'Engineering'),(2,'Finance');
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,1),(2,'Bob',8000,1),(3,'Carol',9500,2),(4,'Dave',7000,2);

SELECT e.department_id, e.salary
FROM employee e
JOIN department d ON e.department_id = d.id
WHERE (e.department_id, e.salary) IN
(
SELECT department_id, MAX(salary)
FROM employee
GROUP BY department_id
ORDER BY salary DESC LIMIT 1
)
ORDER BY department_id;


[답지]
-- SELECT d.name AS department, e.name AS employee, e.salary
-- FROM EMPLOYEE e
-- JOIN DEPARTMENT d ON e.department_id = d.id
-- WHERE (e.department_id, e.salary) IN (
-- SELECT department_id, MAX(salary)
-- FROM EMPLOYEE
-- GROUP BY department_id
-- );

-- ⌛ 경과 시간: 09:52
-- 🛑 오답 이유: 집중력 저하로 인한 시간 미달
-- 주요 문제:
-- - 정확한지식: ORDER BY salary DESC LIMIT 1 이걸 넣어야 하는 이유를 긴가민가
-- - 실수: WHERE절 문법오류도 있었음
-- - SELECT 표기: 부서명과 급여자 이름을 나타내야 함
-- 📜 복기 :

SELECT d.name AS department, e.name AS name, e.salary
FROM employee e
JOIN department d ON e.department_id = d.id -- 마지막 확인필요
WHERE (e.department_id, e.salary) IN
(
SELECT department_id, MAX(salary)
FROM employee
GROUP BY department_id
)
ORDER BY d.name