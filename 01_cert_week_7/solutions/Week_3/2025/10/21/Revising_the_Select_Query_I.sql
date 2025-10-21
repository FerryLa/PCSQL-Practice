-- https://www.hackerrank.com/challenges/revising-the-select-query/problem?isFullScreen=true
-- Revising the Select Query I
-- EasySQL (Basic) Max Score: 10 / Success Rate: 95.99%

(MySQL)과제: CITY 테이블에서 인구 100000 초과이며 CountryCode가 'USA'인 모든 행의 모든 컬럼 조회


SELECT *
FROM CITY
WHERE population > 100000 AND CountryCode LIKE 'USA';




-- [답지]
-- 참고: CITY(id, name, countrycode, district, population)
-- 아래 쿼리는 조건에 맞는 모든 컬럼(*)을 조회합니다.
-- 원문 문제는 위 링크에서 바로 확인 가능.
-- SELECT * FROM CITY
-- WHERE COUNTRYCODE = 'USA'
--   AND POPULATION > 100000;

-- ⌛경과 시간: 1분
-- 🛑오답 이유: 더 빠른 처리를 위하여 LIKE 보단 =를 사용할 수 있었음
-- 📜복기 :

-- ==================================================
