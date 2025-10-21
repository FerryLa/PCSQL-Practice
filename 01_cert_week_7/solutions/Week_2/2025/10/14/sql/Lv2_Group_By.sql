/* =====================================================================
   Northwind — GROUP BY 기초 3문제 (PostgreSQL)
   - 바로 붙여 넣고 풀이만 채우면 됩니다.
   - 정답 쿼리는 "정답 보기" 블록에 주석으로 제공. 필요하면 주석 해제하세요.
   ===================================================================== */

SET search_path TO public;

/* 준비 점검: 테이블 존재 확인 */
-- \dt products
-- \dt categories
-- \dt orders
-- \dt employees
-- \dt customers


/* =========================================================
   문제 1) 카테고리별 상품 개수
   목표: 각 category_name 당 상품 수 집계
   출력: category_name, product_count
   힌트: JOIN categories USING(category_id), COUNT(p.product_id)
   --------------------------------------------------------- */
-- TODO: 아래 빈칸을 채워서 풀이하세요
    SELECT c.category_name, COUNT(p.product_id) product_count
    FROM categories c
    JOIN products p USING (category_id)
    GROUP BY c.category_name
    ORDER BY product_count DESC


-- SELECT
--   c.category_name,
--   COUNT(        ) AS product_count
-- FROM products p
-- JOIN categories c USING (          )
-- GROUP BY
--   c.               /* category_name */
-- ORDER BY product_count DESC;

-- -- [정답 보기] 주석 해제하면 실행됩니다
-- SELECT
--   c.category_name,
--   COUNT(p.product_id) AS product_count
-- FROM products p
-- JOIN categories c USING (category_id)
-- GROUP BY c.category_name
-- ORDER BY product_count DESC;


/* =========================================================
   문제 2) 직원별 주문 개수
   목표: 각 직원이 담당한 주문 수 집계
   출력: employee_id, employee_name, order_count
   힌트: employees ↔ orders 를 employee_id로 조인
         employee_name = first_name || ' ' || last_name
   --------------------------------------------------------- */
-- TODO: 아래 빈칸을 채워서 풀이하세요
    SELECT e.employee_id, (e.first_name || ' ' || e.last_name) employee_name, COUNT(o.order_id) order_count
    FROM employees e
    JOIN orders o USING (employee_id)
    GROUP BY order_count
    ORDER BY order_count DESC


-- SELECT
--   e.employee_id,
--   (e.first_name || ' ' || e.        ) AS employee_name,
--   COUNT(o.            ) AS order_count
-- FROM employees e
-- JOIN orders o ON o.employee_id = e.            /* employee_id */
-- GROUP BY
--   e.employee_id, e.first_name, e.             /* last_name */
-- ORDER BY order_count DESC;

-- -- [정답 보기]
-- SELECT
--   e.employee_id,
--   (e.first_name || ' ' || e.last_name) AS employee_name,
--   COUNT(o.order_id) AS order_count
-- FROM employees e
-- JOIN orders o ON o.employee_id = e.employee_id
-- GROUP BY e.employee_id, e.first_name, e.last_name
-- ORDER BY order_count DESC;


/* =========================================================
   문제 3) 국가별 고객 수
   목표: 나라(country)별 고객 수 집계
   출력: country, customer_count
   힌트: GROUP BY country, COUNT(customer_id)
   --------------------------------------------------------- */
-- TODO: 아래 빈칸을 채워서 풀이하세요
-- SELECT
--   c.          AS country,
--   COUNT(c.            ) AS customer_count
-- FROM customers c
-- GROUP BY
--   c.          /* country */
-- ORDER BY customer_count DESC;

-- -- [정답 보기]
-- SELECT
--   c.country,
--   COUNT(c.customer_id) AS customer_count
-- FROM customers c
-- GROUP BY c.country
-- ORDER BY customer_count DESC;
