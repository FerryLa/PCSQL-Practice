(MySQL)과제: CITY와 STATION 테이블을 이용해, 각 도시별(city_id) 지하철 역 개수와 함께 도시 이름을 조회하라.
단, 역이 하나도 없는 도시도 포함하고, 그런 경우 역 개수는 0으로 표시한다.
결과는 역 개수 내림차순, 도시 이름 오름차순으로 정렬하라.

-- Title: City-wise Station Count (변형)
-- Difficulty: EASY
-- Link: https://example.local/sql/city-station-count

-- Schema hint:
--   CITY(city_id INT PRIMARY KEY, city_name VARCHAR(100))
--   STATION(station_id INT PRIMARY KEY, city_id INT, station_name VARCHAR(100))

-- Sample rows:
--   INSERT INTO CITY VALUES (1,'Seoul'),(2,'Busan'),(3,'Incheon'),(4,'Daegu');
--   INSERT INTO STATION VALUES
--     (10,1,'Seoul-Station'),
--     (11,1,'CityHall'),
--     (12,2,'Busan-Station');

-- 한줄 요약: 각 도시별 지하철 역 개수, 도시이름을 조회 (단, 역이 하나도 없는 도시 포함하며 0으로 표시 / 역 개수 내림차순, 도시 오름차순)
SELECT COALEACE(COUNT(s.station_id), 0) AS cnt_station, c.city_name AS city_name
FROM CITY c
LEFT JOIN STATION s c.city = s.city_id
GROUP BY city_id
ORDER BY cnt_station DESC, city_name ASC;

-- ⌛ 경과 시간: 06:59
-- 🛑 오답 이유: 'COALEACE'가 아니라 'COALESCE' / on 빠졌네 실수
-- COALESCE는 사실상 필요없지 LEFT JOIN 써줬잖아
-- 이전 복기를 안했군 GROUP BY city_name까지 해줘야 집계함수는 SELECT절에서 사용되는 것을 모두 표기해야 안전  / 그리고 c.city_id이다.
-- 📜 복기 :


SELECT COUNT(s.station_id) AS cnt_station, c.city_name AS city_name
FROM CITY c
LEFT JOIN STATION s ON c.city = s.city_id
GROUP BY c.city_id, c.city_name
ORDER BY cnt_station DESC, city_name ASC;
