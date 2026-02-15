-- Site   : Programmers
-- Title  : 고양이와 개는 몇 마리 있을까 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59040
-- Date   : 2026-02-16

SELECT
    ANIMAL_TYPE,
    COUNT(*) count
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE = 'Cat' DESC;