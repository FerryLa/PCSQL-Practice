-- Site   : Programmers
-- Title  : 대여 기록이 존재하는 자동차 리스트 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/157341
-- Date   : 2025-12-27

SELECT DISTINCT(C.CAR_ID)
FROM CAR_RENTAL_COMPANY_CAR C
JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY H ON C.CAR_ID = H.CAR_ID
WHERE CAR_TYPE = '세단'
    AND MONTH(H.START_DATE) = 10
ORDER BY C.CAR_ID DESC;

-- 15분컷, 원빵 정답