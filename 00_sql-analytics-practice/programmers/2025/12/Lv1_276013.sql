-- Site   : Programmers
-- Title  : 특정 옵션이 포함된 자동차 리스트 구하기 (LEVEL 1)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/157343
-- Date   : 2025-12-26

SELECT *
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%네비게이션%'
ORDER BY CAR_ID DESC;

-- IN은 () 안에 여러 값을 넣을 수 있지만 LIKE는 하나의 패턴만 넣을 수 있다.