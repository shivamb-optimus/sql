USE SAMPLE_DB;

SELECT *
FROM Employee;

SELECT TOP 70 PERCENT *
FROM Employee
ORDER BY ename DESC;

SELECT COUNT(*) as total_count
FROM Employee;

SELECT SUM(salary * 5)
FROM Employee;

SELECT SUM(salary) / COUNT(*)
FROM Employee;

SELECT *
FROM Employee
WHERE salary >= (SELECT AVG(salary) FROM Employee);

SELECT eid, ename, e1.salary, gender
FROM Employee e1
JOIN (SELECT AVG(salary) as salary FROM Employee) as e2
ON e1.salary >= e2.salary;

SELECT *
FROM Employee
WHERE ename LIKE '[mlv]';

SELECT * 
FROM Employee
WHERE ename LIKE 'a__%';

--This is a comment

SELECT * FROM Employee;

SELECT eid, ename,
CASE WHEN salary > avg_salary THEN 'Above average'
WHEN salary = avg_salary THEN 'Average'
ELSE 'Below average'
END AS salary_remark
FROM Employee,
(SELECT AVG(salary) AS avg_salary FROM Employee) AS avg_table;

SELECT COUNT(DISTINCT gender) 
FROM Employee;

INSERT INTO Employee values(6, 'Annie', 55000, 'F');

--SELECT * FROM Student3;

--ALTER TABLE Student3
--ALTER COLUMN marks NUMERIC(19, 1);

--INSERT INTO Student3 values(1, 'Harron', 'India', 40);

EXEC sp_rename 'Student3', 'StudentGUI';