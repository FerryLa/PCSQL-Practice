-- Site   : Programmers
-- Title  : 중복 제거하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59408
-- Date   : 2026-02-11

SELECT COUNT(DISTINCT NAME) count
FROM ANIMAL_INS
WHERE NAME IS NOT NULL;