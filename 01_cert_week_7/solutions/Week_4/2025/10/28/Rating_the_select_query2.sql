(MySQL)과제: CITY에서 CountryCode = 'USA' 이고 Population > 120000 인 도시의 name을 사전순으로 조회

-- Title: Revising the Select Query II (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/revising-the-select-query-2/problem

-- Schema hint:
-- CITY(id INT, name VARCHAR(50), countrycode VARCHAR(3), district VARCHAR(50), population INT)
-- Sample rows:
-- INSERT INTO CITY VALUES (1001,'Dallas','USA','Texas',130000);
-- INSERT INTO CITY VALUES (1002,'Osaka','JPN','Osaka',2590000);

SELECT name
FROM DISTRICT city
WHERE countrycode LIKE 'USA' AND population > 120000
ORDER BY city ASC;

SELECT name
FROM CITY
WHERE countrycode = 'USA'
  AND population > 120000
ORDER BY name ASC;

-- ⌛ 경과 시간: 04:30
-- 🛑 오답 이유: DISTRICT를 왜 저기에 놓았을까? 풀이 체크 해야지
-- 그리고 실무에선 '보고서용 목록'이라 중복제거를 쓰지만 풀이에선 중복제거하란 말이 없으면 쓰지 않아도됨
-- 📜 복기 :

SELECT name
FROM city
WHERE countrycode = 'USA' AND population > 120000
ORDER BY city ASC;