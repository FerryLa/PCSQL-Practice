(MySQL)과제: EMPLOYEE 테이블에서 부서별(department) 최고 급여를 받는 직원의 이름과 급여를 조회하라.
단, 동일한 최고 급여자가 여러 명일 경우 모두 출력한다.

-- Title: Highest Salary per Department (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/department-highest-salary/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, department VARCHAR(100))
-- Sample rows:
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,'HR');
-- INSERT INTO EMPLOYEE VALUES (2,'Bob',8000,'HR');
-- INSERT INTO EMPLOYEE VALUES (3,'Carol',9500,'IT');
-- INSERT INTO EMPLOYEE VALUES (4,'Dave',9500,'IT');

UNION ALL

SELECT name, MAX(Salary)
FROM EMPLOYEE
GROUP BY department

-- UNION ALL 써서 하는걸로 알고 있는데 잘 모르겠다.

-- ✅ 정답:

SELECT e.name, e.salary, e.department
FROM EMPLOYEE e
JOIN (
  SELECT department, MAX(salary) AS max_salary
  FROM EMPLOYEE
  GROUP BY department
) m
ON e.department = m.department AND e.salary = m.max_salary;


-- ⌛ 경과 시간: 07:42
-- 🛑 오답 이유:
-- 📜 복기 : UNION ALL은 세로로 합치기 서로 같은 구조의 결과를 위아래로 이어 붙이는 것
-- 지금은 "부서별 최대값"이라는 요약 결과를 원래 테이블과 가로로 매칭해야 한다. 그래서 조인이 정답 루트.
-- 행을 이어 붙일 때는 서브조인, 열을 이어 붙일 때는 UNION, 엔진이 지원하면 WITH

-- 이 문제는 실제로 두 단계의 문제
-- 1. 하나는 부서마다 최대 급여 값을 구한다. 2. 그 최대 급여 값을 받는 행(직원)만 원본 행에서 뽑는다.


SELECT e.name, e.salary, e.department
FROM employee e
JOIN (
SELECT department, MAX(salary) as max_salary
FROM employee
GROUP BY department
) m
ON e.department = m.department
AND e.salary = m.max_salary


SELECT e.name, MAX(e.salary) max_salary, e.department
FROM employee
JOIN
(
SELECT name, MAX(salary) max_salary
FROM employee
GROUP BY department
) m
ON e.department = m.department AND e.salary = m.max_salary

