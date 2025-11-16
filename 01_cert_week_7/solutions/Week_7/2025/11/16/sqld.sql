--
-- EMPLOYEE(emp_id, emp_name, dept_id, salary)
-- DEPARTMENT(dept_id, dept_name)
-- EMPLOYEE.dept_id는 DEPARTMENT.dept_id에 대한 FK이다.
-- salary는 숫자형이다.
--
-- 🔥 문제
-- 각 부서(dept_name)별로 급여 평균(avg_salary)과 직원 수(emp_count)를 구하라.
--
-- 조건:
-- 급여 평균(avg_salary)은 소수 첫째 자리에서 반올림하여 정수로 출력할 것.
-- 직원이 한 명도 없는 부서도 결과에 포함할 것.
-- (즉, 직원이 없어도 dept_name은 나오고 emp_count = 0, avg_salary = NULL 또는 0 중 하나가 되도록)

-- 정렬 기준은 아래와 같다:
-- avg_salary 내림차순
-- dept_name 오름차순

-- 결과 컬럼 이름은 다음과 같아야 한다:
-- dept_name
-- avg_salary
-- emp_count
--
-- 🙊 출력 예시 형태 (예시일 뿐)
-- dept_name | avg_salary | emp_count
-- -----------------------------------
-- IT        |    8200    |    3
-- HR        |    6500    |    1
-- Sales     |    NULL    |    0

SELECT dept_name, ROUND(AVG(salary),1) AS avg_salary, COUNT(*) AS emp_count
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC, dept_name ASC;

-- 시간 : 08:03

-- LEFT JOIN 써서 직원없는 부서 만족시키기