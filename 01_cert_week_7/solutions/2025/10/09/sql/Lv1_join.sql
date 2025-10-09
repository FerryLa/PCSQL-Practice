USE practice_db;

-- [문제 1] INNER JOIN
CREATE TABLE customers
(
    id   INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE orders
(
    id           INT PRIMARY KEY,
    customer_id  INT,
    product_name VARCHAR(50)
);

INSERT INTO customers
VALUES (1, 'Alice'),
       (2, 'Bob'),
       (3, 'Charlie');
INSERT INTO orders
VALUES (101, 1, 'Keyboard'),
       (102, 1, 'Mouse'),
       (103, 2, 'Monitor');

-- 문제:
-- 각 고객의 이름과 주문한 상품명을 출력하세요.
-- (주문이 없는 고객은 표시하지 않습니다.)
-- 예시 컬럼: name, product_name
-- 🔹 작성 공간:
-- SELECT ...

SHOW TABLE STATUS;

SELECT name, product_name
FROM customers a
         INNER JOIN orders o on a.id = o.customer_id;
# 2분 16초

-- ==================================================

-- [문제 2] LEFT JOIN
CREATE TABLE employees
(
    id            INT PRIMARY KEY,
    name          VARCHAR(50),
    department_id INT
);
CREATE TABLE departments
(
    id        INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO employees
VALUES (1, 'Jane', 1),
       (2, 'Tom', 2),
       (3, 'Lisa', NULL);
INSERT INTO departments
VALUES (1, 'HR'),
       (2, 'Sales'),
       (3, 'IT');

-- 문제:
-- 모든 직원의 이름과 부서 이름을 출력하세요.
-- 부서가 없는 직원도 포함해야 합니다.
-- 예시 컬럼: name, dept_name
-- 🔹 작성 공간:

SELECT a.name, d.dept_name
FROM employees a
         LEFT JOIN departments d on department_id = d.id;
# 경과 시간: 딱 5분
# 오답 이유:

-- ==================================================

-- [문제 3] RIGHT JOIN
CREATE TABLE students
(
    id       INT PRIMARY KEY,
    name     VARCHAR(50),
    class_id INT
);
CREATE TABLE classes
(
    id         INT PRIMARY KEY,
    class_name VARCHAR(50)
);

INSERT INTO students
VALUES (1, 'Amy', 1),
       (2, 'Ben', 2);
INSERT INTO classes
VALUES (1, 'Math'),
       (2, 'Science'),
       (3, 'History');

-- 문제:
-- 모든 반의 이름과 그 반에 속한 학생 이름을 출력하세요.
-- 학생이 없는 반도 포함해야 합니다.
-- 예시 컬럼: class_name, student_name
-- 🔹 작성 공간:
SELECT class_name, name student_name
FROM students s
         RIGHT JOIN classes c on s.id = c.id;
-- 경과 시간:
-- 오답 이유:

-- ==================================================

-- [문제 4] FULL OUTER JOIN
CREATE TABLE users
(
    id       INT PRIMARY KEY,
    username VARCHAR(50)
);
CREATE TABLE logins
(
    user_id    INT,
    login_date DATE
);

INSERT INTO users
VALUES (1, 'Alpha'),
       (2, 'Beta'),
       (3, 'Gamma');
INSERT INTO logins
VALUES (1, '2025-01-02'),
       (4, '2025-01-03');

-- 문제:
-- 사용자 이름과 로그인 날짜를 모두 표시하세요.
-- 로그인하지 않은 사용자와 계정이 없는 로그인 기록 모두 포함해야 합니다.
-- 예시 컬럼: username, login_date
-- 🔹 작성 공간:
SELECT
    u.username,
    l.login_date
FROM users AS u
    FULL OUTER JOIN logins AS l
ON l.user_id = u.id
ORDER BY u.username NULLS LAST, l.login_date;
-- 경과 시간:
-- 오답 이유:


-- ==================================================

-- [문제 5] SELF JOIN
CREATE TABLE employees_self
(
    id         INT PRIMARY KEY,
    name       VARCHAR(50),
    manager_id INT
);

INSERT INTO employees_self
VALUES (1, 'CEO', NULL),
       (2, 'Alice', 1),
       (3, 'Bob', 1),
       (4, 'Carol', 2);

-- 문제:
-- 각 직원의 이름과 그 직원의 상사 이름을 함께 표시하세요.
-- 예시 컬럼: employee_name, manager_name
-- 🔹 작성 공간:
SELECT e.name employee_name, e2.name manager_name
FROM employees_self e
LEFT JOIN employees_self e2 on e.id = e2.manager_id;
-- 경과 시간:
-- 오답 이유:

-- [문제 6] MULTI JOIN
CREATE TABLE customers2
(
    id   INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE products
(
    id           INT PRIMARY KEY,
    product_name VARCHAR(50),
    price        INT
);
CREATE TABLE orders2
(
    id          INT PRIMARY KEY,
    customer_id INT,
    product_id  INT
);

INSERT INTO customers2
VALUES (1, 'Anna'),
       (2, 'Brian');
INSERT INTO products
VALUES (1, 'Keyboard', 50),
       (2, 'Mouse', 25);
INSERT INTO orders2
VALUES (10, 1, 1),
       (11, 2, 2);

-- 문제:
-- 각 주문에 대해 고객 이름, 상품 이름, 가격을 함께 표시하세요.
-- 예시 컬럼: customer_name, product_name, price
-- 🔹 작성 공간:
SELECT c.name customer_name, p.product_name, p.price
FROM orders2 o
         JOIN customers2 AS c ON c.id = o.customer_id
         JOIN products   AS p ON p.id = o.product_id
ORDER BY o.id
-- ⌛경과 시간:
-- 🛑오답 이유: 멀티 조인은 JOIN을 두 개쓰고 ORDER BY를 써주는 것이 좋다.
