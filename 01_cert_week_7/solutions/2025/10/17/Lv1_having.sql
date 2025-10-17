use w3db;



-- 부서별 평균 급여
SELECT dept, AVG(salary) AS avg_salary
FROM employees
WHERE status = 'ACTIVE'              -- 행 필터(그룹 만들기 전)
GROUP BY dept                        -- 그룹 만들기
HAVING AVG(salary) >= 5000;          -- 그룹 필터(집계 조건)


SELECT customer_id, SUM(amount) AS total_amount
FROM orders
WHERE __________________________
GROUP BY _______________________
HAVING _________________________
ORDER BY total_amount DESC;

