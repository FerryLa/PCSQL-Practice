(MySQL)과제: EMPLOYEE와 DEPARTMENT 테이블을 이용해,
각 부서(dept_id)별 최고 급여를 받는 직원의 이름과 급여를 조회하라.
동일 부서에서 최고 급여를 받는 사람이 여러 명이면 모두 출력한다.

-- Title: Top Earners per Department (학습용)
-- Difficulty: MEDIUM
-- Link: https://example.local/sql/learn-top-earner-per-dept

-- Schema hint:
--   DEPARTMENT(
--     dept_id INT,
--     dept_name VARCHAR(100)
--   )
--
--   EMPLOYEE(
--     emp_id INT,
--     emp_name VARCHAR(100),
--     dept_id INT,
--     salary INT
--   )

-- Sample rows:
--   INSERT INTO DEPARTMENT VALUES
--     (1,'IT'),
--     (2,'HR'),
--     (3,'Sales');
--
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',1,9000),
--     (2,'Bob',1,9000),
--     (3,'Carol',1,8500),
--     (4,'Dave',2,7000),
--     (5,'Eve',2,6800),
--     (6,'Frank',3,9500);

-- 요구사항:
--   출력 컬럼:
--     dept_name,
--     emp_name,
--     salary
--
--   정렬:
--     dept_name 오름차순,
--     salary 내림차순,
--     emp_name 오름차순


-- 한줄 요약: 부서별 최고 급여 조회, 동일 부서 최고 급여 사람 여러 명이면 출력

SELECT d.dept_name AS dept_name, MAX(e.salary) max_salary
FROM EMPLOYEE e
LEFT JOIN DEPARTMENT d ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY e.salary DESC, d.dept_id;

-- 차근차근 1단계 묶기
SELECT dept_id, MAX(salary)
FROM EMPLOYEE
GROUP BY dept_id;

-- 묶은 것을 JOIN 서브쿼리에 넣어 m으로 지정
SELECT d.dept_name dept_name, e.emp_name emp_name, e.salary salary
FROM EMPLOYEE e
JOIN (
    SELECT dept_id, MAX(salary) AS max_salary
    FROM EMPLOYEE
    GROUP BY dept_id
) m
    ON e.dept_id = m.dept_id
    AND e.salary = m.max_salary
JOIN DEPARTMENT d ON e.dept_id = d.dept_id
ORDER BY dept_name ASC, salary DESC, emp_name ASC;


- [답지]
-- -- 방법 예시: 집계 서브쿼리 + JOIN 또는 윈도 함수(DENSE_RANK) 활용
-- SELECT ...
-- FROM ...
-- JOIN ...
--   ON ...
-- [WHERE ...]
-- ORDER BY ...;

-- ⌛ 경과 시간: 15분 초과
-- 🛑 오답 이유: 차근차근 서브쿼리를 사용 전에 만들어보자
-- 📜 복기 : 해당 내용은 "그룹별 최대/최소 값을 가진 행 찾기"
