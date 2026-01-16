-- Site   : Programmers
-- Title  : 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/298519
-- Date   : 2026-01-17


SELECT COUNT(*) AS FISH_COUNT, AVG(LENGTH) AS MAX_LENGH, FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING MAX_LENGH >= 33

-- 시간초과, 복기 필요: 