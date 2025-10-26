(MYSQL) 과제: <<STATION 테이블에서 각 CITY별 측정소 개수와 개수가 3개 이상인 CITY만 CITY명 오름차순으로 출력>>

SELECT CITY, COUNT() AS '측정소 개수'
FROM STATION
GROUP BY CITY
HAVING CITY  > 3
ORDER BY city ASC;


[답지]
-- SELECT CITY, COUNT() AS station_count
-- FROM STATION
-- GROUP BY CITY
-- HAVING COUNT() >= 3
-- ORDER BY CITY ASC;
-- ⏳ 경과 시간:
-- 🛑 오답 이유: HAVING은 집계식을 써야 하므로 CITY > 3은 틀린 구문, 그래서 COUNT(*)을 넣어줌
-- 📝 복기 :

SELECT city, COUNT(*) AS station_count
FROM station
GROUP BY city
HAVING COUNT(*) >= 3
ORDER BY city ASC;

제약 재확인: 해커랭크/릿코드 스타일, 주석 형식 유지, 최근 문제와 중복 회피.