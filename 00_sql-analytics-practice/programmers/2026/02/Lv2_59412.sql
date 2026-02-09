-- Site   : Programmers
-- Title  : 입양 시각 구하기(1) (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59412
-- Date   : 2026-02-03

SELECT HOUR(DATETIME) HOUR, COUNT(*) COUNT
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) BETWEEN 9 AND 20
GROUP BY HOUR(DATETIME)
ORDER BY HOUR(DATETIME);