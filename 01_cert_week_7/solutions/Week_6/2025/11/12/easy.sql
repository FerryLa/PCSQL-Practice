(MySQL)과제: STATION 테이블에서 city명이 'A'로 시작하거나 'a'로 시작하는 도시의 이름을 중복 없이 조회하라

-- Title: Cities Starting with A (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/weather-observation-station-6

-- Schema hint:
-- STATION(id INT, name VARCHAR(100), city VARCHAR(100))
-- Sample rows:
-- INSERT INTO STATION VALUES (1,'Station1','Austin'),(2,'Station2','Seoul'),(3,'Station3','Amsterdam'),(4,'Station4','anchorage');


SELECT DISTINCT city
FROM STATION
WHERE city REGEXP '^[Aa]'
ORDER BY city ASC;





[답지]
-- SELECT DISTINCT city
-- FROM STATION
-- WHERE city REGEXP '^[Aa]'
-- ORDER BY city ASC;

-- ⌛ 경과 시간: 01:26
-- 🛑 오답 이유: 정답입니다.
-- 📜 복기 :