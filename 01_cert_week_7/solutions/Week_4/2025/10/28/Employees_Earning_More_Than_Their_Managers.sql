(MySQL)과제: EMPLOYEE에서 ‘상사(manager_id)가 있는’ 직원 중 자신의 상사보다 급여가 높은 직원의 이름과 급여를 조회

-- Title: Employees Earning More Than Their Managers (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/employees-earning-more-than-their-managers/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, manager_id INT NULL)
-- Sample rows:
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',7000,NULL),(2,'Bob',8000,1);
-- INSERT INTO EMPLOYEE VALUES (3,'Carol',7500,1),(4,'Dave',7200,2);

SELECT name, salary, manager_id
FROM employees e
JOIN employees m on e.id = m.id
WHERE e.salary > m.salary
ORDER BY e.salary DESC;



-- ⌛ 경과 시간: 03:54
-- 🛑 오답 이유: 또 체크 안했네.. 하나씩 삔이 나간다. employees m on e.manager_id = m.id
-- 📜 복기 :

SELECT name, salary, manager_id
FROM employees e
JOIN employees m on e.manager_id = m.id
WHERE e.salary > m.salary
ORDER BY e.salary DESC;