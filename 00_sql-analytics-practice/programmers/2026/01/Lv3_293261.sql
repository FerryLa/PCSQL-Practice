-- Site   : Programmers
-- Title  : 물고기 종류 별 대어 찾기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293261
-- Date   : 2026-01-22

SELECT I.ID, N.FISH_NAME, I.LENGTH
FROM (
    SELECT 
        FISH_TYPE,
        MAX(LENGTH) AS MAX_LENGTH
    FROM FISH_INFO
    GROUP BY FISH_TYPE
) AS I
JOIN FISH_NAME_INFO N ON I.FISH_TYPE = N.FISH_TYPE
ORDER BY I.ID;

-- JOIN시 키값이 하나여야 한다. / 오답 복기