-- Site   : Programmers
-- Title  : 카테고리 별 상품 개수 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131529
-- Date   : 2025-12-05

SELECT
    SUBSTR(PRODUCT_CODE, 1, 2) AS Category,
    COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY SUBSTR(PRODUCT_CODE, 1,2)
ORDER BY CATEGORY ASC;

-- SUBSTR(문자열, 1, 2) << 1까지 2글자