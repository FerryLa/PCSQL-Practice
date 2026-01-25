-- Site   : Programmers
-- Title  :오프라인/온라인 판매 데이터 통합하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131537
-- Date   : 2026-01-24


SELECT 
    DATE_FORMAT(NS.SALES_DATE, 
    NS.PRODUCT_ID,
    IFNULL(NS.USER_ID),
FROM ONLINE_SALE NS
JOIN OFFLINE_SALE FS ON NS.PRODUCT_ID = FS.PRODUCT_ID;

-- 열은 어떻게 합칠지 감이 안잡힘