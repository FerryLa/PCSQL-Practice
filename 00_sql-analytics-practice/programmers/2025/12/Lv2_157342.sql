-- Site   : Programmers
-- Title  : 자동차 평균 대여 기간 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/157342
-- Date   : 2025-12-26

SELECT CAR_ID,
    ROUND(AVG(DATEDIFF(END_DATE, START_DATE)) + 1, 1) AS AVERAGE_DURATION
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
HAVING AVERAGE_DURATION >= 7
ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC;

-- DATEDIFF는 두 날짜의 차이를 일수로 반환한다. +1을 해야 실제 대여 기간이 된다.