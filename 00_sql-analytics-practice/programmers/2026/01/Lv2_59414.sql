-- Site   : Programmers
-- Title  : DATETIME에서 DATE로 형 변환 (LEVEL 2) 
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59414
-- Date   : 2026-01-26

SELECT
    ANIMAL_ID,
    NAME,
    DATE_FORMAT(DATETIME, '%Y-%m-%d') AS DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID