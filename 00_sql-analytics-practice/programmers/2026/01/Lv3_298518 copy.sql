-- Site   : Programmers
-- Title  : 월별 잡은 물고기 수 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293260
-- Date   : 2026-01-18


SELECT
    COUNT(*) AS FISH_COUNT,
    MONTH(FISH_TYPE) AS MONTH
FROM FISH_INFO
WHERE MONTH(FISH_TYPE) IS NOT NULL
GROUP BY FISH_TYPE
ORDER BY MONTH;

-- 복기 필요