-- Site   : Programmers
-- Title  : 평균 일일 대여 요금 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/151136
-- Date   : 2026-01-22

SELECT
    ROUND(AVG(DAILY_FEE), 0) AVREGE_FEE
FROM CAR_RENTAL_COMPANY_CAR 
WHERE CAR_TYPE = 'SUV';

