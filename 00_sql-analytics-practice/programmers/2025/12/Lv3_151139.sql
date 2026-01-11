-- Site   : Programmers
-- Title  : 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/151139
-- Date   : 2025-12-31

SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(*) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE CAR_ID IN (SELECT CAR_ID
                FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
                WHERE START_DATE >= '2022-08-01' AND START_DATE <'2022-11-01'
                GROUP BY CAR_ID 
                 HAVING COUNT(*)>=5) AND START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
GROUP BY MONTH(START_DATE), CAR_ID HAVING COUNT(*) <> 0
ORDER BY MONTH ASC, CAR_ID DESC

-- 복습 필요.