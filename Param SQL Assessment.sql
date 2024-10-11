-- 1st ques 

use [TutorialDB]

Create Table t_product_master(
      Product_ID char(2) primary key,
	  Product_Name Varchar(50),
	  Cost_Per_Item int );

go 


Create Table t_user_master(
          UserID char(2) primary key,
		  UserName varchar(50));
		  
go 


Create Table t_transactin (
      UserID char(2),
	  Product_ID char(2),
	  Transaction_Date Date,
	  Transaction_Type Varchar(50),
	  Transaction_Amount int,
	  Foreign key (UserID) references t_user_master(UserID),
	  Foreign key (Product_ID) references t_product_master(Product_ID)
	  );
go


Insert Into t_product_master values 
		( 'P1', 'Pen' , 10),
		('P2', 'Scale', 15),
		('P3', 'NoteBook', 25);

go


Insert Into t_user_master values 
		('U1', 'Alfred Lawrence'),
		('U2', 'William Paul'),
		('U3', 'Edward Fillip');

go

Insert Into t_transactin values 
		('U1','P1', '10-25-2010','Order', 150),
		('U1','P1', '11-20-2010','Payment',750),
		('U1','P1', '11-20-2010','Order', 200),
     	('U1','P3', '11-25-2010','Order', 50),
		('U3','P2', '11-26-2010','Order',100),
		('U2','P1', '12-15-2010','Order', 75),
     	('U3','P2', '01-15-2011','Payment',250);
go

Select * from t_user_master;
Select * from t_product_master;
Select * from t_transactin;


Drop table t_transactin;

go 



Select UserName, Product_Name,
        Sum(IIF (Transaction_Type = 'Order', Transaction_Amount, 0))As Ordered_Quantiy,
		Sum(IIF (Transaction_Type = 'Payment', Transaction_Amount, 0)) As Amount_Paid,
		Max (Transaction_Date) as Last_Transaction_Date,
		Sum(IIF(Transaction_Type = 'Order', Transaction_Amount * Cost_Per_Item, 0)) - Sum(IIF (Transaction_Type = 'Payment', Transaction_Amount, 0))as Balance
       
	     FROM t_transactin as t3 
		 join t_user_master as t2 on t3.UserID = t2.UserID
		 join t_product_master as t1 on t3.Product_ID = t1.Product_ID
		 Group By UserName, Product_Name
go 




--2nd ques 



use [TutorialDB]

Create table employees(
     employee_id int primary key,
	 name varchar(50),
	 department varchar(50),
	 hire_date date
	 );


Create table departments(
       department_id int primary key,
	   department_name varchar(50),
	   );

Create table sales(
     sale_id int primary key,
	 employee_id int,
	 sale_date date,
	 amount decimal,
	 Foreign key (employee_id) references employees(employee_id),

	 );

Create table performance_reviews(
       review_id int primary key,
	   employee_id int,
	   review_date date,
	   score int,
	   Foreign key (employee_id) references employees(employee_id),

	   );
go 


Insert Into departments values 
       ( 1, 'IT'),
	   (2, 'CSE'),
	   (3,'ECE');
go 


Insert Into sales values 
        (1, 1,'11/10/2022', 15000.85),
		(2, 2,'11/20/2021',12000.52),
		(3, 3,'11/14/2020',1000.01),
		(4, 4,'11/16/2019',5000.25);

go 


Insert Into performance_reviews values
        (1, 1,'11/10/2022',4),
		(2, 2,'11/20/2021',2),
		(3, 3,'11/14/2020',1),
		(4, 4,'11/16/2019',5);

go 

Insert Into employees values 
        (1, 'Param', 'IT', '11/10/2015'),
		(2, 'Vaibhav', 'CSE', '11/20/2015'),
		(3, 'Gaurav', 'CSE', '11/14/2015'),
		(4, 'Vishal', 'ECE', '11/16/2015');

go 



Select * from sales;
Select * from employees;
Select * from departments;
Select * from performance_reviews;

go 


--- 1st Part 
 SELECT
	 ep.employee_id,
     ep.name,
	 Sum(sl.amount) as salesAmount,
     RANK() OVER (ORDER BY  Sum(sl.amount) DESC) AS Rank
    FROM 
        employees  as ep
	JOIN sales as sl on ep.employee_id = sl.employee_id

Group by ep.employee_id, ep.name

ORDER BY 
    salesAmount, Rank;
go 


-- 2nd Part 

 SELECT
	 ep.employee_id,
     ep.name,
	 ep.department,
	 AVG(pf.score) as review_score,
     DENSE_RANK() OVER (PARTITION BY ep.department ORDER BY  AVG(pf.score)) AS Rank
    FROM 
        employees  as ep
	JOIN performance_reviews as pf on ep.employee_id = pf.employee_id

Group by ep.employee_id, ep.name, ep.department

ORDER BY 
    review_score, Rank;
go 


-- 3rd Part

    SELECT * from(
	select
        ep.employee_id,
		ep.name,
		ep.department,
	    Sum(sl.amount) as salesAmount,
     
        ROW_NUMBER() OVER (PARTITION BY ep.department ORDER BY Sum(sl.amount) DESC) AS Rank

    FROM 
        employees as ep 
		join sales as sl on sl.employee_id = ep.employee_id

	
	Group by 
	    ep.employee_id,
		ep.name,
		ep.department
		) as final_table where rank <=3;
	
     
go 


-- 4th ques 

    SELECT * from(
	select
        ep.employee_id,
		ep.name,
		ep.department,
		pf.score,
	    Sum(sl.amount) as salesAmount,
     
        ROW_NUMBER() OVER (PARTITION BY ep.department ORDER BY Sum(sl.amount) DESC) AS Rank

    FROM 
        employees as ep 
		join sales as sl on sl.employee_id = ep.employee_id
		join performance_reviews as pf on pf.employee_id = ep.employee_id

	
	Group by 
	    ep.employee_id,
		ep.name,
		ep.department,
		pf.score
		) as final_table where rank <=1;
	
     
go 

















     

