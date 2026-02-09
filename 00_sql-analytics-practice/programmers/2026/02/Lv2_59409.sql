-- Site   : Programmers
-- Title  : 중성화 여부 파악하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59409
-- Date   : 2026-02-09

SELECT 
    ANIMAL_ID, NAME,
    CASE WHEN SEX_UPON_INTAKE IN ('Neutered' OR 'Spayed') THEN 'O'
    ELSE 'X' END AS '중성화'
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;

-- 오답: IF, LIKE 혼동

SELECT
    ANIMAL_ID,
    NAME,
    IF(SEX_UPON_INTAKE REGEXP 'Neutered|Spayed','O','X') '중성화'
FROM ANIMAL_INS
ORDER BY ANIMA_ID;

-- CASE WHEN THEN보단 IF가 가독성이 좋음