-- northwind.sql
use practice_db
SET search_path TO northwind, public;

-- =====================================================================
-- Northwind Practice Set — DISTINCT, GROUP BY, WHERE, UNION, SET OPS
-- 엔진: SQLite / PostgreSQL / SQL Server 대부분 호환
-- 주의: 문자열 합치기나 날짜함수는 엔진별 차이 있음. 여기서는 불필요.
-- =====================================================================

PRAGMA foreign_keys = ON;  -- SQLite일 때 무해. 다른 엔진은 무시.

-----------------------------------------------------------------------
-- Q1. DISTINCT 기본
-- Customers에서 나라 목록을 중복 없이 알파벳순으로 뽑아라.
-- 결과 컬럼: Country 1개
-----------------------------------------------------------------------
-- TODO: 너의 정답
SELECT DISTINCT Country
FROM Customers
WHERE Country ASC;

-- 체크: 중복이 있으면 실패
-- SQLite/Postgres
-- SELECT Country, COUNT(*) cnt FROM Customers GROUP BY Country HAVING COUNT(*) > 1;

-----------------------------------------------------------------------
-- Q2. GROUP BY 기본
-- Customers에서 나라별 고객 수를 구하고, 고객 수가 많은 순으로 정렬
-- 결과 컬럼: Country, cnt
-----------------------------------------------------------------------
-- TODO:
SELECT COUNT(CustomerID) '고객 수'
FROM Customers
GROUP BY Cuntry
ORDER BY COUNT(CustomerID) DESC

-- 체크: cnt 합이 전체 고객 수와 같아야 함
-- SELECT SUM(cnt) FROM (
--   SELECT Country, COUNT(*) AS cnt FROM Customers GROUP BY Country
-- );

-----------------------------------------------------------------------
-- Q3. WHERE 논리
-- Products에서 UnitsInStock > 0 AND Discontinued = 0 인 제품의 "개수"
-- 결과 컬럼: n (정수 1개)
-----------------------------------------------------------------------
-- TODO:
-- SELECT ... AS n FROM Products ... ;

-- 체크: n은 0보다 크다(보통)
-- -- SELECT (/*너의 쿼리*/) > 0;

-----------------------------------------------------------------------
-- Q4. 다중 기준 그룹핑
-- Customers에서 (Country, City) 별 고객 수. 고객 수 3 미만 제외
-- 결과 컬럼: Country, City, cnt  (cnt >= 3)
-----------------------------------------------------------------------
-- TODO:
-- SELECT ...;

-- 체크: 최소 cnt는 3이어야 함
-- SELECT MIN(cnt) FROM (
--   SELECT Country, City, COUNT(*) AS cnt
--   FROM Customers
--   GROUP BY Country, City
--   HAVING COUNT(*) >= 3
-- );

-----------------------------------------------------------------------
-- Q5. 주문 요약(조인 + 집계)
-- Orders, OrderDetails 사용.
-- 매출 = SUM(UnitPrice * Quantity * (1 - Discount))
-- 주문별 매출을 계산해 매출 큰 순 상위 10개
-- 결과 컬럼: OrderID, revenue
-----------------------------------------------------------------------
-- TODO:
-- SELECT ...;

-- 체크: revenue는 0보다 커야 함
-- SELECT COUNT(*) FROM (
--   /* 너의 쿼리 */
-- ) t WHERE revenue <= 0;

-----------------------------------------------------------------------
-- Q6. HAVING vs WHERE
-- 직원별(EmployeeID) 주문 건수, 50건 이상만. 건수 많은 순
-- 결과 컬럼: EmployeeID, cnt  (cnt >= 50)
-----------------------------------------------------------------------
-- TODO:
-- SELECT ...;

-- 체크: WHERE가 아니라 HAVING을 써야 건수 필터가 적용됨(집계 이후)
-- 힌트:
-- -- WHERE는 개별 행 필터, HAVING은 그룹 결과 필터

-----------------------------------------------------------------------
-- Q7. UNION vs UNION ALL
-- Customers와 Suppliers에서 Country를 합쳐 나라 목록 생성
-- (1) UNION으로 나라 개수 세기 -> 컬럼명 total_union
-- (2) UNION ALL로 나라 개수 세기 -> 컬럼명 total_all
-- 그리고 왜 다른지 주석으로 한 줄 설명
-----------------------------------------------------------------------
-- (1) TODO:
-- SELECT COUNT(*) AS total_union FROM (
--   SELECT Country FROM Customers
--   UNION
--   SELECT Country FROM Suppliers
-- ) u;

-- (2) TODO:
-- SELECT COUNT(*) AS total_all FROM (
--   SELECT Country FROM Customers
--   UNION ALL
--   SELECT Country FROM Suppliers
-- ) a;

-- 설명:
-- -- TODO: 여기에 한 줄로.

-----------------------------------------------------------------------
-- Q8. INTERSECT / EXCEPT
-- 주문을 한 번이라도 "발생시킨" 나라 vs 고객이 존재하는 나라
-- 1) 교집합: INTERSECT
-- 2) 차집합: 고객은 있지만 주문은 한 번도 없는 나라
-- 엔진 주의: MySQL은 INTERSECT/EXCEPT 미지원. 그럴 땐 IN/NOT IN/EXISTS로 변환.
-----------------------------------------------------------------------
-- 1) 교집합
-- TODO (INTERSECT 버전):
-- SELECT Country FROM Customers
-- INTERSECT
-- SELECT /* 주문 있는 나라 */ FROM ... ;

-- 2) 차집합
-- TODO (EXCEPT 버전):
-- SELECT Country FROM Customers
-- EXCEPT
-- SELECT /* 주문 있는 나라 */ FROM ... ;

-- 힌트용 서브쿼리 아이디어:
-- 주문 있는 나라 집합은 보통
-- SELECT DISTINCT c.Country
-- FROM Customers c
-- JOIN Orders o ON o.CustomerID = c.CustomerID;

-- 변환(HACK) 예시: MySQL일 때 교집합
-- SELECT DISTINCT c.Country
-- FROM Customers c
-- WHERE EXISTS (
--   SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
-- );

-- 변환(HACK) 예시: MySQL일 때 차집합
-- SELECT DISTINCT c.Country
-- FROM Customers c
-- WHERE NOT EXISTS (
--   SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
-- );
