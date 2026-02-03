-- Site   : Programmers
-- Title  : 오랜 기간 보호한 동물(1) (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59044
-- Date   : 2026-02-04

SELECT I.NAME, I.DATETIME
FROM ANIMAL_INS I
LEFT JOIN ANIMAL_OUTS O ON I.ANIMAL_ID != O.ANIMAL_ID
ORDER BY I.DATETIME DESC LIMIT 3;

-- 오답