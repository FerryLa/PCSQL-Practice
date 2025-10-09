/* Week_1/problemY.sql
   PCSQL: 5 Problems (Step-by-step difficulty)
   Covered topics: SELECT, DISTINCT, WHERE, ORDER BY, AND/OR/NOT, NULL,
                   BETWEEN, IN, LIKE, Aggregate (COUNT/SUM/AVG/MIN/MAX),
                   INSERT INTO, UPDATE, DELETE, JOIN (INNER/LEFT), SELF JOIN, ALIASES
*/

/* -----------------------------------------------------------
   0) Reset & Setup (idempotent)
------------------------------------------------------------ */
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
                             dept_id   INT PRIMARY KEY,
                             dept_name VARCHAR(50)
);

CREATE TABLE employees (
                           emp_id      INT PRIMARY KEY,
                           emp_name    VARCHAR(50) NOT NULL,
                           dept_id     INT,
                           salary      INT,              -- monthly
                           phone       VARCHAR(20),      -- can be NULL
                           manager_id  INT,              -- self reference
                           hired_at    DATE,
                           FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE orders (
                        order_id  INT PRIMARY KEY,
                        emp_id    INT,
                        amount    INT,
                        ordered_at DATE,
                        FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO departments (dept_id, dept_name) VALUES
                                                 (10,'Sales'),(20,'R&D'),(30,'HR'),(40,'Support');

INSERT INTO employees (emp_id, emp_name, dept_id, salary, phone, manager_id, hired_at) VALUES
                                                                                           (1, 'Kim',   10, 420, '010-1111-1111', NULL, '2024-01-03'),
                                                                                           (2, 'Lee',   10, 380, NULL,            1,    '2024-02-10'),
                                                                                           (3, 'Park',  20, 510, '010-3333-3333', 1,    '2024-03-12'),
                                                                                           (4, 'Choi',  20, 470, NULL,            3,    '2024-04-01'),
                                                                                           (5, 'Han',   30, 360, '010-5555-5555', 1,    '2024-05-22'),
                                                                                           (6, 'Kang',  40, 390, '010-6666-6666', 1,    '2024-02-01');

INSERT INTO orders (order_id, emp_id, amount, ordered_at) VALUES
                                                              (101, 1, 1200, '2024-06-01'),
                                                              (102, 2,  800, '2024-06-03'),
                                                              (103, 3, 1600, '2024-06-05'),
                                                              (104, 3,  900, '2024-06-08'),
                                                              (105, 4, 1100, '2024-06-10'),
                                                              (106, 2,  300, '2024-06-11'),
                                                              (107, 6,  700, '2024-06-12');

/* -----------------------------------------------------------
   Problem 1) SELECT / DISTINCT / WHERE / ORDER BY
   Q: 전화번호가 등록된(전화번호 NOT NULL) 직원의 이름을 오름차순으로 조회하라.
      컬럼: emp_name
------------------------------------------------------------ */
-- [YOUR QUERY]
    SELECT DISTINCT emp_name
    FROM employees
    WHERE phone IS NOT NULL
    ORDER BY emp_name ASC

-- [SOLUTION]
-- SELECT emp_name
-- FROM employees
-- WHERE phone IS NOT NULL
-- ORDER BY emp_name ASC;
-- 마지막에 세미콜론;


/* -----------------------------------------------------------
   Problem 2) Aggregates (COUNT, MIN, MAX, AVG) + ALIAS
   Q: 전체 직원 수, 급여 최솟값, 최댓값, 평균을 구하고 각 컬럼에 별칭을 부여하라.
      컬럼: total_cnt, min_salary, max_salary, avg_salary
------------------------------------------------------------ */
-- [YOUR QUERY]
SELECT COUNT(emp_id) '직원 수', MIN(salary) '급여 최솟값', MAX(salary) '최댓값', AVG(salary) '평균'
FROM employees

-- [SOLUTION]
-- SELECT
--   COUNT(*)      AS total_cnt,
--   MIN(salary)   AS min_salary,
--   MAX(salary)   AS max_salary,
--   AVG(salary)   AS avg_salary
-- FROM employees;
-- COUNT에 * 붙이기 / 마지막에 또 세미콜론(;) 안 붙임

/* -----------------------------------------------------------
   Problem 3) LIKE / BETWEEN / IN / NULL
   Q: 이름이 'K'로 시작하고 급여가 380 이상 500 이하(BETWEEN)이며
      전화번호가 NULL인 직원의 id와 이름을 조회하라.
      컬럼: emp_id, emp_name
------------------------------------------------------------ */
-- [YOUR QUERY]
SELECT emp_id 'id', emp_name '이름'
FROM employees
WHERE emp_name = 'K%'
  AND salary = 380 BETWEEN 500
    AND phone IS NULL;

-- [SOLUTION]
-- SELECT emp_id, emp_name
-- FROM employees
-- WHERE emp_name LIKE 'K%'
--   AND salary BETWEEN 380 AND 500
--   AND phone IS NULL;
-- 오답: BETWEEN 380 AND 500

/* -----------------------------------------------------------
   Problem 4) INNER JOIN / IN / ORDER BY
   Q: Sales 또는 R&D 부서(IN) 소속 직원의 이름과 부서명을 조회하고
      급여 내림차순으로 정렬하라.
      컬럼: emp_name, dept_name
------------------------------------------------------------ */
-- [YOUR QUERY]

-- [SOLUTION]
-- SELECT e.emp_name, d.dept_name
-- FROM employees e
-- INNER JOIN departments d ON e.dept_id = d.dept_id
-- WHERE d.dept_name IN ('Sales','R&D')
-- ORDER BY e.salary DESC;


/* -----------------------------------------------------------
   Problem 5) SELF JOIN (+ LEFT JOIN 변형)
   Q: 직원과 그 직원의 매니저 이름을 나란히 조회하라.
      매니저가 없는 직원도 포함(LEFT JOIN)한다.
      컬럼: emp_name, manager_name
------------------------------------------------------------ */
-- [YOUR QUERY]
SELECT * FROM employees

SELECT e.emp_name AS emp_name,
       (SELECT e.emp_name
        FROM employees
        WHERE e.emp_id = s.manager_id) AS manager_name
FROM employees e
LEFT JOIN employees s on e.emp_id = s.manager_id;

-- [SOLUTION]
-- SELECT e.emp_name,
--        m.emp_name AS manager_name
-- FROM employees e
-- LEFT JOIN employees m
--   ON e.manager_id = m.emp_id
-- ORDER BY e.emp_id;


/* -----------------------------------------------------------
   (Optional practice) UPDATE / DELETE / INSERT INTO
   - 아래는 학습용 예시. 주석 해제 후 실행하면 데이터가 바뀜.
------------------------------------------------------------ */
-- 1) INSERT: Support 부서에 새 직원 추가
INSERT INTO employees (emp_id, emp_name, dept_id, salary, phone, manager_id, hired_at)
VALUES (7,'You',40,410,NULL,1,'2024-06-30');

-- 2) UPDATE: 새 직원의 전화번호 등록
UPDATE employees SET phone = '010-7777-7777' WHERE emp_id = 7;

-- 3) DELETE: 테스트로 추가한 직원을 삭제
DELETE FROM employees WHERE emp_id = 7;
