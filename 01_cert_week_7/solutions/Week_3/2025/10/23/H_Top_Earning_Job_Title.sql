(MySQL)과제: 각 직무(title)별로 평균 급여(salary)가 가장 높은 직무와 그 평균 급여를 구하라
-- Title: Top Earning Job Title
-- Difficulty: MEDIUM
-- Link: https://leetcode.com/problems/employee-earnings-by-title/

-- Schema hint: EMPLOYEE(id INT, name VARCHAR(100), salary INT, title VARCHAR(50))
-- Sample rows:
-- INSERT INTO EMPLOYEE VALUES (1,'Alice',6000,'Engineer');
-- INSERT INTO EMPLOYEE VALUES (2,'Bob',7000,'Manager');
-- INSERT INTO EMPLOYEE VALUES (3,'Carol',7200,'Manager');

SELECT title, AVG(salary) as salary_avg
FROM employee
GROUP BY title
ORDER BY salary_avg DESC LIMIT 1;

[답지]
-- SELECT ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;

-- ⌛경과 시간: 01:46
-- 🛑오답 이유: LIMIT 1로 뽑으면 동률이 있으면 일부만 나와서 불안정
-- 📜복기 : WITH로 동률까지 챙기기 위한 쿼리문을 작성

WITH title_avg AS (
    SELECT title, AVG(salary) AS avg_salary
    FROM EMPLOYEE
    GROUP BY title
),
max_avg AS (
    SELECT MAX(avg_salary) AS top_avg FROM title_avg
)
SELECT ta.title, ta.avg_salary
FROM title_avg ta
JOIN max_avg m ON ta.avg_salary = m.top_avg
ORDER BY ta.title;