-- Site   : Programmers
-- Title  : 없어진 기록 찾기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/59042
-- Date   : 2025-12-17

SELECT O.ANIMAL_ID, O.NAME
FROM ANIMAL_OUTS O
LEFT JOIN ANIMAL_INS I ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE I.ANIMAL_ID IS NULL;

-- 문법을 알고, 테이블이 어떻게 동작하는지 이해하니까 쉽게 풀린다.