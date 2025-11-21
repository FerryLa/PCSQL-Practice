(MySQL)과제: 2024년 월별 매출 요약 + 매출 상위 월만 조회하기

-- Title: Monthly Sales Above Yearly Average (변형)
-- Difficulty: MEDIUM
-- Link: https://example.local/sql/monthly-sales-above-avg

-- 배경
-- 온라인 쇼핑몰의 주문 테이블이 다음과 같이 있다.

--   ORDERS(
--     order_id    INT PRIMARY KEY,
--     order_date  DATE,        -- 주문 일자
--     amount      INT          -- 주문 금액
--   )

-- Sample rows:
--   INSERT INTO ORDERS VALUES
--     (101,'2024-01-05',100000),
--     (102,'2024-01-20',150000),
--     (103,'2024-02-03', 80000),
--     (104,'2024-02-25',120000),
--     (105,'2024-03-10',300000),
--     (106,'2024-03-15',250000),
--     (107,'2024-04-01', 50000),
--     (108,'2023-12-31',200000);   -- 2024년 아님, 제외 대상


-- 요구사항:

-- 1) 2024년 주문만 대상으로 한다.
--    - order_date가 2024-01-01 ~ 2024-12-31 인 행만 포함.

-- 2) 2024년 각 월(month)별 총 매출 합계(month_total)를 구한다.
--    - 월은 YYYY-MM 형식으로 표현해도 되고,
--      YEAR(order_date), MONTH(order_date) 둘 다 출력해도 된다.
--
-- 3) 2024년 1년 전체의 "월별 매출 평균"을 구한다.
--    - 예: 1~12월 중 매출 있는 달 기준으로 월별 합계를 평균낸 값.

-- 4) 그 "월별 매출 평균"보다 매출이 큰(month_total > avg_month_total) 달만 조회한다.

-- 출력 컬럼(예시):
--   sales_month      -- '2024-01' 같은 텍스트 또는 YEAR, MONTH 조합
--   month_total      -- 해당 달 매출 합계
--   avg_month_total  -- 2024 월별 평균 매출 (모든 결과 행에서 동일한 값)

-- 정렬:
--   month_total 내림차순
--   sales_month 오름차순

-- 한 줄 요약: 2024년 월별 평균 매출 보다 많은 매출 조회


-- 월별 합계


SELECT sales_month, month_total, AVG(month_total) AS avg_month_total
FROM
(
    SELECT MONTH(order_date) AS sales_month, SUM(amount) AS month_total
    FROM ORDERS
    WHERE order_date >= '2024-01-01' AND order_date <= '2024-12-31'
    GROUP BY MONTH(order_date)
)
GROUP BY sales_month
HAVING sales_month <= month_total;
ORDER BY month_total DESC, sales_month ASC;





- [답지]
-- WITH 또는 서브쿼리를 활용해도 좋음
-- 1) 2024년만 필터링
-- 2) 월별 합계 구하는 중간 결과
-- 3) 그 중간 결과의 평균을 다시 구해 붙이기
-- 4) WHERE 또는 HAVING에서 month_total > avg_month_total 조건 적용
-- 5) ORDER BY 조건 맞추기

-- WITH 활용법
WITH monthly AS (
  SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,  -- '2024-01' 형태
    SUM(amount) AS month_total
  FROM ORDERS
  WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
  GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
  m.sales_month,
  m.month_total,
  a.avg_month_total
FROM monthly m
CROSS JOIN (
  SELECT AVG(month_total) AS avg_month_total
  FROM monthly
) a
WHERE m.month_total > a.avg_month_total
ORDER BY m.month_total DESC,
         m.sales_month ASC;

-- WITH 못 쓰는 환경
SELECT
  m.sales_month,
  m.month_total,
  a.avg_month_total
FROM (
  SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    SUM(amount) AS month_total
  FROM ORDERS
  WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
  GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) m
CROSS JOIN (
  SELECT
    AVG(month_total) AS avg_month_total
  FROM (
    SELECT
      DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
      SUM(amount) AS month_total
    FROM ORDERS
    WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
  ) x
) a
WHERE m.month_total > a.avg_month_total
ORDER BY m.month_total DESC,
         m.sales_month ASC;


-- ⌛ 경과 시간: 25분 초과
-- 🛑 오답 이유: 서브쿼리 별칭, HAVING 세미콜론 오류, WHERE절 요구사항 불일치
-- 📜 복기 : 정신 차리기(실수 빈번), 새로 배우는 문제라 배우면 됨

-- 다른 형식으로 테이블 만들고 사용하기
-- CTE 활용 (가상테이블을 붙이는 것)
-- 해당 문제에선 2023년도도 있어서 MONTH(DATE값)은 문제가 생김, DATE_FORMAT를 사용 -> 월별문제는 DATE_FORMAT


-- 1) WITH : 2024년 월별 매출 합계를 먼저 구해서 monthly 라는 CTE로 정의
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month, -- '2024-01' 이런 문자열로 월 표시
        SUM(amount) AS month_total                      -- 해당 월의 총 매출 합계
    FROM ORDERS
    WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31' -- 2024년 주문만 포함
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')            -- 월 단위로 그룹핑
)
--  2) CTE monthly를 이용해서, 각 month_total 과, 전체 월 평균 매출(avg_month_total)을 함께 조회
SELECT
    m.sales_month,
    m.month_total,
    a.avg_month_total
FROM monthly m
CROSS JOIN (
    SELECT AVG(month_total) AS avg_month_total
    FROM monthly
) a
-- 3) 월별 합계가 평균보다 큰 달만 필터링
WHERE m.month_total > a.avg_month_total;
ORDER BY m.month_total DESC, m.sales_month ASC;

-- CTE란? (Common Table Expression)
-- WITH table AS (... ) : 쿼리용 미니 테이블.
-- CTE는 “중간 단계 테이블을 만든다.”
-- 윈도우 함수는 “행 옆에 계산 결과를 붙인다.”

-- CROSS JOIN은 무슨행이지?
-- 카테시안 곱: 양쪽 모든 행을 다 곱하는 것

-- DATE_FORMAT 예시
--    %m	2자리 숫자 월	03
--    %c	1~2자리 숫자 월	3
--    %M	월 이름(전체)	March
--    %b	월 이름(축약형)	Mar