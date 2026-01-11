-- Site   : Programmers
-- Title  : 자동차 대여 기록에서 장기/단기 대여 구분하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/151138
-- Date   : 2025-12-29

SELECT 
    HISTORY_ID,
    CAR_ID,
    DATE_FORMAT(START_DATE,'%Y-%m-%d'),
    DATE_FORMAT(END_DATE,'%Y-%m-%d'),
    CASE WHEN DATEDIFF(END_DATE,START_DATE) >= 29 THEN '장기 대여' ELSE '단기 대여' END
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE START_DATE BETWEEN '2022-09-01' AND '2022-09-30'
ORDER BY HISTORY_ID DESC;

-- DATE에 Lv1 문제 시간 오래 걸림
-- DATEDIFF는 시작일과 종료일을 포함하여 계산되기 때문에 실제 기간 일수를 구하려면 -1
-- WHERE START_DATE BETWEEN '2022-09-01' AND '2022-09-30' 이게 정확