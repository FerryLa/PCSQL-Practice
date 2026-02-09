-- Site   : Programmers
-- Title  : 식품분류별 가장 비싼 식품의 정보 조회하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131116
-- Date   : 2026-02-07

SELECT
    CATEGORY,
    MAX(PRICE) MAX_PRICE,
    PRODUCT_NAME	
FROM FOOD_PRODUCT
WHERE CATEGORY = '과자'
    OR CATEGORY = '국'
    OR CATEGORY = '김치'
    OR CATEGORY = '식용유'
GROUP BY CATEGORY
ORDER BY PRICE DESC;

-- 오답