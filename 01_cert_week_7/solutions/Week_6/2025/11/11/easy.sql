(MySQL)과제: CITY에서 countrycode = 'KOR' 이고 population이 100000 이상 1000000 이하인 도시의 name을 사전순으로 조회

-- Title: Mid-Sized Korean Cities (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/revising-the-select-query/problem

-- Schema hint:
-- CITY(id INT, name VARCHAR(100), countrycode CHAR(3), district VARCHAR(100), population INT)
-- Sample rows:
-- INSERT INTO CITY VALUES (1,'Seoul','KOR','Seoul',9500000);
-- INSERT INTO CITY VALUES (2,'Jeonju','KOR','Jeonbuk',650000);

SELECT name, countrycode
FROM CITY
WHERE 100000 <= population <= 1000000
AND countrycode LIKE 'KOR'
ORDER BY name ASC;

[답지]
SELECT name
FROM CITY
WHERE countrycode = 'KOR'
  AND population >= 100000
  AND population <= 1000000
ORDER BY name ASC;

-- ⌛ 경과 시간: 02:19
-- 🛑 오답 이유: 파이썬 스타일은 법위 조건을 사용할 수 없다고 함, AND연산자를 사용해야 함 (2차 정규화 안됨...?)
-- 📜 복기 :

SELECT name
FROM CITY
WHERE population >= 100000
AND population <= 1000000
AND countrycode = 'KOR'
ORDER BY name ASC;