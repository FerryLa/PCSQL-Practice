(MySQL)과제: EMPLOYEE 테이블에서 각 상사(manager_id)별로 부하직원의 평균 급여를 계산하고,
 평균 급여가 7000을 초과하는 상사의 id와 평균 급여를 조회하라.

-- Title: Average Salary by Manager (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/average-salary-departments-vs-company/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, manager_id INT NULL)
-- Sample rows:
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,NULL);
-- INSERT INTO EMPLOYEE VALUES (2,'Bob',8000,1);
-- INSERT INTO EMPLOYEE VALUES (3,'Carol',6000,1);
-- INSERT INTO EMPLOYEE VALUES (4,'Dave',7200,2);

SELECT e.id, AVG(e.salary) AS avg_salary
FROM EMPLOYEE e
JOIN
(
SELECT AVG(salary)
FROM EMPLOYEE
GROUP BY manager_id
)
GROUP BY e.avg_salary
HAVING e.avg_salary > 7000;

SELECT manager_id, AVG(salary) AS avg_salary
FROM EMPLOYEE
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING AVG(salary) > 7000;

-- ⌛ 경과 시간: 04:56
-- 🛑 오답 이유: 맥락 구분 못함
-- 📜 복기 : ★ 행은 WHERE, 그룹은 HAVING

-- "각 상사별 평균"이니 GROUP BY manager_id
-- "평균이 7000 초과"는 HAVING AVG(salary) > 7000
-- 상사 없는 행은 WHERE manager_id IS NOT NULL로 제거


(MySQL)과제: EMPLOYEE 테이블에서 각 상사(manager_id)별로 부하직원의 평균 급여를 계산하고,
 평균 급여가 7000을 초과하는 상사의 id와 평균 급여를 조회하라.

SELECT manager_id, AVG(salary) as avg_salary
FROM employee
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING AVG(salary) > 7000;

