/* =====================================================================
   MySQL Exercises (Northwind) — 문제만, 네가 풀이 작성
   PostgreSQL 전용 기능을 MySQL 문법으로 풀어보자.
   힌트는 주지만, 정답 쿼리는 직접 작성.
   ===================================================================== */

-- 환경 가정: MySQL 8.0, 기본 스키마: northwind

/* 1) 고객별 최신 주문 1건
   목표: 각 customer_id에 대해 order_date 최신(동률이면 order_id 큰 것) 1건만.
   힌트: DISTINCT ON 없음 → 윈도우 함수(ROW_NUMBER() OVER PARTITION BY ...)로 rn=1만 선택.
*/
-- TODO:
-- WITH ranked AS (
--   SELECT o.customer_id, o.order_id, o.order_date,
--          ROW_NUMBER() OVER (PARTITION BY o.customer_id
--                             ORDER BY o.order_date DESC, o.order_id DESC) AS rn
--   FROM orders o
-- )
-- SELECT customer_id, order_id, order_date
-- FROM ranked
-- WHERE rn = 1;


/* 2) 월별 매출 + 국내/해외 조건부 합계
   매출식: unit_price * quantity * (1 - discount)
   목표: ym(YYYY-MM-01)별 total_sales, domestic_sales(USA), overseas_sales(USA 제외)
   힌트: FILTER 없음 → CASE WHEN 으로 조건부 SUM.
         월 버킷: DATE_FORMAT(order_date, '%Y-%m-01')
*/
-- TODO: 네 쿼리 작성
-- WITH od AS (
--   SELECT DATE_FORMAT(o.order_date, '%Y-%m-01') AS ym,
--          (d.unit_price * d.quantity * (1 - d.discount)) AS amt,
--          o.ship_country
--   FROM orders o
--   JOIN order_details d ON d.order_id = o.order_id
-- )
-- SELECT ym,
--        ROUND(SUM(amt), 2) AS total_sales,
--        ROUND(SUM(CASE WHEN ship_country = 'USA'  THEN amt ELSE 0 END), 2) AS domestic_sales,
--        ROUND(SUM(CASE WHEN ship_country <> 'USA' THEN amt ELSE 0 END), 2) AS overseas_sales
-- FROM od
-- GROUP BY ym
-- ORDER BY ym;


/* 3) “빈 달 포함” 월 매출 (데이터 없는 달도 0 표시)
   목표: 실제 주문 최소월~최대월 범위의 모든 달을 생성해 left join.
   힌트: generate_series 없음 → 재귀 CTE로 달 생성.
*/
-- TODO: 네 쿼리 작성
-- WITH RECURSIVE bounds AS (
--   SELECT DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS min_m,
--          DATE_FORMAT(MAX(order_date), '%Y-%m-01') AS max_m
--   FROM orders
-- ),
-- months AS (
--   SELECT min_m AS ym, max_m FROM bounds
--   UNION ALL
--   SELECT DATE_FORMAT(DATE_ADD(ym, INTERVAL 1 MONTH), '%Y-%m-01'), max_m
--   FROM months
--   WHERE ym < max_m
-- ),
-- sales AS (
--   SELECT DATE_FORMAT(o.order_date, '%Y-%m-01') AS ym,
--          SUM(d.unit_price * d.quantity * (1 - d.discount)) AS amt
--   FROM orders o
--   JOIN order_details d ON d.order_id = o.order_id
--   GROUP BY 1
-- )
-- SELECT m.ym,
--        ROUND(COALESCE(s.amt, 0), 2) AS monthly_sales
-- FROM months m
-- LEFT JOIN sales s ON s.ym = m.ym
-- ORDER BY m.ym;


/* 4) 카테고리/상품 소계와 총계
   목표: 카테고리-상품 합계, 카테고리 소계, 전체 총계를 한 방에.
   힌트: WITH ROLLUP 사용. 총계/소계 구분은 GROUPING() 또는 IS NULL 체크.
*/
-- TODO: 네 쿼리 작성
-- SELECT
--   c.category_name,
--   p.product_name,
--   ROUND(SUM(d.unit_price * d.quantity * (1 - d.discount)), 2) AS sales
-- FROM categories c
-- JOIN products p      ON p.category_id = c.category_id
-- JOIN order_details d ON d.product_id  = p.product_id
-- GROUP BY c.category_name, p.product_name WITH ROLLUP;


/* 5) 일일 매출 테이블 업서트
   사전 조건: CREATE TABLE daily_sales(ym date PRIMARY KEY, amount decimal(14,2));
   목표: 날짜별 합계를 넣되, 이미 있으면 amount 갱신.
   힌트: ON DUPLICATE KEY UPDATE
*/
-- TODO: 네 쿼리 작성
-- INSERT INTO daily_sales(ym, amount)
-- SELECT DATE(o.order_date) AS ym,
--        SUM(d.unit_price * d.quantity * (1 - d.discount)) AS amount
-- FROM orders o
-- JOIN order_details d ON d.order_id = o.order_id
-- GROUP BY DATE(o.order_date)
-- ON DUPLICATE KEY UPDATE amount = VALUES(amount);
