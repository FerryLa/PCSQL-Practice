-- Site   : Programmers
-- Title  : 자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기 (LEVEL 3) 
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/157340
-- Date   : 2026-01-14

SELECT
    CAR_ID,
    CASE WHEN MAX(DATE('2022-10-16') BETWEEN START_DATE AND END_DATE) THEN '대여중'
    ELSE '대여가능' END AS 'AVAILABILITY'
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC;

-- 오답 복기 필요 : 완료