(MySQL)과제: 각 카테고리(category)별로 평균 상품 가격보다 비싼 상품만 조회하라.
단, 카테고리 이름과 상품 이름, 가격을 함께 보여주고,
카테고리 오름차순, 가격 내림차순, 상품 이름 오름차순으로 정렬하라.

-- Title: Products Priced Above Category Average (변형)
-- Difficulty: MEDIUM
-- Link: https://example.local/sql/products-above-category-avg

-- Schema hint:
--   CATEGORY(
--     category_id   INT PRIMARY KEY,
--     category_name VARCHAR(100)
--   )
--
--   PRODUCT(
--     product_id   INT PRIMARY KEY,
--     product_name VARCHAR(100),
--     category_id  INT,
--     price        INT
--   )
--
-- Sample rows:
--   INSERT INTO CATEGORY VALUES
--     (1,'Electronics'),
--     (2,'Books');
--
--   INSERT INTO PRODUCT VALUES
--     (1,'Laptop',1,1500000),
--     (2,'Mouse',1,30000),
--     (3,'Keyboard',1,80000),
--     (4,'Novel A',2,12000),
--     (5,'Novel B',2,18000),
--     (6,'Tech Book',2,35000);

-- 요구사항:
--   출력 컬럼:
--     category_name
--     product_name
--     price
--
--   조건:
--     - 각 category_id별 평균 가격보다 비싼 상품만 조회
--
--   정렬:
--     category_name 오름차순
--     price 내림차순
--     product_name 오름차순

- [풀이]
-- 한줄 요약: 카테고리별 평균 가격보다 비싼 상품 조회 (카테고리 이름 ASC, 상품이름 ASC, 가격 DESC)
WITH exp AS (
    SELECT category_id, AVG(price) AS avg_price
    FROM PRODUCT
    GROUP BY category_id
)
SELECT c.category_name, p.product_name, p.price
FROM CATEGORY c
JOIN PRODUCT p
    ON c.category_id = p.category_id
GROUP BY p.category_id
HAVING p.price > exp.avg_price
ORDER BY c.category_name ASC, p.product_name ASC, p.price DESC;

-- 🛑 오답 이유: CTE도 JOIN하지 않고 사용, GROUP BY 구조적 틀림

- [2차 풀이]

WITH exp AS (
    SELECT category_id, AVG(price) AS avg_price
    FROM PRODUCT
    GROUP BY category_id
)
SELECT
FROM CATEGORY c
JOIN PRODUCT p ON c.category_id = p.category_id
JOIN exp ON c.category_id, exp.category_id
WHERE exp.avg_price < p.price
ORDER BY c.category_name ASC, p.price DESC, p.product_name ASC;

- [3차 풀이]
WITH exp AS (
    SELECT category_id, AVG(price) AS avg_price
    FROM PRODUCT
    GROUP BY category_id
)
SELECT c.category_name, p.price, p.product_name
FROM CATEGORY c
JOIN PRODUCT p ON c.category_id = p.category_id
JOIN exp e ON c.category_id, e.category_id
WHERE e.avg_price < p.price
ORDER BY c.category_name ASC, p.price DESC, p.product_name ASC;


-- ⌛ 경과 시간: 15:04
-- 🛑 오답 이유: CTE도 JOIN하지 않고 사용, GROUP BY 구조적 틀림()
-- 📜 복기 : 실수가 잦다. 5단 풀이법을 통해  마지막 NULL 체크하면서 문법오류 체크(; , . =)

-- 한줄 요약: 카테고리별 평균 가격보다 비싼 상품 조회 (카테고리 이름 ASC, 상품이름 ASC, 가격 DESC)
WITH AVERAGE AS(
    SELECT category_id, AVG(price) AS price
    FROM PRODUCT
    GROUP BY category_id
)
SELECT c.category_name, p.product_name, p.price -- 출력 요구사항 ORDER BY는 정렬순서
FROM CATEGORY c
JOIN PRODUCT p ON c.category_id = p.category_id -- 1:N
JOIN AVERAGE a ON c.category_id = a.category_id -- 1:1 (AVERAGE --- CATEGORY -|--|< PRODUCT )
WHERE a.price < p.price
ORDER BY c.category_name ASC, p.price DESC, p.product_name ASC;

