-- Site   : Programmers
-- Title  : 성분으로 구분한 아이스크림 총 주문량 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/133026
-- Date   : 2026-01-20

SELECT 
    I.INGREDIENT_TYPE,
    F.TOTAL_ORDER
FROM FIRST_HALF F
JOIN ICECREAM_INFO I ON F.FLAVOR = I.FLAVOR
ORDER BY F.TOTAL_ORDER ASC;