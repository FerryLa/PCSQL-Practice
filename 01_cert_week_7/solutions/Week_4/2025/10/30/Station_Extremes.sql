(MySQL)과제: STATION에서 북쪽/남쪽/동쪽/서쪽 끝 도시에 해당하는 도시명을 각각 한 줄씩 반환 (라벨 포함)

-- Title: Station Extremes (변형)
-- Difficulty: MEDIUM
-- Link: https://www.hackerrank.com/challenges/weather-observation-station-18/problem

-- Schema hint:
-- STATION(id INT, city VARCHAR(100), state CHAR(2), lat_n DECIMAL(10,6), long_w DECIMAL(10,6))
-- Sample rows:
-- INSERT INTO STATION VALUES (10,'ANCHORAGE','AK',61.218056,149.900284);
-- INSERT INTO STATION VALUES (20,'MIAMI','FL',25.761681,80.191788);

(
SELECT city, 'NORTH'
FROM station
ORDER BY let_n DESC
)
UNION ALL
(
SELECT city, 'SOUTH'
FROM station
ORDER BY let_n ASC
)
UNION ALL
(
SELECT city, 'EAST'
FROM station
ORDER BY long_w ASC
)
UNION ALL
(
SELECT city, 'WEST'
FROM station
ORDER BY long_w DESC
)


-- ⌛ 경과 시간: 5분 30초
-- 🛑 오답 이유: LIMIT를 안 붙였네
-- 📜 복기 :

-- ✅ 정답:

-- 북(NORTH): 위도가 가장 큼, 남(SOUTH): 가장 작음
-- 동(EAST): long_w가 가장 작음, 서(WEST): long_w가 가장 큼
(
  SELECT city AS name, 'NORTH' AS extreme
  FROM STATION
  ORDER BY lat_n DESC, city ASC
  LIMIT 1
)
UNION ALL
(
  SELECT city, 'SOUTH'
  FROM STATION
  ORDER BY lat_n ASC, city ASC
  LIMIT 1
)
UNION ALL
(
  SELECT city, 'EAST'
  FROM STATION
  ORDER BY long_w ASC, city ASC
  LIMIT 1
)
UNION ALL
(
  SELECT city, 'WEST'
  FROM STATION
  ORDER BY long_w DESC, city ASC
  LIMIT 1
);