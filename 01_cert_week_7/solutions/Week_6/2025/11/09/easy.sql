(MySQL)과제: STATION 테이블에서 city명이 'S'로 시작하고 'l'로 끝나는 도시의 이름을 조회하라

-- Title: Cities Starting with S and Ending with l (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/weather-observation-station-7
-- Schema hint:
--   STATION(id INT, name VARCHAR(100), city VARCHAR(100))
-- Sample rows:
--   INSERT INTO STATION VALUES (1,'CityHall','Seoul'),(2,'Main','Busan'),(3,'Line2','Suwon'),(4,'Transfer','Seoul');


SELECT name
FROM station
WHERE name REGEXP ^[S%l]$
ORDER BY name;



- [답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- ORDER BY ...;

-- ⌛ 경과 시간: 3:02
-- 🛑 오답 이유: REGEXP 잘못된 이해
-- 📜 복기 : REGEXP 문법 '.*' = 0개 이상 / LIKE가 더 깔금
-- []는 [A-Z], [1-9] 이럴 때 씀

WHERE REGEXP '^S.*l$'
WHERE city LIKE 'S%l'
