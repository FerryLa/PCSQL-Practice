(MySQL)과제: OrderDetails에서 누적 판매수량이 1000개 이상인 상품만 모아
popular_products 테이블을 새로 만들어라 (상품ID와 총수량)

SELECT od.ProductID, SUM(od.QUantity) INTO popular_products (ProductID, total_qty)
FROM OrderDetails od
GROUP BY Quantity
HAVING SUM(od.Quantity) >= 1000;


-- 답지 / 주석처리
-- CREATE TABLE popular_products AS
-- SELECT od.ProductID,
-- SUM(od.Quantity) AS total_qty
-- FROM OrderDetails od
-- GROUP BY od.ProductID
-- HAVING SUM(od.Quantity) >= 1000;

-- ⌛경과 시간:
-- 🛑오답 이유: MySQL에서는 CREATE TABLE을 사용
-- 📜복기 : 누적 판매 수량은 SUM(od.Qunatity)

-- =====================================================================

(MySQL)과제: Products에서 단종(Discontinued=1)된 상품만 골라
archived_products 테이블을 새로 만들어라.
컬럼은 ProductID, ProductName, UnitPrice 만 포함

SELECT ProductID, ProductName, UnitPrice
INTO archived_products (ProductID, ProductName, UnitPrice)
FROM Products
WHERE Discontinued = 1


-- 답지 / 주석처리
-- CREATE TABLE archived_products AS
-- SELECT p.ProductID,
-- p.ProductName,
-- p.UnitPrice
-- FROM Products p
-- WHERE p.Discontinued = 1;

-- ⌛경과 시간:
-- 🛑오답 이유: 이것도 같은 이유르 MySQL에서는 CREATE TABLE ... AS 사용
-- 📜복기 : SELECT에 넣고 싶은 컬럼을 넣으면 됨, 어렵지 않다. 그냥 외우기


-- =====================================================================

(MySQL)과제: Categories 테이블에 새 카테고리 한 건을 추가해라.
이름은 'SEASONAL', 설명은 'Seasonal specials'

INSERT INTO Categories (CategoryName, Description)
VALUES ('SEASONAL', 'Seasonal specials');


-- 답지 / 주석처리
-- INSERT INTO Categories (CategoryName, Description)
-- VALUES ('SEASONAL', 'Seasonal specials');

-- ⌛경과 시간:
-- 🛑오답 이유: O
-- 📜복기 : INSERT INTO ... VALUES / INSERT INTO에는 컬럼명, VALUES에는 ROW 값

-- =====================================================================

(MySQL)과제: 최근 30일 내 주문된 상품을 FeaturedProducts(ProductID, FeaturedDate)에 삽입하라
[들어가는 컬럼] ProductID, FeaturedDate

INSERT INTO FeaturedProducts (ProductID, FeaturedDate)
SELECT ProductID, FeaturedDate
WHERE FeaturedDate =< DATETIME
FROM Orders o

I don KNOW

-- <<답지 / 주석처리: 최종 정답 SQL을 여기에 주석으로만 넣기>>
-- INSERT INTO FeaturedProducts (ProductID, FeaturedDate)
-- SELECT DISTINCT od.ProductID, CURRENT_DATE()
-- FROM Orders o
-- JOIN OrderDetails od ON od.OrderID = o.OrderID
-- WHERE o.OrderDate >= CURRENT_DATE() - INTERVAL 30 DAY;

-- ⌛경과 시간:
-- 🛑오답 이유: 오해 몰랐는가? DISTINCT에 대한 이해 부족, JOIN문을 왜 넣어야하는가에 대한 지식 부족
-- 📜복기 : 테이블에 만들어서 넣어줄 때 ProductID는 정규화 관점에서 중복제거 해서 넣어주는 것이 올바른 것


INSERT INTO FeaturedProducts (ProductID, FeaturedDate)
SELECT DISTINCT od.ProductID, CURRENT_DATE()
FROM Orders o
JOIN OrderDetails od ON od.OrderID = o.OrderID
WHERE o.OrderDate >= CURRENT_DATE() - INTERVAL 30 DAY;

— ==================================================

(MySQL)과제: 단가 100 이상 상품을 PremiumProducts(ProductID, ProductName, UnitPrice)로 복사 삽입하라
[들어가는 컬럼] ProductID, ProductName, UnitPrice

INSERT INTO PremiumProducts(ProductID, ProductName, UnitPrice)
SELECT p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
WHERE p.UnitPrice >= 100;



-- <<답지 / 주석처리: 최종 정답 SQL을 여기에 주석으로만 넣기>>
-- INSERT INTO PremiumProducts (ProductID, ProductName, UnitPrice)
-- SELECT p.ProductID, p.ProductName, p.UnitPrice
-- FROM Products p
-- WHERE p.UnitPrice >= 100;

-- ⌛경과 시간: 5분
-- 🛑오답 이유: 정답
-- 📜복기 :


— ==================================================