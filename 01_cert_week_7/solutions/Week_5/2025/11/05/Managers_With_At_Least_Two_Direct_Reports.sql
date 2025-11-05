(MySQL)과제: EMPLOYEE 테이블에서 ‘직접 부하 직원’이 2명 이상인 상사의 id와 이름을 조회하라
-- Title: Managers With At Least Two Direct Reports (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/managers-with-at-least-five-direct-reports/
-- Schema hint:
--   EMPLOYEE(id INT, name VARCHAR(100), salary INT, manager_id INT NULL)
-- Sample rows:
--   INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,NULL),(2,'Bob',7000,1),(3,'Carol',7500,1);
--   INSERT INTO EMPLOYEE VALUES (4,'Dave',7200,2),(5,'Eve',6900,2),(6,'Frank',7100,3);


SELECT e.id, e.name
FROM employee e
WHERE e.id IN (
SELECT COUNT(manager_id) as cnt_mi
FROM employee c
GROUP BY manager_id
HAVING cnt_mi >= 2
)
ORDER BY e.id;




[답지]
-- SELECT e.id, e.name
-- FROM EMPLOYEE e
-- JOIN (
--   SELECT manager_id
--   FROM EMPLOYEE
--   WHERE manager_id IS NOT NULL
--   GROUP BY manager_id
--   HAVING COUNT(*) >= 2
-- ) m
--   ON m.manager_id = e.id
-- ORDER BY e.id;
-- ⌛ 경과 시간: 약 7분
-- 🛑 오답 이유: 테이블의 개념을 잘 몰랐음
-- 📜 복기 : 서브쿼리를 사용할 때 논리적 판단이 중요함
-- [중요 3가지 핵심]
-- JOIN → 더 읽기 쉽고, 다른 정보랑 결합할 때 유리
-- IN → 한 테이블 내에서 “이 값이 저 서브쿼리 결과 안에 있나?” 검사할 때 간단
-- COUNT(*)는 조건 판단용이지, 비교 대상 ID는 아님

-- WHERE절 이용
SELECT e.id, e.name
FROM employee e
WHERE e.id IN (
SELECT manager_id
FROM employee
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING COUNT(*) >= 2
)
ORDER BY e.id;

-- JOIN문 이용 << 이게 적절
SELECT e.id, e.name
FROM employee e
JOIN (
SELECT manager_id
FROM employee
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING COUNT(*) >= 2
) m
ON e.id = m.manager_id
ORDER BY e.id;

