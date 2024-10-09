CREATE TABLE Employee
(eid int primary key,
ename varchar(20),
salary int,
gender char(1));

DROP TABLE Employee;

SELECT name
FROM sys.databases;

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employee';

INSERT INTO Employee values
(1, 'Shivam', 40000, 'M'),
(2, 'Eren', 20000, 'M'),
(3, 'Mikasa', 60000, 'F'),
(4, 'Levi', 100000, 'M')
;

SELECT *
FROM Employee;

