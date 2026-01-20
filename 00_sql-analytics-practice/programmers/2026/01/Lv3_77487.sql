-- Site   : Programmers
-- Title  : 헤비 유저가 소유한 장소 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/77487
-- Date   : 2026-01-21

SELECT DISTINCT P1.*    
FROM PLACES P1
JOIN PLACES P2 ON P1.HOST_ID = P2.HOST_ID
    AND P1.ID != P2.ID
ORDER BY ID;

-- 테이블 연산이 어떻게 되는지 아니 쉽다.