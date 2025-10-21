(MySQL)과제: employees 테이블에서 부서별 평균 급여를 구하고,
평균 급여가 60000 이상인 부서만 출력하시오.
출력 컬럼은 department_id, avg_salary이다.

SELECT department_id, AVG(salary) AS avg_salary
FROM employees e
GROUP BY department_id
HAVING avg_salary >= 60000

-- <<답지 / 주석처리: 최종 정답 SQL을 여기에 주석으로만 넣기>>
-- SELECT department_id,
-- AVG(salary) AS avg_salary
-- FROM employees
-- GROUP BY department_id
-- HAVING AVG(salary) >= 60000;

-- ⌛경과 시간: 약 2분 30초
-- 🛑오답 이유: 습관적인 실수 ; <<< 세미콜론 꼭 넣어주기
-- 📜복기 : 이정도면 복기 안해도 됨 하나만 더 풀자

(MySQL)과제: employees 테이블에서 2020년 이후 입사한 사원들의 이름(first_name, last_name)과
 입사일(hire_date)을 출력하시오. 단, 입사일이 빠른 순으로 정렬하시오.

 SELECT (first_name, last_name) AS 이름, hire_date AS 입사일
 FROM employees e
 ORDER BY hire_date ASC;

-- <<답지 / 주석처리: 최종 정답 SQL을 여기에 주석으로만 넣기>>
-- SELECT first_name,
-- last_name,
-- hire_date
-- FROM employees
-- WHERE hire_date >= '2020-01-01'
-- ORDER BY hire_date ASC;

-- ⌛경과 시간: 01:28
-- 🛑오답 이유: WHERE절로 2020-01-01 넣어줘야함? 문제를 똑바로 안 읽었네
-- 📜복기 :
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= '2020-01-01'
ORDER BY hire_date ASC;

(MySQL)과제: 2024년 주문 기준으로 고객별 주문수와 총액을 구하시오.
orders(o)와 order_items(oi)를 조인하여, 출력 컬럼은 customer_id, order_count, total_spent이며
조건은 order_count >= 3 이고 total_spent >= 200000 인 고객만, 총액 내림차순으로 정렬하시오.

SELECT o.customer_id, COUNT(DISTINCT o.order_id) AS order_count, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM orders o
LEFT JOIN order_items oi on o.
GROUP BY o.customer_id

-- <<답지 / 주석처리: 최종 정답 SQL을 여기에 주석으로만 넣기>>
-- SELECT
-- o.customer_id,
-- COUNT(DISTINCT o.order_id) AS order_count,
-- SUM(oi.quantity * oi.unit_price) AS total_spent
-- FROM orders AS o
-- JOIN order_items AS oi
-- ON oi.order_id = o.order_id
-- WHERE o.order_date >= '2024-01-01'
-- AND o.order_date < '2025-01-01'
-- GROUP BY o.customer_id
-- HAVING COUNT(DISTINCT o.order_id) >= 3
-- AND SUM(oi.quantity * oi.unit_price) >= 200000
-- ORDER BY total_spent DESC;

-- ⌛경과 시간: -
-- 🛑오답 이유: 어렵다. 근데 이거 컬럼명도 다 모른다.
-- 📜복기 :

SELECT o.customer_id,
COUNT(DISTINCT o.order_id)  AS order_count,
SUM(oi.quantity * oi.unit_price) AS total_spent
FROM orders o
JOIN order_items oi
WHERE o.order_date >= '2024-01-01'
AND o.order_date < '2025-01-01'
GROUP BY o.customer_id
HAVING order_count >= 3 AND total_spent >= 200000
ORDER BY total_spent DESC;

/* DISTINCT는 order_id 중복제거죠?
총액은 가격 곱하기 수량
2024년도 주문은 2024-01-01 ~ 2025-01-01로 WHERE와 AND절로 마무리 (WHERE YEAR(o.order_date) = 2024도 됨)
마지막 HAVING으로 집계하는거죠 주문 수가 3이상에 금액이 20만원 이상인걸로 */
