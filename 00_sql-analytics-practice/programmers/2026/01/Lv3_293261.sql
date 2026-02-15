-- Site   : Programmers
-- Title  : 물고기 종류 별 대어 찾기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293261
-- Date   : 2026-01-22 / 2026-02-14

WITH ranked AS (
    SELECT
        F.ID,
        FN.FISH_NAME,
        F.LENGTH,
        ROW_NUMBER() OVER (
            PARTITION BY F.FISH_TYPE
            ORDER BY F.LENGTH DESC
        ) AS RN
    FROM FISH_INFO F
    JOIN FISH_NAME_INFO FN ON F.FISH_TYPE = FN.FISH_TYPE
)
SELECT ID, FISH_NAME, LENGTH
FROM ranked
WHERE rn = 1
ORDER BY ID;

-- JOIN시 키값이 하나여야 한다. / 오답 복기
-- 오답 복기 완료