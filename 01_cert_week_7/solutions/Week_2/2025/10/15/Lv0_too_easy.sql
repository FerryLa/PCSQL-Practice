/* =====================================================================
   쉬운 SQL 3문제 — 실행용 스크립트
   각 문제는 독립적으로 DROP/CREATE 하므로 따로 실행해도 무방함.
   작성 규칙(요청 포맷):
   - 예시 INSERT문
   - 문제 설명
   - 작성 공간(정답 SQL 작성)
   - (빈 줄 하나)
   - ⌛경과 시간:  (빈 값)
   - 🛑오답 이유:  (빈 값)
   ===================================================================== */


/* =========================
   문제 1: 20살 이상 학생 이름 조회
   ========================= */

-- 테이블 초기화
DROP TABLE IF EXISTS students;
CREATE TABLE students (
  id    INT PRIMARY KEY,
  name  VARCHAR(50),
  age   INT,
  grade VARCHAR(2)
);

-- 예시 INSERT문
INSERT INTO students (id, name, age, grade) VALUES
(1, 'Min', 19, 'B'),
(2, 'Ara', 20, 'A'),
(3, 'Jun', 22, 'C'),
(4, 'Hana', 21, 'B'),
(5, 'Leo', 18, 'A');

-- 문제 설명
-- 나이 20세 이상 학생의 name을 나이 오름차순으로 조회하라.
SELECT name
FROM students
WHERE age >= 20
ORDER BY age ASC;

-- 작성 공간
-- 여기에 정답 SQL을 작성하세요.
-- SELECT name FROM students WHERE age >= 20 ORDER BY age ASC;

-- ⌛경과 시간: 1:08
-- 🛑오답 이유:



/* =========================
   문제 2: 결제 완료 주문 건수
   ========================= */

-- 테이블 초기화
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id      INT PRIMARY KEY,
  user_id INT,
  amount  INT,
  status  VARCHAR(20)
);

-- 예시 INSERT문
INSERT INTO orders (id, user_id, amount, status) VALUES
(101, 1, 35000, 'PAID'),
(102, 2, 12000, 'CANCELED'),
(103, 1,  8000, 'PAID'),
(104, 3, 15000, 'PENDING'),
(105, 2, 22000, 'PAID');

-- 문제 설명
-- status = 'PAID' 인 주문의 총 건수를 1행으로 출력하라. 컬럼명은 자유.

-- 작성 공간
SELECT COUNT(*) 'status가 PAID인 주문'
FROM orders
WHERE status = 'PAID'
GROUP BY status
ORDER BY amount DESC LIMIT 1;
-- 여기에 정답 SQL을 작성하세요.
-- SELECT COUNT(*) AS paid_count FROM orders WHERE status = 'PAID';


-- ⌛경과 시간: 3:52
-- 🛑오답 이유: GROUP BY status라고 하면 상태값별로 행이 갈린다. 전체 행 수가 1행이라 굳이 필요없고 WHERE 절을 이용하면 된다.
-- COUNT(*)는 집계 함수라서 조건에 맞는 여러 행을 숫자 하나로 압축



/* =========================
   문제 3: 가장 비싼 책 한 권
   ========================= */

-- 테이블 초기화
DROP TABLE IF EXISTS books;
CREATE TABLE books (
  id    INT PRIMARY KEY,
  title VARCHAR(100),
  price INT
);

-- 예시 INSERT문
INSERT INTO books (id, title, price) VALUES
(1, 'SQL for Humans', 15000),
(2, 'Python Snack',   18000),
(3, 'C++ Lite',       22000),
(4, 'DB Basics',      12000);

-- 문제 설명
-- 가장 가격이 높은 책 한 권의 title, price를 1행으로 조회하라.
SELECT title, price
FROM books
ORDER BY price DESC LIMIT 1;

-- 작성 공간
-- 여기에 정답 SQL을 작성하세요.
-- SELECT title, price FROM books ORDER BY price DESC LIMIT 1;

-- ⌛경과 시간: 03:00
-- 🛑오답 이유:
