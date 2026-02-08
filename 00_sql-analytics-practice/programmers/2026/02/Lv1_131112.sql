-- Site   : Programmers
-- Title  : 강원도에 위치한 생산공장 목록 출력하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131112
-- Date   : 2026-02-09

SELECT
    FACTORY_ID,
    FACTORY_NAME,
    ADDRESS
FROM FOOD_FACTORY
WHERE ADDRESS LIKE ('강원도%')
ORDER BY FACTORY_ID;