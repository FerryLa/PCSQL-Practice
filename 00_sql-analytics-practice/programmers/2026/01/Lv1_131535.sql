-- Site   : Programmers
-- Title  : 조건에 맞는 회원수 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131535
-- Date   : 2026-01-28

SELECT COUNT(*) USERS
FROM USER_INFO
WHERE YEAR(JOINED) = 2021
    AND AGE >= 20 AND AGE <= 29;
