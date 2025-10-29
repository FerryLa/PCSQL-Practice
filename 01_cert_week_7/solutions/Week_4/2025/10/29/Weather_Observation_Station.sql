(MySQL)과제: STATION에서 CITY가 'A'로 시작하지 않는 도시 수를 구하라

-- Title: Weather Observation Station – Not Starting With 'A' (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/domains/sql/weather-observation-station   -- 유사 스타일 참조
-- Schema hint: STATION(id INT, city VARCHAR(50), state VARCHAR(50), lat_n DECIMAL(10,4), long_w DECIMAL(10,4))
-- Sample rows:
--   INSERT INTO STATION VALUES (1,'Austin','TX',30.2672,97.7431);
--   INSERT INTO STATION VALUES (2,'Seoul','KR',37.5665,126.9780);


SELECT COUNT(city)
FROM station
WHERE city NOT LIKE 'A%';


- [답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간: 약 1분30초
-- 🛑오답 이유: COUNT(*)를 사용해야 NULL값도 행 수로 포함
-- 📜복기 : 정규식 사용 a,A로 시작하지 않는 도시

SELECT COUNT(*)
FROM station
WHERE city NOT REGEXP '^[aA]'
