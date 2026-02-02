-- Site   : Programmers
-- Title  : 경기도에 위치한 식품창고 목록 출력하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131114
-- Date   : 2026-01-15

SELECT 
    WAREHOUSE_ID,
    WAREHOUSE_NAME,
    ADDRESS,
    IFNULL(FREEZER_YN, 'N') AS FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE ADDRESS LIKE '경기%'
ORDER BY WAREHOUSE_ID;a

-- 기본 문법 복기