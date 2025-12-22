-- Site   : Programmers
-- Title  : 가격이 제일 비싼 식품의 정보 출력하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131115
-- Date   : 2025-12-07 


SELECT PRODUCT_ID, PRODUCT_NAME, PRODUCT_CD, CATEGORY, PRICE
FROM FOOD_PRODUCT
GROUP BY PRODUCT_ID
ORDER BY PRICE DESC LIMIT 1;

-- 서브쿼리와 MAX가 더 안정적
-- LEVEL 3 문제 풀기