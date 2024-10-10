USE SAMPLE_DB;

CREATE TABLE Product
(Pid int primary key,
Pname varchar(50) unique,
Price numeric(20, 1) check (Price > 0));

INSERT INTO Product values(1, 'Mobile', 40000), (2, 'AC', 30000), (3, 'TV', 120000), (4, 'Laptop', 150000), (5, 'Oven', 50000);

SELECT *
FROM Products;

WITH Avg_price AS (
SELECT AVG(Price) AS price
FROM Product
), Min_price AS (
SELECT Min(Price) AS price
FROM Product
), Max_price AS (
SELECT MAX(Price) AS price
FROM Product
)
SELECT p.*, 
CASE WHEN p.price > a.price THEN CASE WHEN p.price = ma.price THEN 'Highest' ELSE 'Costly' END
WHEN p.price = a.price THEN 'Average'
ELSE CASE WHEN p.price = mi.price THEN 'Lowest' ELSE 'Cheap' END
END AS price_remark
FROM Product p
JOIN Avg_price a ON 1 = 1
JOIN Min_price mi ON 1 = 1
JOIN Max_price ma ON 1 = 1;

CREATE VIEW CostlyProductsView AS
SELECT *
FROM Product
WHERE price > 60000;

SELECT *
FROM CostlyProductsView;

INSERT INTO Product values(110, 'c', 10);

SELECT *
FROM CostlyProductsView;

SELECT *
FROM Product;

SELECT *
FROM sys.views;

INSERT INTO CostlyProductsView values(656540, 'Z', 1);

SELECT *
FROM CostlyProductsView;

SELECT *
FROM Product;

DELETE FROM Product
WHERE Pid = 20;

SELECT *
FROM CostlyProductsView;