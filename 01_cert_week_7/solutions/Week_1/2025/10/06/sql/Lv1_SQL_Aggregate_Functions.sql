/* Aggregate_Functions */

SELECT Min(Price)
FROM Products;

SELECT MAX(Price)
FROM Products;

SELECT COUNT(*)
FROM Products
WHERE Price = 18;

SELECT OrderID, SUM(Quantity) AS Total_Quantity
FROM OrderDetails
GROUP BY OrderID;

SELECT ROUND(AVG(Price), 2) AS AveragePrice, CategoryID
FROM Products
GROUP BY CategoryID;