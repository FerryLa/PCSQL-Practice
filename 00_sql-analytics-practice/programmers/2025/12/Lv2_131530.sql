-- Site   : Programmers
-- Title  : 가격대 별 상품 개수 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131530
-- Date   : 2025-12-04

SELECT (FLOOR(PRICE/10000)) * 10000 AS PRICE_GROUP, COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY (FLOOR(PRICE/10000))
ORDER BY PRICE_GROUP ASC;

-- 가격대별: FLOOR(나누기연산) 사용법 