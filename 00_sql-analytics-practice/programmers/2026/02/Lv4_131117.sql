-- Site   : Programmers
-- Title  : 5월 식품들의 총매출 조회하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131117
-- Date   : 2026-02-20

SELECT 
    FO.PRODUCT_ID,
    FP.PRODUCT_NAME,
    FP.PRICE * FO.AMOUNT TOTAL_SALES
FROM(
    SELECT *
    FROM FOOD_ORDER
    WHERE DATE_FORMAT(PRODUCE_DATE, '%Y-%m') = '2022-05') FO
JOIN FOOD_PRODUCT FP ON FO.PRODUCT_ID = FP.PRODUCT_ID
GROUP BY FO.PRODUCT_ID
ORDER BY TOTAL_SALES DESC, FO.PRODUCT_ID ASC;

-- 오답