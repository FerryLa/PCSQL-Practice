USE practice_db;

-- 샘플 데이터
CREATE TABLE categories (id INT PRIMARY KEY, category_name TEXT);
CREATE TABLE products3  (id INT PRIMARY KEY, product_name TEXT, price INT, category_id INT);
CREATE TABLE orders3    (id INT PRIMARY KEY, product_id INT, quantity INT);

INSERT INTO categories
VALUES (1, 'Peripheral'),
       (2, 'Storage');

INSERT INTO products3
VALUES (1, 'Keyboard', 50, 1),
       (2, 'Mouse',    25, 1),
       (3, 'SSD',     120, 2);

INSERT INTO orders3
VALUES (10, 1, 2),   -- 키보드 2개
       (11, 2, 1),   -- 마우스 1개
       (12, 3, 3);   -- SSD 3개

-- 문제:
-- 각 주문에 대해 상품명, 카테고리명, 총액(price * quantity)을 표시하세요.
-- 예시 컬럼: product_name, category_name, total_price
-- 🔹 작성 공간:
    SELECT p.product_name 상품명, c.category_name 카테고리명, (p.price * quantity) 총액
    FROM orders3 o
    JOIN products3 p on o.product_id = p.id
    JOIN categories c on p.category_id = c.id


-- ⌛경과 시간: 10:00
-- 🛑오답 이유: ORDER BY o.id를 넣어주면 더 좋고, 세미콜론도 붙여주자.
