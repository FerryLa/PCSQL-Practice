(MySQL)과제: EMPLOYEE 테이블에서 부하 직원(subordinate)이 한 명도 없는 상사의 이름과 ID를 조회하라

-- Title: Managers Without Subordinates (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/managers-without-subordinates/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, manager_id INT NULL)
-- Sample rows:
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,NULL),(2,'Bob',7000,1),(3,'Carol',7500,1);
-- INSERT INTO EMPLOYEE VALUES (4,'Dave',8200,2),(5,'Eve',6900,2),(6,'Frank',7200,3);

[답지]
-- SELECT e.id, e.name
-- FROM EMPLOYEE e
-- WHERE e.id NOT IN (
-- SELECT DISTINCT manager_id
-- FROM EMPLOYEE
-- WHERE manager_id IS NOT NULL
-- )
-- ORDER BY e.id;

-- ⌛ 경과 시간: --
-- 🛑 오답 이유: --
-- 📜 복기 : 풀이만 적기
-- 서브쿼리를 통한 WHERE _ NOT IN절 / IS NOT NULL로 1번 id 행의 NULL 행 제거

SELECT id, name
FROM employee e
WHERE e.id NOT IN (
SELECT DISTINCT manager_id
FROM employee m
WHERE manager_id IS NOT NULL
)
ORDER BY e.id;