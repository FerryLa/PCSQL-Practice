-- 문제 1: 조건 + 정렬 기본기
-- 테이블: MOVIES
--
-- ID INT PK
-- TITLE VARCHAR
-- RATING DECIMAL(3,1)   -- 0.0 ~ 10.0
-- YEAR INT
--
--
-- 요구사항:
-- - 2010년 이후 개봉한 영화 중 RATING >= 8.0만 고른다.
-- - TITLE 사전순으로 정렬해 상위 5개만 출력한다.
-- - 출력 컬럼: TITLE, RATING.
--

SELECT title, rating
FROM movies
WHERE year > 2010 AND rating >= 8.0
ORDER BY rating DESC
LIMIT 5;

