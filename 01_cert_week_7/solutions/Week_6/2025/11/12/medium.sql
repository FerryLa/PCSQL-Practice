(MySQL)과제: EMPLOYEE 테이블에서 각 부서(department_id)별로 두 번째로 높은 급여를 받는 직원의 이름과 급여를 조회하라 (동률은 모두 포함)

-- Title: Second Highest Salary per Department (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/second-highest-salary/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
-- DEPARTMENT(id INT, name VARCHAR(100))
-- Sample rows:
-- INSERT INTO DEPARTMENT VALUES (1,'IT'),(2,'HR');
-- INSERT INTO EMPLOYEE VALUES
-- (1,'Alice',9000,1),(2,'Bob',8500,1),(3,'Carol',8500,1),(4,'Dave',7000,1),
-- (5,'Eve',9500,2),(6,'Frank',8800,2),(7,'Grace',8700,2);

-- ORDER BY로 2번째 행을 불러온다? 아니면

SELECT d.name department, e.name name, salary
FROM EMPLOYEE e
WHERE (e.department_id, e.salary) IN
(
SELECT 1
FROM EMPLOYEE e2
JOIN DEPARTMENT d ON e2.department_id = d.id
GROUP BY department_id
ORDER BY salary DESC;
)
ORDER BY department ASC;


SELECT d.name AS department, e.name AS employee, e.salary
FROM (
    SELECT
        name,
        salary,
        department_id,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM EMPLOYEE
) e
JOIN DEPARTMENT d ON e.department_id = d.id
WHERE e.rnk = 2
ORDER BY d.name, e.salary DESC;


[답지]
-- SELECT d.name AS department, e.name AS employee, e.salary
-- FROM (
-- SELECT
-- name,
-- salary,
-- department_id,
-- DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
-- FROM EMPLOYEE
-- ) e
-- JOIN DEPARTMENT d ON e.department_id = d.id
-- WHERE e.rnk = 2
-- ORDER BY d.name, e.salary DESC;


SELECT d.name AS department, e.name AS employee, e.salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON d.id = e.department_id
WHERE e.salary = (
    SELECT DISTINCT salary
    FROM EMPLOYEE e2
    WHERE e2.department_id = e.department_id
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
)
ORDER BY d.name, e.salary DESC;


-- ⌛ 경과 시간: 15분 초과
-- 🛑 오답 이유: 그러니까 FROM에서 SELECT로 쿼리를 조회하는 것은 실행순서 상으로 WHERE절로 집계하기 위해서?
-- 📜 복기 : GROUP BY로 그룹별 평균을 계산하되, 각 직원의 행도 그대로 보고 싶을 때 사용하는 것이 윈도우 함수
-- PARTITION BY department_id: 부서별로 나눠서 계산하라.
-- ORDER BY salary DESC: 그 안에서 급여 순으로 순위를 매겨라.

SELECT d.name AS department, e.name AS employee, e.salary
FROM (
SELECT name, salary, department_id, DENSE_RANK
FROM EMPLOYEE e
) AS t
WHERE rnk = 2;

-- 조금 더 연구가 필요