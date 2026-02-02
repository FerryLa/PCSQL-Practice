-- Site   : Programmers
-- Title  : 오프라인/온라인 판매 데이터 통합하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131537
-- Date   : 2026-01-25
-- Modify : 2026-02-01


SELECT 
    DATE_FORMAT(SALES_DATE, '%Y-%m-%d') SALES_DATE,
    PRODUCT_ID,
    USER_ID,
    SALES_AMOUNT
FROM ONLINE_SALE
WHERE DATE_FORMAT(SALES_DATE, '%Y-%m') = '2022-03'

UNION ALL

SELECT
    DATE_FORMAT(SALES_DATE, '%Y-%m-%d') SALES_DATE,
    PRODUCT_ID,
    NULL AS USER_ID, # 그냥 만들어줄 수 있네
    SALES_AMOUNT
FROM OFFLINE_SALE
WHERE DATE_FORMAT(SALES_DATE, '%Y-%m') = '2022-03'
ORDER BY SALES_DATE ASC, PRODUCT_ID ASC, USER_ID ASC;

-- UNION은 중복 제거, UNION ALL은 중복 포함(성능 좋음)