-- Site   : Programmers
-- Title  : 인기있는 아이스크림 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/133024
-- Date   : 2026-01-20

SELECT FLAVOR
FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID;