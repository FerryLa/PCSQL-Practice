-- 최근 7일 기준으로, ORDER_STATUS_HISTORY 테이블에서
-- status = 'DELIVERED' 인 상태 변경 건수를 날짜별로 집계하라.
--
-- ORDERS (
--   order_id   INT PRIMARY KEY,
--   user_id    INT,
--   ordered_at DATE
-- );
--
-- ORDER_STATUS_HISTORY (
--   history_id INT PRIMARY KEY,
--   order_id   INT,
--   changed_at DATE,
--   status     VARCHAR(20)  -- 'PENDING', 'PAID', 'DELIVERED', ...
-- );
--
-- 조건 정리:
-- 기준일은 CURDATE().
-- 기간: CURDATE() - INTERVAL 7 DAY 부터 CURDATE() 까지.
-- 한 주문이든 여러 주문이든 상관없고,
-- 그 날짜에 “DELIVERED 상태로 바뀐 기록”이 몇 건인지만 센다.
--
-- 출력 컬럼:
-- delivered_date : changed_at
-- delivered_order_count : 그 날짜에 DELIVERED로 바뀐 건수
-- 정렬: delivered_date 오름차순


SELECT changed_at delivered_date, COUNT(*) delivered_order_count
FROM ORDER_STATUS_HISTORY
WHERE changed_at BETWEEN CURDATE() AND CURDATE() - INTERVAL 7 DAY
    AND status = 'DELIVERED'
GROUP BY changed_at
ORDER BY delivered_date ASC;

-- 경과시간: 3분 38초
-- 오답 : CURDATE() - INTERVAL 7 DAY이 먼저

SELECT changed_at delivered_date, COUNT(*) delivered_order_count
FROM ORDER_STATUS_HISTORY
WHERE changed_at BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE()
    AND status = 'DELIVERED'
GROUP BY changed_at
ORDER BY delivered_date ASC;