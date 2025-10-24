(MySQL)과제: STATION에서 모음(a,e,i,o,u)으로 시작하는 CITY를 중복 없이 사전순으로 조회

-- Title: [이커머스 스타일] Weather Station Vowel Cities (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/weather-observation-station-7/problem
-- Schema hint: STATION(id INT, city VARCHAR(50), state VARCHAR(50), lat_n DECIMAL(10,4), long_w DECIMAL(10,4))
-- Sample rows:
--   INSERT INTO STATION VALUES (1,'Osaka','OS',34.6937,135.5023);
--   INSERT INTO STATION VALUES (2,'seoul','KR',37.5665,126.9780);

SELECT s.city, s.state
FROM station s
WHERE 'a', 'e', 'i', 'o', 'u'

- [답지 1안]
SELECT DISTINCT city
FROM station
WHERE LOWER(city) REGXP '^[aeiou]'
ORDER BY city ASC;

- [답지 2안]
-- SELECT DISTINCT city
-- FROM STATION
-- WHERE city LIKE 'a%' OR city LIKE 'e%' OR city LIKE 'i%' OR city LIKE 'o%' OR city LIKE 'u%'
--    OR city LIKE 'A%' OR city LIKE 'E%' OR city LIKE 'I%' OR city LIKE 'O%' OR city LIKE 'U%'
-- ORDER BY city;

-- ⌛경과 시간: 5분 초과
-- 🛑오답 이유: []는 배웠지만 못나타냈음, 나머지는 모르는 구문이기에 배우면 된다.
-- 📜복기 : LOWER는 대소문자를 소문자로 일관성 유지, ^a << 'a로 시작하는 문자열'이라는 의미로 %와는 다름
-- ++ LIKE는 대소문자 구분이 있지만, REGEXP는 대소문자 구분이 없음
-- REGEXP는 문자열이 어떤 규칙에 맞는지 검사할 때 쓰고, LIKE보다 한단계 더 높다.

SELECT DISTINCT city
FROM station
WHERE LOWER(city) REGEXP '^[aeiou]'
ORDER BY city

