CREATE TABLE EmployeeDetails (
EmpID INT PRIMARY KEY,
FullName VARCHAR(255),
ManagerID INT,
FOREIGN KEY (ManagerID) REFERENCES EmployeeDetails(EmpID)
);

INSERT INTO EmployeeDetails (EmpID, FullName, ManagerID) VALUES
(1, 'Alice Johnson', NULL),
(2, 'Bob Smith', 1),
(3, 'Charlie Reeds', 1),
(4, 'Diana Green', 2),
(5, 'Evan Strokes', 2),
(6, 'Fiona Cheng', 3),
(7, 'George Kimmel', 3), 
(8, 'Hannah Morse', 3),
(9, 'Ian DeVoe', 3),
(10, 'Jenny Hills', 3);


select * 
from EmployeeDetails;

-- 1) Write an SQL query to fetch all the Employees who are also managers from the EmployeeDetails table.

select *
from EmployeeDetails
where empid in (
select distinct managerid from EmployeeDetails where managerid is not null);

-- 2) Write an SQL query to fetch only odd rows from the table EmployeeDetails.
--   Remember it is not the EmpID but the row numbers!

INSERT INTO EmployeeDetails (EmpID, FullName, ManagerID) VALUES
(21, 'Alex Smith', 3);

select *
from (
select *, row_number() over (order by empid) as row_num
from EmployeeDetails
) orderemp
where row_num % 2 =1;

-- 3) Design a database schema for an e-commerce platform considering products, orders, customers, and payments. 
--    Provide the DDL to build the DB and tables.

-- Create database etaller:
create database etaller;

-- Create table products:
create table products (
	product_id int primary key,
	product_name varchar(255) not null,
	description text,
	price decimal(10,2) not null,
	stock int not null
);

-- Cratre table orders:
create table orders (
	order_id int primary_key,
	customer_id int,
	order_date date not null,
	status varchar(50),
	foreign key (customer_id) references customers(customer_id)
);

-- Create table orders_items:
create table order_items(
	order_item_id int primary key,
	order_id int,
	product_id int,
	quantity int not null,
	price decimal(10,2) not null,
	foreign key (order_id) references orders(order_id),
	foreign key (product_id) references orders(product_id)
):

-- Create tabñe customers:
create table customers (
	customer_id int primary key,
	customer_name varchar(255) not null,
	emai varchar(255) not null,
	phone_number varchar(30),
	address text
);

-- Create table payments:
create table payments(
	payment_id int primary key,
	order_id int,
	payment_date date not null,
	amount decimal(10,2),
	method varchar(50),
	foreign key (order_id) references orders(order_id)
);


-- 4) Rank the sales people by their aggregate sales while providing their name, position, salary and aggregate sales amount. 
--    There must also be the column rank in the select.

-- Creating the table for sales people
CREATE TABLE t_sales_person (
    sales_person_id INT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    salary INT
);


-- Creating the table for aggregate sales
CREATE TABLE t_aggregate_sales (
    sales_id INT PRIMARY KEY,
    month INT,
    amount DECIMAL(10, 2),
    sales_person_id INT,
    FOREIGN KEY (sales_person_id) REFERENCES t_sales_person(sales_person_id)
);


-- Inserting data into t_sales_person
INSERT INTO t_sales_person (sales_person_id, name, position, salary) VALUES
(1, 'Steve', 'Senior', 80000),
(2, 'Bill', 'Intermediate', 60000),
(3, 'Alan', 'Intermediate', 62000),
(4, 'Gordon', 'Junior', 30000),
(5, 'Robert', 'Junior', 25000);

-- Inserting data into t_aggregate_sales
INSERT INTO t_aggregate_sales (sales_id, month, amount, sales_person_id) VALUES
(1, 202312, 1000, 1),
(2, 202312, 5000, 2),
(3, 202312, 2000, 3),
(4, 202312, 100, 4),
(5, 202312, 2500, 5),
(6, 202401, 6500, 1),
(7, 202401, 8000, 2),
(8, 202401, 10000, 5),
(9, 202401, 100, 4),
(10, 202401, 300, 3);

select * from t_sales_person ;
select * from t_aggregate_sales ;

select 
	sp.name,
	sp.position,
	sp.salary,
	sum(gs.amount) as sales_amount,
	rank() over (order by sum(gs.amount) desc) as rank
from t_sales_person sp
join t_aggregate_sales gs
on sp.sales_person_id = gs.sales_person_id
group by sp.name,sp.position, sp.salary;


-- 5) Set up a data model that will allow for the tracking of the following.
-- * Students
-- * Teachers
-- * Attendance
-- * Assignments
-- * Grades
-- * Classes

- Students table:_
student_id int primary key,
name varchar(255) not null,
birth date not null,
gender varchar(10),
address text;

- Teachers table:
teacher_id int pŕimary key,
name varchar(255) not null,
subject varchar(50) not null,
hire_date date not null;

- Attendance table:
attendance_id int primary key,
student_id,
class_id,
attendance_date date not null,
status varchar(20),
foreign key (student_id) references students(student_id),
foreign key (class_id) references classes(class_id)

- Classes table:
class_id int primary_key,
class_name varchar(50) not null,
teacher_id int,
foreign key (teacher_id) references teachers(teacher_id)


- Assignments table:
assignment_id int primary key,
class_id int,
title varchar(255) not null,
due_date date,
foreign key (class_id) references classes(class_id)

- Grades table:
grade_id int primary key,
student_id int,
assigment_id int,
grade varchar(10),
foreign key (student_id) references students(student_id),
foreign key (assigment_id) references assigments(assigment_id)

-- &) The school wants to be able to track student performance over time and attempting to access the OLTP model above is causing performance issues. 
--    Please set up a warehouse model to compliment the OLTP model.

- Fact table for students
fact_students_performance
	student_id int,
	class_id int,
	assigment_id int,
	grade varchar(10),
	gpa decimal(3,2)

- Dimension table for students
dim_studnets
	students_id primary key,
	name varchar(255) not null,
	birth date not null,
	gender varchar(10),
	address text;

- Dimension table for classes
dim_classes
	class_id int primary_key,
	class_name varchar(50) not null,
	teacher_id int,
	foreign key (teacher_id) references teachers(teacher_id);

- Dimmension table for teachers
dim_teachers
	teacher_id int pŕimary key,
	name varchar(255) not null,
	subject varchar(50) not null,
	hire_date date not null;

- Dimension table to assignments
dim_assigments
	assignment_id int primary key,
	class_id int,
	title varchar(255) not null,
	due_date date,
	foreign key (class_id) references classes(class_id)

-- 7) Write a SQL query that produces that Output. Use the Name column and the first letter of the
--    Profession column, enclosed by parentheses.

select name + ' (' + left(profession, 1) + ')' as formatted_name
from Employee;

-- 8) Using PySpark, load a JSON file containing user data, transform it to calculate the total revenue
--   generated by each user, and store the result in a parquet file.

from pyspark.sql import SparkSession

# Initialize Session
spark = SparkSession.builder.appName('UserRevenue').getOrCreate()

# Load json file
df = spark.read.json("path/to/file/data.json")

# Calculate revenue 
user_revenue = df.groupBy("user_id").agg({"revenue": "sum"}).withColumnRenamed("sum(revenue", "total_revenue")

# Write result to parquet
user_revenue.write.parquet("path/to/file/user_revenue.parquet")
