USE TEST_DB;

CREATE TABLE Employees
(employee_id int PRIMARY KEY,
name varchar(50),
department varchar(50),
hire_date date);

CREATE TABLE Departments
(department_id int PRIMARY KEY,
department varchar(50));

CREATE TABLE Sales
(sale_id int PRIMARY KEY,
employee_id int FOREIGN KEY references Employees(employee_id),
sale_date date,
amount decimal(20, 5));

CREATE TABLE Performance_Reviews
(review_id int PRIMARY KEY,
employee_id int FOREIGN KEY references Employees(employee_id),
review_date date,
score int);

INSERT INTO Employees values
(1, 'A', 'Web', DATEFROMPARTS(1970, 01, 01)),
(2, 'B', 'Android', DATEFROMPARTS(1970, 01, 01)),
(3, 'C', 'AIML', DATEFROMPARTS(1970, 01, 01)),
(4, 'D', 'Web', DATEFROMPARTS(1970, 01, 01)),
(5, 'E', 'Android', DATEFROMPARTS(1970, 01, 01)),
(6, 'F', 'Web', DATEFROMPARTS(1970, 01, 01)),
(7, 'G', 'Web', DATEFROMPARTS(1970, 01, 01));

INSERT INTO Departments values
(1, 'Web'),
(2, 'Android'),
(3, 'AIML');

INSERT INTO Sales values
(1, 1, DATEFROMPARTS(1980, 01, 01), 1000),
(2, 1, DATEFROMPARTS(1981, 01, 01), 2000),
(3, 2, DATEFROMPARTS(1982, 01, 01), 3000),
(4, 3, DATEFROMPARTS(1983, 01, 01), 4000),
(5, 4, DATEFROMPARTS(1984, 01, 01), 5000),
(6, 5, DATEFROMPARTS(1985, 01, 01), 500),
(7, 6, DATEFROMPARTS(1986, 01, 01), 1000);


INSERT INTO Performance_Reviews values
(1, 1, DATEFROMPARTS(1990, 01, 01), 10),
(2, 1, DATEFROMPARTS(1991, 01, 01), 20),
(3, 2, DATEFROMPARTS(1992, 01, 01), 30),
(4, 3, DATEFROMPARTS(1993, 01, 01), 40),
(5, 4, DATEFROMPARTS(1994, 01, 01), 50),
(6, 5, DATEFROMPARTS(1995, 01, 01), 50),
(7, 6, DATEFROMPARTS(1996, 01, 01), 100),
(8, 7, DATEFROMPARTS(1997, 01, 01), 100);



-- Query 1
WITH Total_Sales AS 
	(SELECT e.employee_id, SUM(amount) AS sum_amount
	FROM Sales s
	JOIN Employees e
	ON s.employee_id = e.employee_id
	GROUP BY e.employee_id
)
SELECT 
	t.employee_id,
	e.name,
	sum_amount,
	RANK() OVER(ORDER BY sum_amount DESC) AS rank_salary
FROM Total_Sales t
JOIN Employees e
ON t.employee_id = e.employee_id;



-- Query 2
WITH AvgDept_Score AS 
	(SELECT department, e.employee_id, AVG(score) as avg_score
	FROM Performance_Reviews pr
	JOIN Employees e
	ON pr.employee_id = e.employee_id
	GROUP BY e.department, e.employee_id
)
SELECT 
	department,
	employee_id,
	avg_score,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY avg_score DESC) as rank_avg_score
FROM AvgDept_Score;



-- Query 3
WITH TotalDept_Sales AS
	(SELECT e.department, SUM(amount) as sum_sales
	FROM Sales s
	JOIN Employees e
	ON s.employee_id = e.employee_id
	JOIN Departments d
	ON e.department = d.department
	GROUP BY e.department, e.employee_id
),
TotalDept_Sales_Ranked AS
	(SELECT 
		department,
		sum_sales,
		ROW_NUMBER() OVER(PARTITION BY department ORDER BY sum_sales DESC) as row_num
	FROM TotalDept_Sales
)
SELECT department, sum_sales, row_num
FROM TotalDept_Sales_Ranked
WHERE row_num <= 3;



-- Query 4
WITH TotalDept_Sales AS
	(SELECT e.department, e.employee_id, SUM(amount) as sum_sales
	FROM Sales s
	JOIN Employees e
	ON s.employee_id = e.employee_id
	JOIN Departments d
	ON e.department = d.department
	GROUP BY e.department, e.employee_id
),
TotalDept_Sales_Ranked AS
	(SELECT 
		department,
		employee_id,
		sum_sales,
		ROW_NUMBER() OVER(PARTITION BY department ORDER BY sum_sales DESC) as row_num
	FROM TotalDept_Sales
)
SELECT e.name, tr.department, sum_sales, score
FROM TotalDept_Sales_Ranked tr
JOIN Performance_Reviews pr
ON tr.employee_id = pr.employee_id AND tr.sum_sales > 0
JOIN Employees e
ON tr.employee_id = e.employee_id
WHERE row_num = 1
ORDER BY department DESC, score DESC;
