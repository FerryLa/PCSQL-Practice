/*
[w3schools] WHERE, ORDER BY, AND LIKE, NOT, OR, NOT IN
*/

SELECT *
FROM Customers
WHERE Country = 'Mexico';

SELECT *
FROM Products
ORDER BY Price;

-- <Q> Select all customers from Spain that starts with the letter 'G':
SELECT *
FROM Customers
WHERE Country = 'Spain'
  AND CustomerName LIKE 'G%';

SELECT *
FROM Customers
WHERE Country = 'Germany'
   OR Country = 'Spain';

SELECT *
FROM Customers
WHERE City NOT IN ('Paris', 'London');


/*
[w3schools] INSERT INTO, UPDATE SET, DELETE FROM
  */

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway'),
       ('Greasy Burger', 'Per Olsen', 'Gateveien 15', 'Sandnes', '4306', 'Norway'),
       ('Tasty Tee', 'Finn Egan', 'Streetroad 19B', 'Liverpool', 'L1 0AA', 'UK');

UPDATE Customers
SET ContactName='Juan';

DELETE
FROM Customers;

/*
[w3schools] null value
  */

SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NULL;


/*
[w3schools] TOP, LIMIT
  */

SELECT TOP 3 *
FROM Customers;

-- MySQL Syntax:
SELECT column_name(s)
FROM table_name
WHERE condition LIMIT 3;


-- MS Access Syntax: Access는 퍼센트도 가능
SELECT TOP number column_name(s)
FROM table_name
WHERE condition;

SELECT TOP 10 PERCENT column_name(s)
FROM table_name
WHERE condition
ORDER BY some_column;

-- Oracle 12 Syntax: FETCH FIRST
SELECT column_name(s)
FROM table_name
ORDER BY column_name(s)
    FETCH FIRST number ROWS ONLY;

SELECT *
FROM Customers
    FETCH FIRST 3 ROWS ONLY;