(MySQL)과제: EMPLOYEE 테이블에서 각 부서(department_id)별 평균 급여보다 급여가 낮은 직원의 이름과 급여를 조회하라

-- Title: Employees Below Department Average (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/employees-earning-more-than-average/
-- Schema hint:
--   EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
--   DEPARTMENT(id INT, name VARCHAR(100))
-- Sample rows:
--   INSERT INTO DEPARTMENT VALUES (1,'IT'),(2,'HR');
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',9000,1),(2,'Bob',7000,1),(3,'Carol',8500,1),
--     (4,'Dave',6200,2),(5,'Eve',6100,2),(6,'Frank',7500,2);

SELECT d.name as department, e.name as name, e.salary as salary
FROM employees e
JOIN department d ON e.department_id = d.id
WHERE (e.department_id, e.salary) <
(
SELECT department_id, AVG(salary)
FROM employees m
JOIN department n ON m.department_id = n.id
GROUP BY department_id
)
ORDER BY d.name;



- [답지]
-- SELECT ...
-- FROM ...
-- JOIN ...
-- WHERE ...
-- ORDER BY ...;

-- ⌛ 경과 시간: 11:33
-- 🛑 오답 이유: 일부 MySQL에서는 소대문자 구분하니까 표기대로 대문자로 쓸것 (EMPLOYEE) /
-- 📜 복기 :
SELECT e.name, e.salary
FROM EMPLOYEE e
WHERE e.salary < (
  SELECT AVG(salary)
  FROM EMPLOYEE
  WHERE department_id = e.department_id
)
ORDER BY e.department_id;


--  JOIN으로 서브쿼리 해결법 - 이게 더 깔끔
-- 간단하게 설명하자면 JOIN을 한번 더 써서 ept_avg로 명칭해주고 ON으로 department_id 연결
-- 그리고, WHERE 절로 dept_avg.avg_salary 보다 작은 e.salary를 명명
SELECT d.name AS department, e.name, e.salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.department_id, d.id
JOIN (
SELECT department_id, AVG(salary) AS avg_salary
FROM EMPLOYEE
GROUP BY department_id
) AS ept_avg ON e.department_id = dept_avg.department_id
WHERE e.salary < dept_avg.avg_salary
ORDERY BY d.name;


SELECT d.name AS department, e.name, e.salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.department_id = d.id
JOIN (
  SELECT department_id, AVG(salary) AS avg_salary
  FROM EMPLOYEE
  GROUP BY department_id
) AS dept_avg ON e.department_id = dept_avg.department_id
WHERE e.salary < dept_avg.avg_salary
ORDER BY d.name;
