-- Site   : Programmers
-- Title  : 서울에 위치한 식당 목록 출력하기 (LEVEL 4)
-- Link   : https://school.programmers.co.kr/learn/courses/30/lessons/131118
-- Date   : 2026-02-22

-- REST_ID	REST_NAME	FOOD_TYPE	FAVORITES	ADDRESS	SCORE
-- REST_INFO ADDRESS : 서울
-- ROUND, 평균점수 3째자리
-- ORDER BY 평균점수 DESC, 즐겨찾기수 DESC

-- SELECT *
-- FROM REST_INFO
-- WHERE ADDRESS IN ('서울')

-- -- 시간초과

SELECT
    RI.REST_ID,
    RI.REST_NAME,
    RI.FOOD_TYPE,
    RI.FAVORITES,
    RI.ADDRESS,
    ROUND(AVG(RR.REVIEW_SCORE), 2) SCORE
FROM REST_INFO RI
JOIN REST_REVIEW RR ON RI.REST_ID = RR.REST_ID
WHERE RI.ADDRESS LIKE ('서울%')
GROUP BY RI.REST_NAME
ORDER BY SCORE DESC, FAVORITES DESC;

-- IN과 LIKE, REGEXP가 다른점, 그외 순서대로하니 정답
-- 시간 오래 걸림 -> 프레임워크 손볼 필요 있음