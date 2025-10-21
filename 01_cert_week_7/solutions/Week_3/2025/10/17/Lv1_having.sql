use w3db;



-- -- 부서별 평균 급여
-- SELECT dept, AVG(salary) AS avg_salary
-- FROM employees
-- WHERE status = 'ACTIVE'              -- 행 필터(그룹 만들기 전)
-- GROUP BY dept                        -- 그룹 만들기
-- HAVING AVG(salary) >= 5000;          -- 그룹 필터(집계 조건)


SELECT customer_id, SUM(amount) AS total_amount
FROM orders
WHERE amount <= 10000
GROUP BY customer_id
HAVING SUM(amount) < 50000
ORDER BY total_amount DESC;



실습 1: WHERE과 HAVING 비교
-- 30세 이상 직원만 대상으로 부서별 평균 급여 계산
SELECT department, AVG(salary) AS avg_salary
FROM employees
WHERE age >= 30
GROUP BY department
HAVING AVG(salary) > 5000;


- WHERE age >= 30: 30세 이상만 필터링
- GROUP BY department: 부서별 그룹화
- HAVING AVG(salary) > 5000: 평균 급여가 5000 초과인 부서만 출력

🎯 실습 과제
과제 1: IT 부서만 대상으로 평균 급여가 6000 이상인 경우만 출력
SELECT department '부서', AVG(salary) '평균 급여'
FROM employees
WHERE department = 'IT'
GROUP BY department
HAVING AVG(salary) >= 6000;

--
-- SELECT department, AVG(salary) AS avg_salary
-- FROM employees
-- WHERE department = 'IT'
-- GROUP BY department
-- HAVING AVG(salary) >= 6000;


과제 2: 모든 부서 중 평균 급여가 가장 높은 부서 찾기
SELECT department AS '부서', AVG(salary) AS '평균 급여'
FROM employees
GROUP BY department
ORDER BY AVG(salary) DESC LIMIT 1;

-- SELECT department, AVG(salary) AS avg_salary
-- FROM employees
-- GROUP BY department
-- ORDER BY avg_salary DESC
-- LIMIT 1;


과제 3: 평균 급여가 5000 이상인 부서 중, 직원 수가 2명 이상인 부서만 출력
SELECT department '부서', SUM(emp_id) >= 2
FROM (SELECT department, AVG(salary) FROM employees
GROUP BY department HAVING AVG(salary) >= 5000)
WHERE AVG(salary) >= 5000
GROUP BY department
HAVING SUM(emp_id) >= 2

-- SELECT department, AVG(salary) AS avg_salary, COUNT(*) AS num_employees
-- FROM employees
-- GROUP BY department
-- HAVING AVG(salary) >= 5000 AND COUNT(*) >= 2;

-- ⌛경과 시간:
-- 🛑오답 이유: WHERE 절과 HAVING에 대한 정확한 사용법에 대한 지식
-- 📜복기 : WHERE절은 행 단위 조건만 넣는다



