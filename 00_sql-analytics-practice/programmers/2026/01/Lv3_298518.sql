
-- Site   : Programmers
-- Title  : 특정 물고기를 잡은 총 수 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/298518
-- Date   : 2026-01-16

SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO
WHERE FISH_TYPE = '0' OR FISH_TYPE = '1'
GROUP BY FISH_TYPE = '0' OR FISH_TYPE = '1'

-- 오답 복기 필요.
