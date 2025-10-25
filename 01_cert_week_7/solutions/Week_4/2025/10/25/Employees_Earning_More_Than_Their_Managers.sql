(MySQL)과제: EMPLOYEE에서 ‘상사(manager_id)가 있는’ 직원 중 자신의 상사보다 급여가 높은 직원의 이름과 급여를 조회

-- Title: Employees Earning More Than Their Managers (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/employees-earning-more-than-their-managers/
-- Schema hint:
--   EMPLOYEE(id INT, name VARCHAR(100), salary INT, manager_id INT NULL)
-- Sample rows:
--   INSERT INTO EMPLOYEE VALUES (1,'Alice',7000,NULL),(2,'Bob',8000,1),(3,'Carol',7500,1),(4,'Dave',7200,2);

SELECT e.id, e.salary, e.manage_id
FROM employees e
LEFT JOIN employees m on e.manage_id = m.id
WHERE e.salary > m.salary;

이렇게 아닐까요?

-- ⌛경과 시간: 5분 경과
-- 🛑오답 이유: 오타(manage_id -> manager_id), 아직 머릿 속으로 정리가 빠르지 않아 5분 경과
-- LEFT JOIN을 쓰면 'manager_id INT NULL'의 NULL이 포함되어 불필요한 행이 섞일 수 있어 INNER JOIN을 쓴다.
-- 📜복기 :

자기조인에서 관리자 비교:
SELECT e.name, e.salary
FROM EMPLOYEE e
JOIN EMPLOYEE m ON e.manager_id = m.id
WHERE e.salary > m.salary;

“LEFT로 유지 + 조건은 ON” 패턴:
LEFT JOIN EMPLOYEE m
  ON e.manager_id = m.id
 AND e.salary > m.salary

