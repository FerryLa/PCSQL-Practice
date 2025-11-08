(MySQL)과제: EMPLOYEE에서 manager_id가 NULL이 아닌 직원 수를 부서별로 세어(department 기준) count와 함께 부서명 오름차순 출력

-- Title: Count Employees With Managers By Department (워밍업)
-- Difficulty: EASY
-- Link: https://example.local/sql/warmup-3
-- Schema hint:
--   EMPLOYEE(id INT, name VARCHAR(100), salary INT, department VARCHAR(100), manager_id INT NULL)
-- Sample rows:
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',9000,'IT',NULL),(2,'Bob',7000,'IT',1),(3,'Carol',7200,'IT',1),
--     (4,'Dave',6500,'HR',NULL),(5,'Eve',6100,'HR',4);


SELECT department, COUNT(*)
FROM employee
WHERE manager_id IS NOT NULL
GROUP BY department
ORDER BY department ASC;



- [답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- ORDER BY ...;

-- ⌛경과 시간:
-- 🛑오답 이유:
-- 📜복기 :
