-- Site   : Programmers
-- Title  : 나이 정보가 없는 회원 수 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131528
-- Date   : 2025-12-24

SELECT COUNT(*) USERS
FROM USER_INFO
WHERE AGE IS NULL;

