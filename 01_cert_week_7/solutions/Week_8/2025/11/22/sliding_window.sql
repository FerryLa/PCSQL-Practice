```sql
(MySQL)과제: 최근 30일 기준, 날짜별 '첫 구매' 고객 수와 첫 구매 매출 합계 구하기
```
### 🧱 테이블 스키마

```text
USERS(
  user_id    INT PRIMARY KEY,
  user_name  VARCHAR(100),
  joined_at  DATE
)

ORDERS(
  order_id   INT PRIMARY KEY,
  user_id    INT,          -- FK → USERS.user_id
  order_date DATE,
  amount     INT,          -- 주문 금액
  status     VARCHAR(20)   -- 'PENDING', 'CANCELLED', 'COMPLETED' 등
)
```

### 📌 조건 설명

1. **“첫 구매”의 정의**
   * 각 사용자별로 `status = 'COMPLETED'` 인 주문들 중
     **가장 이른(order_date가 최소)** 주문이 그 사용자의 “첫 구매”이다.

2. **대상 기간**
   * 기준일을 `CURDATE()`라고 할 때,
     `CURDATE() - 30일` 이후에 발생한 “첫 구매”만 **대상**으로 한다.

     * 즉, `first_order_date BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE()`
     * 기준일은 문제에서 따로 안 준다고 생각하고 그냥 `CURDATE()` 기준으로 처리.

3. **출력해야 할 것**
   * 날짜별(= 첫 구매 날짜별) 집계:
     * `first_order_date`  : 첫 구매가 발생한 날짜
     * `new_customer_count`: 그 날 **첫 구매를 한 고객 수**
     * `first_order_amount`: 그 날 발생한 “첫 구매 주문의 금액 합계”
       (각 고객의 첫 구매 amount만 더한다)

4. **정렬**
   * `first_order_date` 오름차순


-- 한줄 요약 : 최근 30일 기준, '첫 구매' 고객 수(신규 고객)와 첫 구매 매출 합계 구하기
-- MIN(), CURDATE(), SUM(), Subquery, join 사용

-- [풀이]
SELECT t.first_order_date, COUNT(*) AS cnt_first_order, SUM(o2.amount) AS first_order_amount
FROM
(
    SELECT user_id, MIN(o.order_date) first_order_date  -- 첫구매
    FROM USERS u
    JOIN ORDERS o ON u.user_id = o.user_id
    WHERE o.status = 'COMPLETED'
    GROUP BY u.user_id
    HAVING first_order_date =
            CURDATE() - INTERVAL 30 DAY AND CURDATE()
) AS t
JOIN ORDERS o2 ON t.user_id = o2.user_id
GROUP BY t.first_order_date
ORDER BY t.first_order_date ASC;

-- ⌛ 경과 시간: 28:27
-- 🛑 오답 이유: 서브쿼리 HAVING절 문법 오류, 바깥쿼리 SUM(o2.amount)는 첫주문이 아닌 것도 다 합쳐짐
-- 📜 복기 :
-- CURDATE()는 최근 Date를 불러오는 것은 맞고 BETWEEN과 같이 쓰면 가독성면에서 좋음
-- first_order_amount를 서브쿼리에 넣어서 합계를 가져와야됨

-- [오답 풀이]
-- 단순히 생각했을 떄 --> 🛑 이것도 오답 왜냐면 first_order_date가 같은 즉, 구매날짜가 같은 주문이 2개 이상 있을 수 있어서
SELECT t.first_order_date, COUNT(*) AS cnt_first_order, SUM(o2.amount) AS first_order_amount
FROM
(
    SELECT user_id, MIN(o.order_date) first_order_date  -- 첫구매
    FROM USERS u
    JOIN ORDERS o ON u.user_id = o.user_id
    WHERE o.status = 'COMPLETED'
    GROUP BY u.user_id
    HAVING first_order_date =
            CURDATE() - INTERVAL 30 DAY AND CURDATE()
) AS t
JOIN ORDERS o2 ON t.user_id = o2.user_id
    AND t.first_order_date = o2.order_date
GROUP BY t.first_order_date
ORDER BY t.first_order_date ASC;

-- [답지]
-- 윈도우 함수 ROW_NUMBER 사용
WITH ranked_orders AS ( -- WITH는 쿼리의 최상단에서 딱 한 번만 써야 한다.
    SELECT
        o.user_id,
        o.order_id,
        o.order_date,
        o.amount,   -- 문법 오류: 콘마 수정
        ROW_NUMBER() OVER ( -- 고객이 구매한 가장 빠른 날짜의 주문
        PARTITION BY o.user_id
        ORDER BY o.order_date, o.order_id -- 가장 빠른 날짜의 중복된 주문을 피하기 위해서
    ) AS rn
    FROM ORDERS o
    WHERE o.status = 'COMPLETED'
),
first_orders AS (  -- 윈도우 함수 사용시 이런 식으로 CTE로 만들어서 서브쿼리로 사용
    SELECT
        user_id,
        order_date,
        amount
    FROM ranked_orders
    WHERE rn = 1    -- 조건: 윈도우 함수의 행 1개
        AND order_date <= CURDATE()
        AND order_date >= CURDATE() - INTERVAL 30 DAY
)
SELECT
     order_date AS first_order_date,
     COUNT(*) AS new_customer_count,
     SUM(amount) AS first_order_amount
FROM first_orders
GROUP BY order_date
ORDER BY first_order_date ASC;



