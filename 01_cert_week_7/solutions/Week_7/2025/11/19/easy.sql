(MySQL)과제: 2024년에 주문을 한 고객의 이름과 총 주문 금액을 조회하라.
단, 총 주문 금액이 100,000 이상인 고객만 대상으로 하고,
총액 내림차순, 이름 오름차순으로 정렬하라.

-- Title: 2024 High-Value Customers (변형)
-- Difficulty: EASY
-- Link: https://example.local/sql/orders-2024-high-value

-- Schema hint:
--   CUSTOMER(
--     cust_id   INT PRIMARY KEY,
--     cust_name VARCHAR(100)
--   )
--
--   ORDERS(
--     order_id   INT PRIMARY KEY,
--     cust_id    INT,
--     order_date DATE,
--     amount     INT
--   )
--
-- Sample rows:
--   INSERT INTO CUSTOMER VALUES
--     (1,'Alice'),(2,'Bob'),(3,'Carol');
--
--   INSERT INTO ORDERS VALUES
--     (101,1,'2024-01-10',50000),
--     (102,1,'2024-03-05',70000),
--     (103,2,'2023-12-30',90000),
--     (104,2,'2024-02-14',40000),
--     (105,3,'2024-05-01',120000);

-- 요구사항:
--   출력 컬럼:
--     cust_name
--     total_amount  (2024년 주문 금액 합계)
--
--   조건:
--     - order_date가 2024-01-01 ~ 2024-12-31인 주문만 합산
--     - total_amount ≥ 100000 인 고객만 조회
--
--   정렬:
--     total_amount 내림차순,
--     cust_name 오름차순

-- 한줄 요약 : Customers, ORDERS 테이블을 통해 2024년에 주문을 한 고객과 총 주분 금액을 조회(100,000 이상, 정렬)
SELECT c.cust_name cust_name, SUM(o.amount) total_amount
FROM CUSTOMERS c
JOIN ORDERS o ON c.cust_id = o.cust_id
WHERE BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD')
GROUP BY c.cust_id
HAVING total_amount >= 100000
ORDER BY total_amount DESC, c.cust_name;





- [답지]
SELECT
  c.cust_name AS cust_name,
  SUM(o.amount) AS total_amount
FROM CUSTOMER AS c
JOIN ORDERS  AS o
  ON o.cust_id = c.cust_id
WHERE
  o.order_date >= '2024-01-01'
  AND o.order_date <  '2025-01-01'   -- 2024년 전체(반개구간)
GROUP BY
  c.cust_id, c.cust_name
HAVING
  SUM(o.amount) >= 100000
ORDER BY
  total_amount DESC,
  c.cust_name ASC;


-- ⌛ 경과 시간:
-- 🛑 오답 이유: WHERE절이 오라클 형식,, MySQL형식으로 바꾸기, GROUP BY select절에 name이 있어 같이 넣어주는 것이 안전
-- HAVING 에서도 별칭말고 명시적으로 SUM(o.amount)를 써주는게 좋음
-- BETWEEN '2024-01-01' AND '2024-12-31'로 써도 정상 동작, 다만 DATETIME 컬럼일 때 번개구간으로 연산식을 넣어도 됨.
-- 📜 복기 :

SELECT c.cust_name cust_name, SUM(o.amount) total_amount
FROM CUSTOMERS c
JOIN ORDERS o
    ON c.cust_id = o.cust_id
WHERE o.order_date >= '2024-01-01' AND o.order_date <= '2024-12-31'
GROUP BY c.cust_id, c.cust_name
HAVING SUM(o.amount) >= 1000000
ORDER BY total_amount DESC, cust_name;