-- Site   : Programmers
-- Title  : 5월 식품들의 총매출 조회하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131117
-- Date   : 2026-02-20 / 2026-02-21

-- SELECT 
--     FO.PRODUCT_ID,
--     FP.PRODUCT_NAME,
--     FP.PRICE * FO.AMOUNT TOTAL_SALES
-- FROM(
--     SELECT *
--     FROM FOOD_ORDER
--     WHERE DATE_FORMAT(PRODUCE_DATE, '%Y-%m') = '2022-05')
-- JOIN FOOD_PRODUCT FP ON FO.PRODUCT_ID = FP.PRODUCT_ID
-- GROUP BY FO.PRODUCT_ID
-- ORDER BY TOTAL_SALES DESC, FO.PRODUCT_ID ASC;

-- DATE_FORMAT는 인덱스를 못 써서 모두 찾아야 하기 때문에 성능적으로 좋지 않고, MySQL 전용함수라 권장하지 않는다. 
-- 따라서, 범위로 전개하는 것이 좋음

SELECT
    FO.PRODUCT_ID,
    FP.PRODUCT_NAME,
    SUM(FP.PRICE * FO.AMOUNT) AS TOTAL_SALES
FROM FOOD_ORDER FO
JOIN FOOD_PRODUCT FP ON FO.PRODUCT_ID = FP.PRODUCT_ID
WHERE FO.PRODUCE_DATE >= '2022-05-01'
  AND FO.PRODUCE_DATE <  '2022-06-01'
GROUP BY FO.PRODUCT_ID, FP.PRODUCT_NAME
ORDER BY TOTAL_SALES DESC, FO.PRODUCT_ID ASC;

-- 행단위 계산이 아닌 제품단위 계산 (절차가 아닌 집계)