(MySQL)과제: CITY 테이블에서 인구(population)가 120000을 초과하는 도시의 이름(name)과 인구를 조회
-- Title: Population Greater Than 120000
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/revising-the-select-query-2/problem

-- Schema hint: CITY(id INT, name VARCHAR(255), countrycode CHAR(3), district VARCHAR(255), population INT)
-- Sample rows:
-- INSERT INTO CITY VALUES (1,'Seoul','KOR','Seoul',9796000);
-- INSERT INTO CITY VALUES (2,'Busan','KOR','Busan',3414000);


SELECT name, population
FROM CITY
WHERE population > 120000

[답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간: 10
-- 🛑오답 이유: 정답
-- 📜복기 : (개선안) 정렬을 명시하는 게 깔끔하다

SELECT name, population
FROM CITY
WHERE population > 120000
ORDER BY population DESC, name ASC;
