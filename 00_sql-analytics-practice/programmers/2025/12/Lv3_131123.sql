-- Site   : Programmers
-- Title  : 즐겨찾기가 가장 많은 식당 정보 출력하기 (LEVEL 3)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131123
-- Date   : 2025-12-12

SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
FROM REST_INFO
WHERE (FOOD_TYPE, FAVORITES) 
    IN (SELECT FOOD_TYPE, MAX(FAVORITES)
        FROM REST_INFO
        GROUP BY FOOD_TYPE)
ORDER BY FOOD_TYPE DESC;

-- 다중행 서브쿼리를 활용한 문제 : 다중행 이해 (복습 필요)