(MySQL)과제: 부서별 최신 급여 기준으로, 부서 평균보다 더 많이 받는 직원 조회하기

-- Title: Employees Above Latest Department Average
-- Difficulty: MEDIUM ~ HARD (실전 대비용)
-- Link: https://example.local/sql/latest-dept-avg

-- 배경
-- 어떤 회사의 급여 내역을 관리하는 테이블이 다음과 같이 있다.

-- 1) 부서 정보
--   DEPARTMENT(
--     dept_id   INT PRIMARY KEY,
--     dept_name VARCHAR(100)
--   )

-- 2) 직원 기본 정보
--   EMPLOYEE(
--     emp_id    INT PRIMARY KEY,
--     emp_name  VARCHAR(100),
--     dept_id   INT            -- FK → DEPARTMENT.dept_id
--   )

-- 3) 급여 변경 이력
--   SALARY_HISTORY(
--     emp_id      INT,         -- FK → EMPLOYEE.emp_id
--     change_date DATE,        -- 급여가 변경된 날짜
--     salary      INT          -- 해당 시점의 연봉(만원 단위라고 가정)
--   )
--   -- 한 직원은 SALARY_HISTORY에 여러 행을 가질 수 있음
--   -- 가장 최근 change_date가 "현재 급여"를 의미함

-- Sample rows:
--   INSERT INTO DEPARTMENT VALUES
--     (1,'IT'),
--     (2,'HR'),
--     (3,'Sales');
--
--   INSERT INTO EMPLOYEE VALUES
--     (1,'Alice',1),
--     (2,'Bob',1),
--     (3,'Carol',1),
--     (4,'Dave',2),
--     (5,'Eve',3);
--
--   INSERT INTO SALARY_HISTORY VALUES
--     -- IT 부서
--     (1,'2024-01-01',7000),
--     (1,'2024-07-01',9000),   -- Alice 최신 급여: 9000
--     (2,'2024-01-01',6500),
--     (2,'2024-06-01',8000),   -- Bob 최신 급여: 8000
--     (3,'2024-03-01',7500),   -- Carol 최신 급여: 7500
--     -- HR 부서
--     (4,'2024-02-01',6800),   -- Dave 최신 급여: 6800
--     -- Sales 부서
--     (5,'2024-01-15',9500);   -- Eve 최신 급여: 9500

-- 요구사항:

-- 1) 각 직원의 "최신 급여"만 사용해야 한다.
--    - 즉, SALARY_HISTORY에서 emp_id별로 가장 최근 change_date를 가진 행의 salary가 현재 급여.
--
-- 2) 각 부서별로 "최신 급여" 기준 평균 급여(dept_avg)를 구한다.
--
-- 3) 그 부서 평균(dept_avg)보다 "엄 strict하게 더 높은" 급여를 받는 직원만 출력한다.
--
-- 4) 출력 컬럼:
--    - dept_name
--    - emp_name
--    - latest_salary
--    - dept_avg
--
-- 5) 정렬 기준:
--    - dept_name 오름차순
--    - latest_salary 내림차순
--    - emp_name 오름차순

-- 한 줄 요약:
--   "최신 급여 이력만 기준으로 부서별 평균을 구하고,
--    그 평균보다 많이 받는 직원 목록을 부서명까지 붙여서 출력하라."










- [답지]

-- 힌트 스텝 (네가 채워 넣을 자리):

-- 1) 각 직원의 최신 급여를 구하는 서브쿼리 또는 CTE 작성
--    (emp_id별 MAX(change_date)를 이용)

-- 2) 그 결과를 EMPLOYEE, DEPARTMENT와 조인해
--    (dept_id, dept_name, emp_name, latest_salary)를 가진 중간 결과 만들기

-- 3) 그 중간 결과를 다시 GROUP BY dept_id 해서 부서별 평균 급여(dept_avg)를 구하고,
--    원본과 JOIN하거나 서브쿼리로 비교

-- 4) WHERE 또는 HAVING에서 latest_salary > dept_avg 조건 적용

-- 5) ORDER BY dept_name ASC, latest_salary DESC, emp_name ASC


-- 예시 골격(참고용, 직접 채워 넣으세요)
-- WITH latest_salary AS (
--   SELECT
--     ...
--   FROM SALARY_HISTORY sh
--   JOIN (
--     SELECT emp_id, MAX(change_date) AS max_date
--     FROM SALARY_HISTORY
--     GROUP BY emp_id
--   ) mx ON ...
-- )
-- SELECT
--   ...
-- FROM latest_salary ls
-- JOIN EMPLOYEE e ON ...
-- JOIN DEPARTMENT d ON ...
-- [JOIN 또는 서브쿼리로 dept_avg 붙이기]
-- WHERE ...
-- ORDER BY ...;


-- ⌛ 경과 시간:
-- 🛑 오답 이유:
-- 📜 복기 :

