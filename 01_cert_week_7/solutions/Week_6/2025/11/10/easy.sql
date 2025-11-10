(MySQL)과제: STATION에서 서로 다른 도시명(city)의 개수를 조회하라

-- Title: Count Distinct Cities (변형)
-- Difficulty: EASY
-- Link: https://www.hackerrank.com/challenges/weather-observation-station-2

-- Schema hint:
-- STATION(id INT, name VARCHAR(100), city VARCHAR(100))
-- Sample rows:
-- INSERT INTO STATION VALUES (1,'CityHall','Seoul'),(2,'Busan-Station','Busan');
-- INSERT INTO STATION VALUES (3,'Incheon-Station','Incheon'),(4,'Gangnam','Seoul');



SELECT COUNT(Distinct city)
FROM station
GROUP BY id
ORDER BY id;


[답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간: 01:30
-- 🛑오답 이유:
-- 📜복기 :