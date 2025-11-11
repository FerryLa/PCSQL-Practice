(MySQL)과제: EMPLOYEE에서 각 상사(manager_id)별로 “자신보다 급여가 낮은 부하직원 수”를 구해 상사 이름과 그 수를 조회 (상사가 없는 직원 제외, 수 내림차순·이름 오름차순)

-- Title: Count of Direct Reports Paid Less (변형)
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/employees-earning-more-than-their-managers/

-- Schema hint:
-- EMPLOYEE(id INT, name VARCHAR(100), salary INT, manager_id INT NULL)
-- Sample rows:
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',9000,NULL);
-- INSERT INTO EMPLOYEE VALUES (2,'Bob',8000,1),(3,'Carol',7000,1),(4,'Dave',9500,2);

SELECT e2.name AS manager_name, COUNT(*)
FROM EMPLOYEE e
JOIN EMPLOYEE e2 ON e.manager_id = e2.id
WHERE e.manager_id NOT NULL
GROUP BY e.manager_id
HAVING e.salary > e2.salary
ORDER BY COUNT(*) DESC, name ASC;

[답지]
SELECT m.name AS manager_name, COUNT(*) AS num_reports
FROM EMPLOYEE e
JOIN EMPLOYEE m ON e.manager_id = m.id
WHERE e.salary < m.salary
GROUP BY m.id, m.name
ORDER BY num_reports DESC, manager_name ASC;


-- ⌛ 경과 시간: 10분 초과
-- 🛑 오답 이유: HAVING은 GROUP BY 후 집계해주는 것이라 WHERE 절이 올바름, 부분적으로 혼동 실수도 있음
-- 너무 꼬아 생각 e.manager_id = m.id WHERE e.salary < m.salary -- JOIN을 쓸 때 테이블과 테이블이 합해지는게 아니라. 조건에 맞게 테이블에 행이 붙여진다고 생각
-- 하지만 m.name이 중복될 수 있다면 m.id도 필요
-- 하지만 m.name이 중복될 수 있다면 m.id도 필요
-- 📜 복기 : GROUP BY 할 때 SELECT 절의 name이 집계함수가 아니라서 그룹화해준다.
-- 그래서 반대로 m.id를 해줄 필요는 없지 않나? 라고 생각할 수 있지만 이름이 중복될 수 있어서 m.id도 필요


SELECT m.name AS manager_name, COUNT(*) AS num_reports
FROM EMPLOYEE e
JOIN EMPLOYEE m ON e.manager_id = m.id
WHERE e.salary < m.salary
GROUP BY m.id, m.name
ORDER BY num_reports DESC, manager_name ASC;