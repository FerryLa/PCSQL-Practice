-- Site   : Programmers
-- Title  : 물고기 종류 별 잡은 수 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/293257
-- Date   : 2026-01-15

SELECT COUNT(*) FISH_COUNT, N.FISH_NAME
FROM FISH_INFO F
JOIN FISH_NAME_INFO N ON F.FISH_TYPE = N.FISH_TYPE
GROUP BY N.FISH_NAME
ORDER BY FISH_COUNT DESC;

-- 문제가 안풀릴 때 로직을 파고 들어서 역순으로 풀어보니 풀림