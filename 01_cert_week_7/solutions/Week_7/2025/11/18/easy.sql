(MySQL)과제: CITY 테이블에서 국가별(countrycode) 도시 수와 평균 인구를 구하라.
단, 평균 인구는 소수 첫째 자리에서 반올림한 정수로 출력하고,
도시 수가 3개 이상인 국가만 조회하라.

-- Title: Country-wise City Count and Average Population (학습용)
-- Difficulty: EASY
-- Link: https://example.local/sql/learn-country-city-avg

-- Schema hint:
--   CITY(
--     id INT,
--     name VARCHAR(100),
--     countrycode CHAR(3),
--     district VARCHAR(100),
--     population INT
--   )

-- Sample rows:
--   INSERT INTO CITY VALUES
--     (1,'Seoul','KOR','Seoul',9500000),
--     (2,'Busan','KOR','Busan',3400000),
--     (3,'Daegu','KOR','Daegu',2400000),
--     (4,'Tokyo','JPN','Tokyo',9200000),
--     (5,'Osaka','JPN','Osaka',2700000),
--     (6,'Nagoya','JPN','Nagoya',2300000),
--     (7,'LA','USA','California',3900000);

-- 요구사항:
--   출력 컬럼:
--     countrycode,
--     city_count      (도시 수),
--     avg_population  (평균 인구, 정수)

--   정렬:
--     avg_population 내림차순,
--     countrycode 오름차순

-- 한 줄 요약: 국가별 도시 수와 평균 인구 수 (소수 첫째자리 반올림, 도시 수 3개 이상인 국가 조회)
SELECT countrycode, COUNT(*) AS city_count, ROUND(AVG(population), 0) AS avg_population
FROM CITY
GROUP BY countrycode
HAVING city_count >= 3
ORDER BY avg_population DESC, countrycode ASC;

- [답지]
-- ⌛ 경과 시간: 4:27
-- 🛑 오답 이유: 모범답안
-- 📜 복기 :
