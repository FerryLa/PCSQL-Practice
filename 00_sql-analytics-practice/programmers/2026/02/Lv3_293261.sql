-- Site   : Programmers
-- Title  : 물고기 종류 별 대어 찾기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293261
-- Date   : 2026-02-17 / 2026-02-21

WITH ranked AS (
    SELECT
        F.ID,
        FN.FISH_NAME,
        F.LENGTH,
        ROW_NUMBER() OVER(
            PARTITION BY F.FISH_TYPE
            ORDER BY F.LENGTH DESC
        ) AS rn
    FROM FISH_INFO F
    JOIN FISH_NAME_INFO FN ON F.FISH_TYPE = FN.FISH_TYPE
    WHERE F.LENGTH IS NOT NULL
)
SELECT ID, FISH_NAME, LENGTH
FROM ranked
WHERE rn = 1
ORDER BY ID ASC;

-- IS NOT NULL 조건 확인

