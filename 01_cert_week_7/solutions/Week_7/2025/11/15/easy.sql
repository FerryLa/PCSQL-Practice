-- [상황]
-- 다음과 같은 테이블이 있다.
-- EMPLOYEE(emp_id, emp_name, dept_id, salary)
-- DEPARTMENT(dept_id, dept_name)
--
-- EMPLOYEE.emp_id : 직원 ID (PK)
-- EMPLOYEE.emp_name : 직원 이름
-- EMPLOYEE.dept_id : 부서 ID (FK → DEPARTMENT.dept_id)
-- EMPLOYEE.salary : 급여
-- DEPARTMENT.dept_id : 부서 ID (PK)
-- DEPARTMENT.dept_name : 부서 이름
--
-- [요구사항]
-- 각 부서별로 직원 수와 총 급여 합계를 구하라.
-- 결과 컬럼은 다음과 같이 하라:
-- dept_name
-- emp_cnt (직원 수)
-- total_salary (급여 합계)
-- 직원이 한 명도 없는 부서도 결과에 포함하되,
-- 그 경우 emp_cnt = 0, total_salary = 0 으로 표시하라.
-- 결과는 total_salary 내림차순, 그 다음 dept_name 오름차순으로 정렬.

SELECT
dept_name
COUNT(*) AS emp_cnt
SUM(salary) AS total_salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.dept_id = d.dept_id
AND NULLIF(emp_cnt, 0)
AND NULLIF(total_salary, 0)
GROUP BY dept_id
ORDER BY total_salary DESC, dept_name ASC;

-- [답지]
SELECT
dept_name,
COUNT(*) AS emp_cnt,
COALESCE(SUM(e.salary), 0) AS total_salary
FROM DEPARTMENT d
LEFT JOIN EMPLOYEE e
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY total_salary DESC, d.dept_name ASC;

-- [오답 복기]
-- SELECT절에 COALESCE로 NUll체크 -> 0 변환 / COUNT()는 직원 없으면 자동으로 0
-- (,) 콘마 실수
-- LEFT JOIN(INNER JOIN)으로 NULL인 값도 불러오기
-- 부서별로 dept_name 컬럼이 있으니까 그걸로 세팅