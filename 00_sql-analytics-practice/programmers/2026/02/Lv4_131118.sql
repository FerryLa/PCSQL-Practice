-- Site   : Programmers
-- Title  : 서울에 위치한 식당 목록 출력하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131118
-- Date   : 2026-02-22

-- REST_ID	REST_NAME	FOOD_TYPE	FAVORITES	ADDRESS	SCORE
-- REST_INFO ADDRESS : 서울
-- ROUND, 평균점수 3째자리
-- ORDER BY 평균점수 DESC, 즐겨찾기수 DESC

SELECT *
FROM REST_INFO
WHERE ADDRESS IN ('서울')

-- 시간초과