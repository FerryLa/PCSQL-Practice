(MySQL)과제: EMPLOYEE 테이블에서 각 부서(department_id)별 평균 급여(avg_salary)를 구하고,
평균 급여가 8000 이상인 부서의 department_id와 avg_salary를 조회하라.
결과는 avg_salary 내림차순, department_id 오름차순으로 정렬하라.

-- Title: Departments With High Average Salary (변형)
-- Difficulty: MEDIUM
-- Link: https://example.local/sql/high-avg-salary-dept

-- Schema hint:
--   EMPLOYEE(id INT, name VARCHAR(100), salary INT, department_id INT)
-- Sample rows:
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',9000,1),
--     (2,'Bob',8200,1),
--     (3,'Carol',7500,1),
--     (4,'Dave',7000,2),
--     (5,'Eve',8100,2),
--     (6,'Frank',9100,3);

SELECT department_id, avg_salary
FROM EMPLOYEE e
WHERE (department_id, salary) IN
(
SELECT AVG(salary) avg_salary
FROM EMPLOYEE
GROUP BY department_id
) >= 8000
ORDER BY avg_salary DESC, department_id ASC;


- [답지]
SELECT department_id,
       AVG(salary) AS avg_salary
FROM EMPLOYEE
GROUP BY department_id
HAVING  /* 여기 조건 */
ORDER BY avg_salary DESC, department_id ASC;


-- ⌛ 경과 시간: 05:28
-- 🛑 오답 이유:
-- 📜 복기 :

SELECT department_id, AVG(salary) avg_salary
FROM EMPLOYEE
GROUP BY department_id
HAVING AVG(salary) >= 8000
ORDER BY avg_salary DESC, department_id ASC;