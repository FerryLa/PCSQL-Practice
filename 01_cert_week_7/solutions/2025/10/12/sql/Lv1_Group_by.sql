-- [Q1] 나라별 고객 수 구하고, 고객 수 내림차순, 동률이면 나라 오름차순
-- 작성 공간

SELECT COUNT(*) '고객 수', country '나라'
FROM customers
GROUP BY country
ORDER BY COUNT(*) DESC, Country ASC;


SELECT country, COUNT(*) AS customers
FROM customers
GROUP BY country
ORDER BY customers DESC, country;


⌛경과 시간:
🛑오답 이유:


-- [Q2] (Country, City)별 고객 수. 고객 수 3 미만은 제외. 결과는 고객 수 내림차순
-- 작성 공간

SELECT COUNT(* '고객 수', Country, City
FROM Customers
GROUP BY Country, City
HAVING COUNT(*) >= 3
ORDER BY Customers DESC

SELECT country, city, COUNT(*) AS customers
FROM customers
GROUP BY country, city
HAVING COUNT(*) >= 3
ORDER BY customers DESC;


⌛경과 시간:
🛑오답 이유: 문제 맥락 파악 실패

-- [Q3] 카테고리별 총 매출액 구하기 (order_details 기준)
-- 힌트: categories → products → order_details
-- 작성 공간

SELECT c.category_name,
       SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric(12,2) AS revenue
FROM categories c
         JOIN products p      ON p.category_id = c.category_id
         JOIN order_details od ON od.product_id = p.product_id
GROUP BY c.category_name
ORDER BY revenue DESC;


⌛경과 시간:
🛑오답 이유:


-- [Q4] 직원별 평균 주문금액이 500 이상인 직원만, 평균금액 내림차순
-- 작성 공간


WITH order_sum AS (
  SELECT order_id,
         SUM(unit_price * quantity * (1 - discount)) AS revenue
  FROM order_details
  GROUP BY order_id
)
SELECT o.employee_id,
       AVG(os.revenue)::numeric(12,2) AS avg_revenue
FROM orders o
         JOIN order_sum os ON os.order_id = o.order_id
GROUP BY o.employee_id
HAVING AVG(os.revenue) >= 500
ORDER BY avg_revenue DESC;


⌛경과 시간:
🛑오답 이유:

-- [Q5] 나라별 고객 수와 나라별 주문 수를 한 화면에서 비교(두 행으로)
-- 힌트: UNION ALL + label 컬럼
-- 작성 공간





SELECT country, COUNT(*)::int AS val, 'customers' AS src
FROM customers
GROUP BY country
UNION ALL
SELECT c.country, COUNT(*)::int, 'orders'
FROM orders o
         JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY country, src;


⌛경과 시간:
🛑오답 이유:
