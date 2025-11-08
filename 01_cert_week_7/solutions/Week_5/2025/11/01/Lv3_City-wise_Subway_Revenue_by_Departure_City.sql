(MySQL)과제: 도시별 지하철 매출 합계 구하기(출발 도시 기준 귀속)

-- Title: City-wise Subway Revenue by Departure City
-- Difficulty: MEDIUM
-- Link: (custom) PCSQL 복기 문제

-- 규칙
-- 1) 기본 이용요금: 1000원
-- 2) 출발역의 도시 == 도착역의 도시 → 매출 1000원
-- 3) 출발역의 도시 != 도착역의 도시 → 매출 500원
-- ※ 본 문제에서는 “매출 귀속 도시”를 **출발역의 도시**로 정의한다.

-- Schema hint
--   CITY(id INT PRIMARY KEY, name VARCHAR(100))
--   STATION(id INT PRIMARY KEY, city_id INT, name VARCHAR(100))
--   USAGE(id INT PRIMARY KEY, start_station_id INT, end_station_id INT, used_at DATETIME)

-- Sample rows
--   INSERT INTO CITY VALUES (1,'Seoul'),(2,'Busan');
--   INSERT INTO STATION VALUES (10,1,'Seoul-Station'),(11,1,'CityHall'),(20,2,'Busan-Station');
--   -- 같은 도시 이동(Seoul → Seoul): 1000원이 Seoul에 귀속
--   INSERT INTO USAGE VALUES (100,10,11,'2025-10-01 08:00:00');
--   -- 다른 도시 이동(Seoul → Busan): 500원이 **출발 도시(Seoul)**에 귀속
--   INSERT INTO USAGE VALUES (101,10,20,'2025-10-01 09:00:00');

-- 요구사항
-- 모든 도시의 “출발 도시 기준” 지하철 매출 합계를 구하라.
-- 출력: city_name, total_revenue
-- 정렬: total_revenue 내림차순, 동률이면 city_name 오름차순

SELECT
  c_start.name AS city_name,
  SUM(
    CASE
      WHEN c_start.id = c_end.id THEN 1000
      ELSE 500
    END
  ) AS total_revenue
FROM usage u
JOIN station s_start ON u.start_station_id = s_start.id
JOIN station s_end   ON u.end_station_id   = s_end.id
JOIN city c_start    ON s_start.city_id    = c_start.id
JOIN city c_end      ON s_end.city_id      = c_end.id
GROUP BY c_start.name
ORDER BY total_revenue DESC, c_start.name ASC;

풀이:
    1. JOIN으로 출발역, 도착역, 두 도시를 다 연결
    2. CASE로 행별 같은 도시면 1000, 다르면 500 계산
    3. SUM() 으로 도시별 합계
    4. GROUP BY로 출발 도시 이름 기준 묶기
    5. ORDER BY로 매출 내림차순 정렬