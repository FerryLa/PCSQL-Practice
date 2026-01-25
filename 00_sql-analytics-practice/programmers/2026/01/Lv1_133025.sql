-- Site   : Programmers
-- Title  : 과일로 만든 아이스크림 고르기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/133025
-- Date   : 2026-01-24

SELECT H.FLAVOR
FROM FIRST_HALF H
JOIN ICECREAM_INFO I ON H.FLAVOR = I.FLAVOR
WHERE H.TOTAL_ORDER > 3000
    AND I.INGREDIENT_TYPE = 'fruit_based'
ORDER BY H.TOTAL_ORDER DESC;