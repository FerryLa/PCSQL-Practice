(MySQL)과제: EMPLOYEE 테이블에서 각 부서(department)별로 최고 급여를 받는 직원의 이름과 급여를 조회하라

-- Title: Highest Salary per Department (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/department-highest-salary/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
-- DEPARTMENT(id INT, name VARCHAR(100))
-- Sample rows:
-- INSERT INTO DEPARTMENT VALUES (1,'IT'),(2,'HR');
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,1),(2,'Bob',7000,1),(3,'Carol',8000,2),(4,'Dave',7500,2);



SELECT e.name, e.salary
FROM employee e
JOIN department d ON e.department_id = d.id
WHERE (
SELECT MAX(m.salary)
FROM employee m
JOIN department n ON m.department_id = n.id
GROUP BY department_id
)
GROUP BY department_id
ORDER BY e.id;






[답지]
-- SELECT d.name AS department, e.name AS employee, e.salary
-- FROM EMPLOYEE e
-- JOIN DEPARTMENT d ON e.department_id = d.id
-- WHERE (e.department_id, e.salary) IN (
-- SELECT department_id, MAX(salary)
-- FROM EMPLOYEE
-- GROUP BY department_id
-- )
-- ORDER BY d.name ASC;

-- ⌛ 경과 시간: 10:01
-- 🛑 오답 이유: 서브쿼리와 IN에 대한 이해 부족
-- 📜 복기 : 서브쿼리만 따로 적어보기,
-- 핵심은 부서별로 급여가 가장 많은 직원을 어떻게 서브쿼리로 작성하냐 이다.
-- 그래서 그 부분을 WHERE IN을 통해 쌍 컬럼을 비교해 조회하는 것
-- 부서 조건과 최대급여 조건을 “같은 행”으로 묶어야 해서 쌍 컬럼(튜플) 비교를 해야함
-- 왜냐면 급여만 비교할시 다른부서의 급여와 묶일 수 있으니까, 이해하기 쉽게
-- 바깥쿼리(department_id, salary) == 서브쿼리(salary)하게 되면 같은 salary를 가진 다른 부서와 비교에서 참이 나올 수도 있어서


-- 비교문 2가지
WHERE e.salary = (
  SELECT MAX(salary) FROM EMPLOYEE m
  WHERE m.department_id = e.department_id
)

WHERE (e.department_id, e.salary) IN (      -- 비교문 WHERE IN
SELECT department_id, MAX(salary)
FROM employee
GROUP BY department_id

-- 다시 풀버젼

SELECT d.name '부서명', e.name '직원 이름', e.salary '급여'
FROM employee
WHERE (e.department_id, e.salary) IN (
SELECT department_id, MAX(salary)
FROM employee
GROUP BY department_id
)
ORDER BY d.name ASC;