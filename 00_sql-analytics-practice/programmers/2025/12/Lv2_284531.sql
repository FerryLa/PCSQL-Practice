-- Site   : Programmers
-- Title  : 노선별 평균 역 사이 거리 조회하기 (LEVEL 2)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/284531
-- Date   : 2025-12-09

SELECT ROUTE, 
    CONCAT(ROUND(SUM(D_BETWEEN_DIST), 1), 'km') TOTAL_DISTANCE,
    CONCAT(ROUND(AVG(D_BETWEEN_DIST), 2), 'km') AVERAGE_DISTANCE
FROM SUBWAY_DISTANCE
GROUP BY ROUTE
ORDER BY ROUND(SUM(D_BETWEEN_DIST), 1) DESC;