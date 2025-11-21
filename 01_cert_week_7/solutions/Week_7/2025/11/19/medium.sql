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










- [답지]
-- SELECT ...
-- FROM ...
-- JOIN ...
-- [JOIN (또는 서브쿼리)로 category별 avg_price 붙이기]
-- WHERE ...
-- ORDER BY ...;

-- ⌛ 경과 시간:
-- 🛑 오답 이유:
-- 📜 복기 :
