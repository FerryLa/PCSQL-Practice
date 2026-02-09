-- Site   : Programmers
-- Title  : NULL 처리하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59410
-- Date   : 2026-02-04

SELECT
    ANIMAL_TYPE,
    IFNULL(NAME, 'No name') NAME,
    SEX_UPON_INTAKE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;