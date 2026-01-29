-- Site   : Programmers
-- Title  : 오랜 기간 보호한 동물(2) (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59411
-- Date   : 2026-01-30

SELECT
    I.ANIMAL_ID,
    I.NAME
FROM ANIMAL_INS I
JOIN ANIMAL_OUTS O ON I.ANIMAL_ID = O.ANIMAL_ID
ORDER BY (O.DATETIME - I.DATETIME) DESC
LIMIT 2;

-- 다음 WITH RANK 사용 복기