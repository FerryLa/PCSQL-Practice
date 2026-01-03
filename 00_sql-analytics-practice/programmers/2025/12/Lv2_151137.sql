-- Site   : Programmers
-- Title  : 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/151137
-- Date   : 2025-12-30

SELECT CAR_TYPE, COUNT(*) CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS REGEXP '통풍시트|열선시트|가죽시트'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE;

-- REGEXP 기호 다시 재점검: https://claude.ai/share/f9744678-00de-4282-983b-ef87d7a66c89