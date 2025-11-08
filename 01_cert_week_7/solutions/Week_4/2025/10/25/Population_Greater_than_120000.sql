(MySQL)과제: CITY에서 Population>120000인 도시의 name과 population을 조회, population 내림차순 정렬

-- Title: Population Greater Than 120000 (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/revising-the-select-query-2/problem
-- Schema hint: CITY(id INT, name VARCHAR(255), countrycode CHAR(3), district VARCHAR(255), population INT)
-- Sample rows:
--   INSERT INTO CITY VALUES (1,'Seoul','KOR','Seoul',9796000);
--   INSERT INTO CITY VALUES (2,'Austin','USA','Texas',950715);


SELECT name, population
FROM city
WHERE population > 120000
ORDER BY DESC;


- [답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간: -
-- 🛑오답 이유: ? ORDER BY에 컬럼명을 안적어줬네. 실수가 잦다.
-- 📜복기 :

SELECT name, population
FROM city
WHERE population > 120000
ORDER BY population DESC;