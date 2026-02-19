-- Site   : Programmers
-- Title  : 물고기 종류 별 대어 찾기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293261
-- Date   : 2026-02-17

WITH ranked AS (
    SELECT
        F.FISH_ID,
        FN.FISH_NAME,
        F.LENGTH,
        ROW_NUM() OVER(
            PARTITION BY F.FISH_TYPE
            ORDER BY F.FISH_ID ASC
        )
    FROM FISH_INFO F
    JOIN FISH_NAME_INFO FN ON F.FISH_ID = FN.FISH_I
)
SELECT FISH_ID, FISH_NAME, LENGTH
FROM ranked
WHERE = 1
ORDER BY FISH_ID ASC;

-- 시간 초과