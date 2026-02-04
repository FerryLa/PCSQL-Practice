-- Site   : Programmers
-- Title  : 입양 시각 구하기(2) (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59413
-- Date   : 2026-02-05

WITH HOUR_NUM AS (
    ROW_NUMBER() OVER(
        PARTITION BY HOUR(DATETIME) ORDER BY DATETIME DESC)
    FROM ANIMAL_OUTS
)
SELECT HOUR(DATETIME), COUNT(*) COUNT
FROM HOUR_NUM
GROUP BY HOUR(DATETIME)
ORDER BY HOUR(DATETIME);

-- 시간초과