CREATE DATABASE TEST_DB;

USE TEST_DB;

CREATE TABLE t_product_master
(Product_ID varchar(5) PRIMARY KEY,
Product_Name varchar(40),
Cost_Per_Item int);


CREATE TABLE t_user_master
(User_ID varchar(5) PRIMARY KEY,
User_Name varchar(40));


CREATE TABLE t_transaction
(User_ID varchar(5) references t_user_master(User_ID),
Product_ID varchar(5) references t_product_master(Product_ID),
Transaction_Date date,
Transaction_Type varchar(10),
Transaction_Amount int);

INSERT INTO t_product_master values
('P1', 'Pen', 10),
('P2', 'Scale', 15),
('P3', 'Note Book', 25);

INSERT INTO t_user_master values
('U1', 'Alfred Lawrence'),
('U2', 'William Paul'),
('U3', 'Edward Philip');

INSERT INTO t_transaction values
('U1', 'P1', DATEFROMPARTS(2010,10,25), 'Order', 150),
('U1', 'P1', DATEFROMPARTS(2010,11,20), 'Payment', 750),
('U1', 'P1', DATEFROMPARTS(2010,11,20), 'Order', 200),
('U1', 'P3', DATEFROMPARTS(2010,11,25), 'Order', 50),
('U3', 'P2', DATEFROMPARTS(2010,11,26), 'Order', 100),
('U2', 'P1', DATEFROMPARTS(2010,12,15), 'Order', 75),
('U3', 'P2', DATEFROMPARTS(2011,01,15), 'Payment', 250);

SELECT * FROM
t_product_master;

SELECT * FROM
t_user_master;

SELECT * FROM
t_transaction;

SELECT 
	User_Name, 
	Product_Name, 
	SUM(IIF(Transaction_Type = 'Order', Transaction_Amount, 0)) AS Order_Quantity,
	SUM(IIF(Transaction_Type = 'Payment', Transaction_Amount, 0)) AS Amount_Paid,
	MAX(Transaction_Date) AS Last_Transaction_Date,
	SUM(IIF(Transaction_Type = 'Order', Transaction_Amount * Cost_Per_Item, 0)) - SUM(IIF(Transaction_Type = 'Payment', Transaction_Amount, 0)) AS Balance
FROM t_transaction t3
JOIN t_user_master t2
ON t3.User_ID = t2.User_ID
JOIN t_product_master t1
ON t3.Product_ID = t1.Product_ID
GROUP BY User_Name, Product_Name;
