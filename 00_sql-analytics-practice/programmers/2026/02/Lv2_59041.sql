-- Site   : Programmers
-- Title  : 동명 동물 수 찾기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59041
-- Date   : 2026-02-13

SELECT NAME, COUNT(*) COUNT
FROM ANIMAL_INS
GROUP BY NAME
HAVING COUNT >= 2
ORDER BY NAME;