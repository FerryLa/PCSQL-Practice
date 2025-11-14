(MySQL)과제: CITY 테이블에서 countrycode = 'KOR' 인 도시 중
population이 1,000,000 이상인 도시의 name과 population을
population 내림차순, name 오름차순으로 조회하라

-- Title: Large Cities in Korea (변형)
-- Difficulty: EASY
-- Link: https://example.local/sql/large-kor-cities

-- Schema hint:
--   CITY(id INT, name VARCHAR(100), countrycode CHAR(3), district VARCHAR(100), population INT)
-- Sample rows:
--   INSERT INTO CITY VALUES (1,'Seoul','KOR','Seoul',9500000);
--   INSERT INTO CITY VALUES (2,'Busan','KOR','Busan',3400000);
--   INSERT INTO CITY VALUES (3,'Jeonju','KOR','Jeonbuk',650000);
--   INSERT INTO CITY VALUES (4,'Daegu','KOR','Daegu',2400000);


SELECT name, population
FROM CITY
WHERE countrycode = 'KOR'
AND population >= 1000000
ORDER BY population DESC, name ASC;





- [답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- ORDER BY ...;

-- ⌛ 경과 시간: 05:53
-- 🛑 오답 이유:
-- 📜 복기 :
