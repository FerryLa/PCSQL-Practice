(MYSQL) 과제: <<CITY 테이블에서 인구 100,000 초과 도시 수 구하기>>

SELECT COUNT(city)
FROM city
WHERE population > 100000
ORDER BY city ASC;



[답지]
-- SELECT COUNT(*) AS cnt
-- FROM CITY
-- WHERE POPULATION > 100000;
-- ⏳ 경과 시간:
-- 🛑 오답 이유: 여기서는 전체 개수 하나만 구하므로 ORDER BY 불필요
-- COUNT(city)는 city가 null이면 빠지기 때문에 city가 null이라도 카운트를 하려면 COUNT(*)
-- 📝 복기 :

SELECT COUNT(*)
FROM city
WHERE population > 100000;