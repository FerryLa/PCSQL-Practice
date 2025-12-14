-- Site   : Programmers
-- Title  : 년, 월, 성별 별 상품 구매 회원 수 구하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131532
-- Date   : 2025-12-08

SELECT 
    YEAR(o.SALES_DATE) AS YEAR,
    MONTH(o.SALES_DATE) AS MONTH,
    u.GENDER,
    COUNT(DISTINCT o.USER_ID) AS USERS  # 상품 구매 회원 중 첫 번째
FROM USER_INFO u
JOIN ONLINE_SALE o ON u.USER_ID = o.USER_ID
WHERE u.GENDER IS NOT NULL
GROUP BY YEAR(o.SALES_DATE), MONTH(o.SALES_DATE), u.GENDER
ORDER BY YEAR, MONTH, GENDER;

-- 문제를 제대로 이해하고, 적절한 집계함수를 사용하는 것이 중요 (그러나 많이 근접했음)