/* =====================================================================
   PostgreSQL Solutions (Northwind)
   포인트: DISTINCT ON, FILTER, generate_series, ROLLUP, ON CONFLICT
   ===================================================================== */

SET search_path TO public;

/* 1) 고객별 최신 주문 1건 (PostgreSQL: DISTINCT ON) */
SELECT DISTINCT ON (o.customer_id)
    o.customer_id, o.order_id, o.order_date
FROM orders o
ORDER BY o.customer_id, o.order_date DESC, o.order_id DESC;

/* 2) 월별 매출 + 국내/해외 조건부 합계 (PostgreSQL: FILTER) */
WITH od AS (
    SELECT date_trunc('month', o.order_date)::date AS ym,
           (d.unit_price * d.quantity * (1 - d.discount))::numeric(12,2) AS amt,
           o.ship_country
    FROM orders o
             JOIN order_details d ON d.order_id = o.order_id
)
SELECT ym,
       ROUND(SUM(amt), 2)                                            AS total_sales,
       ROUND(SUM(amt) FILTER (WHERE ship_country = 'USA'), 2)        AS domestic_sales,
       ROUND(SUM(amt) FILTER (WHERE ship_country <> 'USA'), 2)       AS overseas_sales
FROM od
GROUP BY ym
ORDER BY ym;

/* 3) “빈 달 포함” 월 매출 (PostgreSQL: generate_series) */
WITH bounds AS (
    SELECT date_trunc('month', MIN(order_date))::date AS min_m,
           date_trunc('month', MAX(order_date))::date AS max_m
    FROM orders
),
     months AS (
         SELECT gs::date AS ym
         FROM bounds b,
              generate_series(b.min_m, b.max_m, interval '1 month') AS gs
     ),
     sales AS (
         SELECT date_trunc('month', o.order_date)::date AS ym,
                SUM(d.unit_price * d.quantity * (1 - d.discount))::numeric(12,2) AS amt
         FROM orders o
                  JOIN order_details d ON d.order_id = o.order_id
         GROUP BY 1
     )
SELECT m.ym,
       COALESCE(ROUND(s.amt, 2), 0) AS monthly_sales
FROM months m
         LEFT JOIN sales s USING (ym)
ORDER BY m.ym;

/* 4) 카테고리/상품 소계와 총계 (PostgreSQL: ROLLUP + GROUPING) */
SELECT
    c.category_name,
    p.product_name,
    ROUND(SUM(d.unit_price * d.quantity * (1 - d.discount)), 2) AS sales,
    GROUPING(c.category_name) AS g_cat,
    GROUPING(p.product_name)  AS g_prod
FROM categories c
         JOIN products p      ON p.category_id  = c.category_id
         JOIN order_details d ON d.product_id   = p.product_id
GROUP BY ROLLUP (c.category_name, p.product_name)
ORDER BY c.category_name NULLS LAST, p.product_name NULLS LAST;

/* 5) 일일 매출 테이블 업서트 (PostgreSQL: ON CONFLICT) */
/* 사전 조건: CREATE TABLE daily_sales(ym date PRIMARY KEY, amount numeric(14,2)); */
INSERT INTO daily_sales(ym, amount)
SELECT o.order_date::date AS ym,
       SUM(d.unit_price * d.quantity * (1 - d.discount))::numeric(14,2) AS amount
FROM orders o
         JOIN order_details d ON d.order_id = o.order_id
GROUP BY o.order_date::date
ON CONFLICT (ym)
    DO UPDATE SET amount = EXCLUDED.amount;
