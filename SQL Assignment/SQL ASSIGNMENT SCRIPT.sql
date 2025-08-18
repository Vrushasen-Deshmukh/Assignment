CREATE DATABASE NEWGEN_ASSIGNMENTS;
USE NEWGEN_ASSIGNMENTS;

/*
-- PART B 
-- PRACTICAL QUESTIONS
-- BASIC QUERIES
*/

-- Q.41] Create a table 'Customers' with columns: CustomerID, Name, City, Country. Add appropriate constraints.

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    City VARCHAR(50),
    Country VARCHAR(50) NOT NULL
);

SELECT * FROM Customers;

-- Q.42] Insert 5 sample rows into Customers.
INSERT INTO
Customers (CustomerID, Name, City, Country)
VALUES
	(1, 'Arjun', 'Mumbai', 'India'),
    (2, 'Anita', 'Delhi', 'India'),
    (3, 'John', 'New York', 'USA'),
    (4, 'Karan', 'Bangalore', 'India'),
    (5, 'Megan', 'London', 'UK');

-- Q.43] Write a query to fetch all customers from India.
SELECT * FROM Customers
WHERE Country = 'India';


-- Q.44] Write a query to fetch customers whose name starts with 'A'.
SELECT * FROM Customers
WHERE Name LIKE 'A%';


-- Q.43] Write a query to fetch customers whose name ends with 'n'.
SELECT * FROM Customers
WHERE Name LIKE '%n';


-- AGGREGATIONS --

-- Q.46] Write a query to find the total number of customers in each country.
SELECT Country, COUNT(*) AS Total_Customers
FROM Customers
GROUP BY Country;

-- Q.47] Write a query to find the highest and lowest CustomerID.
SELECT MAX(CustomerID) AS Highest_ID,
	   MIN(CustomerID) AS Lowest_ID
FROM Customers;

-- Q.48] Write a query to count how many customers are from each city.
SELECT City, COUNT(*) AS Total_Customers
FROM Customers
GROUP BY City;



-- JOINS --

-- Q.49] Create another table 'Orders' with columns: OrderID, CustomerID, OrderDate, Amount.
CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount Decimal(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

SELECT * FROM Orders;

-- Q.50] Insert 5–6 sample orders for different customers.
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount)
VALUES
	(101, 1, '2025-08-01', 2500.00),
    (102, 2, '2025-08-05', 1800.50),
    (103, 3, '2025-08-07', 3200.75),
    (104, 1, '2025-08-10', 1500.00),
    (105, 4, '2025-08-12', 2700.00),
    (106, 5, '2025-08-15', 3000.00);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount)
VALUES
	(107, 1, '2025-08-18', 7000.00),
	(108, 2, '2025-08-23', 9000.50),
    (109, 2, '2025-08-27', 5700.75),
    (110, 1, '2025-08-30', 1500.00);

SELECT * FROM Orders;

-- Q.51] Write an INNER JOIN to fetch orders along with customer names.
SELECT O.OrderID, O.OrderDate, O.Amount, C.Name AS Customer_Name
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID;

-- Q.52] Write a LEFT JOIN to fetch all customers and their orders.
SELECT C.Name, C.City, O.OrderID, O.Amount
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID;

-- Q.53] Write a RIGHT JOIN to fetch all orders with customer details.
SELECT O.OrderID, O.Amount, C.Name, C.Country
FROM Customers C
RIGHT JOIN Orders O ON C.CustomerID = O.CustomerID;

-- Q.54] Write a SELF JOIN on Customers to find customers from the same city.
SELECT C1.Name AS Customer1, C2.Name AS Customer2, C1.City
FROM Customers C1
JOIN Customers C2
  ON C1.City = C2.City AND C1.CustomerID < C2.CustomerID;


-- ADVANCED QUERIES --

-- Q.55] Write a query to find the second highest order amount.
SELECT Amount
FROM Orders
ORDER BY Amount DESC
LIMIT 1 OFFSET 1;

-- Q.56] Write a query to rank customers based on total spending.
-- Unsolved

-- Q.57] Write a query to get the first and last order date for each customer.
SELECT C.CustomerID, C.Name,
	   MIN(O.OrderDate) AS First_Order_Date,
       MAX(O.OrderDate) AS Last_Order_Date
FROM Customers C
JOIN Orders O on C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name;

-- Q.58] Write a query to calculate the running total of order amounts.
SELECT OrderID, OrderDate, Amount,
SUM(Amount) OVER (ORDER BY OrderDate) AS Running_Total
FROM Orders;

-- Q.59] Write a query to find customers who placed more than 2 orders.
SELECT CustomerID, COUNT(OrderID) AS Total_Orders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 2;

-- Q.60] Write a query to display customers who never placed an order.
SELECT CustomerID, COUNT(OrderID) AS Total_Orders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) = 0;



-- SUBQUERIES AND CTES -- 

-- Q.61] Write a query to fetch customers whose total order amount is greater than the average order amount.
SELECT C.CustomerID, C.Name, SUM(O.Amount) AS Total_Amount_Spent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name
HAVING SUM(O.Amount) > (SELECT AVG(AMOUNT) FROM Orders);

-- Q.62] Write a correlated subquery to fetch customers who placed orders worth more than 500.
SELECT C.CustomerID, C.Name
FROM Customers C
WHERE (SELECT SUM(O.AMOUNT)
       FROM Orders O
       WHERE O.CustomerID = C.CustomerID) > 500;
       
-- Q.63] Use a CTE to calculate each customer's total order amount and rank them.
-- Unsolved


-- SET OPERATIONS -- 
-- Q.64] Create another table VIP_Customers with a list of special customers.
CREATE TABLE VIP_Customers
(
	VIP_CustomerID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    City VARCHAR(50),
    Country VARCHAR(50) NOT NULL
);
SELECT * FROM VIP_CUSTOMERS;

ALTER TABLE VIP_Customers
RENAME COLUMN Name TO VIP_Name;

INSERT INTO VIP_Customers (VIP_CustomerID, VIP_Name, City, Country)
VALUES
	(1, 'John', 'Mumbai', 'India'),
	(2, 'Alice', 'Delhi', 'India'),
    (3, 'Bob', 'New York', 'USA');
    

-- Q.65] Write a query to get all customers from both Customers and VIP_Customers using UNION.
SELECT CustomerID, Name, City, Country
FROM Customers
UNION
SELECT VIP_CustomerID, VIP_Name, City, Country
FROM VIP_Customers;

-- Q.66] Write a query to get customers present in both tables (INTERSECT equivalent).
SELECT C.Name
FROM Customers C
INNER JOIN VIP_Customers VC
ON C.Name = VC.VIP_Name;
    
-- Q.67] Write a query to get customers in Customers but not in VIP_Customers.
SELECT Name
FROM Customers
WHERE Name NOT IN (SELECT VIP_Name FROM VIP_Customers);

    
-- INDEXES AND OPTIMIZATION --

-- Q.68] Create an index on CustomerID in Orders.
CREATE INDEX idx_customerid
ON Orders (CustomerID);
    
-- Q.69] Check the query execution plan for a JOIN query with and without the index.
-- Unsolved


-- TRANSACTIONS --

-- Q.70] Begin a transaction, insert a record, rollback, and verify if it is saved.
START TRANSACTION;
INSERT INTO Customers (CustomerID, Name, City, Country)
VALUES
	(106, 'Ravi', 'Pune', 'India');
ROLLBACK;
SELECT * FROM Customers WHERE CustomerID = 106;

-- Q.71] Begin a transaction, insert a record, commit, and verify if it is saved.
START TRANSACTION;
INSERT INTO Customers (CustomerID, Name, City, Country)
VALUES 
	(7, 'Suresh', 'Chennai', 'India');
SELECT * FROM Customers;
COMMIT;
SELECT * FROM Customers WHERE CustomerID = 7;


-- NULL HANDLING -- 

-- Q.72] Write a query to replace NULL amounts in Orders with 0.
SET SQL_SAFE_UPDATES = 0;
UPDATE Orders
SET Amount = 0
WHERE Amount IS NULL;

-- Q.73] Write a query to count orders where Amount is NULL.
SELECT COUNT(*) AS Null_Amount_Orders
FROM Orders
WHERE AMOUNT IS NULL;


-- DATE FUNCTIONS --

-- Q.74] Write a query to fetch orders placed in the last 30 days.
SELECT * FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

-- Q.75] Write a query to fetch orders placed in January 2024.
SELECT * FROM Orders
WHERE OrderDate BETWEEN '01-01-2024' AND '31-01-2024';


-- STRING FUNCTIONS --

-- Q.76] Write a query to convert all customer names to UPPERCASE.
UPDATE Customers
SET Name = UPPER(Name);
SELECT * FROM Customers;

-- Q.77] Write a query to extract the first 3 letters of customer names.
SELECT Name, LEFT(Name, 3) AS First_3_Letters
FROM Customers;

-- Q.78] Write a query to concatenate Name and City with a comma.
SELECT CustomerID, CONCAT(Name, ', ', City) AS Name_City
FROM Customers;


-- MISCELLANEOUS --

-- Q.79] Delete all customers from a specific city.
DELETE FROM Orders
WHERE CustomerID IN (SELECT CustomerID
					 FROM Customers
                     WHERE City = 'Delhi');

SELECT * FROM Orders;

DELETE FROM Customers
WHERE City = 'Delhi';

SELECT * FROM Customers;

-- Q.80] Drop the VIP_Customers table.
DROP TABLE VIP_Customers;
SELECT * FROM VIP_Customers;


/*
-- PART C
-- SIMPLE SCENARIO-BASED SQL QUESTIONS
*/

-- SCENARIO 1
-- EMPLOYEE DATABASE
-- Creating 'Employees' table :-
CREATE TABLE Employees
(
	emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    joining_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Employees (emp_id, emp_name, dept_id, salary, joining_date) VALUES
(101, 'Alice', 1, 60000, '2022-01-15'),
(102, 'Bob', 2, 45000, '2021-03-20'),
(103, 'Charlie', 3, 70000, '2020-07-10'),
(104, 'David', 1, 55000, '2023-02-05'),
(105, 'Eva', 4, 48000, '2022-11-25'),
(106, 'Frank', 5, 52000, '2021-06-30'),
(107, 'Grace', 6, 40000, '2020-09-12'),
(108, 'Helen', 7, 75000, '2023-04-18'),
(109, 'Ian', 8, 42000, '2021-12-03'),
(110, 'Jack', 9, 58000, '2019-05-27');

SELECT * FROM Employees;

-- Creating 'Departments' table :-
CREATE TABLE Departments
(
	dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    location VARCHAR(100)
);

INSERT INTO Departments (dept_id, dept_name, location) VALUES
(1, 'IT', 'Mumbai'),
(2, 'HR', 'Delhi'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Chennai'),
(5, 'Sales', 'Hyderabad'),
(6, 'Admin', 'Pune'),
(7, 'R&D', 'Noida'),
(8, 'Support', 'Kolkata'),
(9, 'Operations', 'Jaipur'),
(10, 'Legal', 'Ahmedabad');

SELECT * FROM Departments;

-- Q.1] Write a query to fetch all employees working in the IT department.
SELECT E.emp_id, E.emp_name, E.salary, E.joining_date, D.dept_name, E.dept_id
FROM Employees AS E
JOIN Departments AS D
	 ON D.dept_id = E.dept_id
WHERE D.dept_name = 'IT';

-- Q.2] Write a query to fetch the top 3 highest-paid employees in the company.
SELECT emp_id, emp_name, salary, dept_id, joining_date
FROM Employees
ORDER BY salary DESC
LIMIT 3;

-- Q.3] Find the total salary paid to employees in each department.
SELECT D.dept_name,
	   SUM(E.salary) AS Total_Salary
FROM Employees AS E
JOIN Departments AS D
	 ON E.dept_id = D.dept_id
GROUP BY D.dept_name;

-- Q.4] List departments where the average salary is greater than 50,000.
SELECT D.dept_name, ROUND(AVG(E.salary),2) AS Average_Salary
FROM Employees AS E
JOIN Departments AS D
	 ON E.dept_id = D.dept_id
GROUP BY D.dept_name
HAVING AVG(E.salary) > 50000;

-- Q.5] Find employees who joined in the year 2023.
SELECT emp_id, emp_name, dept_id, salary, joining_date
FROM Employees
WHERE MONTH(joining_date) = 2023;

-- Q.6] Fetch employees whose salary is above the company’s average salary.
SELECT emp_id, emp_name, dept_id, salary
FROM Employees
WHERE salary > (SELECT ROUND(AVG(salary),2) AS Average_Salary
				FROM Employees);

-- Q.7] List employees who do not belong to any department.
SELECT emp_id, emp_name, dept_id, salary, joining_date
FROM Employees
WHERE dept_id IS NULL;


-- SCENARIO 2
-- E-COMMERCE ORDERS
-- Creating 'Customerss' table :-
CREATE TABLE Customerss
(
	customers_id INT PRIMARY KEY,
    customers_name VARCHAR(100),
    city VARCHAR(100)
);

INSERT INTO Customerss (customers_id, customers_name, city)
VALUES
	(1, 'Amit', 'Delhi'),
	(2, 'Neha', 'Delhi'),
	(3, 'Raj', 'Pune'),
	(4, 'Priya', 'Pune'),
	(5, 'Suresh', 'Mumbai'),
	(6, 'Anita', 'Mumbai'),
	(7, 'Vikram', 'Mumbai'),
	(8, 'Rohit', 'Mumbai'),
	(9, 'Kavita', 'Delhi'),
	(10, 'Arjun', 'Pune');
    
SELECT * FROM Customerss;

-- Creating 'Orderss' table :-
CREATE TABLE Orderss
(
	orders_id INT PRIMARY KEY,
    customers_id INT,
    orders_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customers_id) REFERENCES Customerss(customers_id)
);
    
INSERT INTO Orderss (orders_id, customers_id, orders_date, amount)
VALUES
(101, 1, '2024-07-10', 2500.00),
(102, 2, '2024-07-01', 1800.00),
(103, 3, '2024-06-15', 2200.00),
(104, 4, '2024-06-01', 1500.00),
(105, 5, '2024-07-20', 3200.00),
(106, 6, '2024-07-05', 2750.00),
(107, 7, '2024-06-25', 4100.00),
(108, 8, '2024-05-30', 1900.00),
(109, 5, '2024-04-15', 3000.00),
(110, 6, '2024-03-20', 2600.00);

SELECT * FROM Orderss;    

-- Q.8] List all orders placed by customers from Mumbai.    
SELECT O.orders_id, O.customers_id, C.customers_name, C.city, O.orders_date, O.amount
FROM Orderss AS O
JOIN Customerss AS C
	 ON O.customers_id = C.customers_id
WHERE C.city = 'Mumbai';
    
-- Q.9] Find the total amount spent by each customer.
SELECT C.customers_id, C.customers_name, SUM(O.amount) AS total_spent
FROM Customerss AS C
LEFT JOIN Orderss AS O
	      ON C.customers_id = O.customers_id
GROUP BY C.customers_id, C.customers_name;

-- Q.10] Find customers who have not placed any orders.
SELECT C.customers_id, C.customers_name, C.city
FROM Customerss AS C
LEFT JOIN Orderss AS O 
		  ON C.customers_id = O.customers_id
WHERE O.Orders_id IS NULL;

-- Q.11] List the top 2 customers based on total spending.
SELECT C.Customers_id, C.customers_name, SUM(O.Amount) AS Total_Spending
FROM Customerss AS C
JOIN Orderss O
	 ON C.customers_id = O.customers_id
GROUP BY C.customers_id, C.customers_name
ORDER BY Total_Spending DESC
LIMIT 2;

-- Q.12] Find orders placed in the last 90 days.
SELECT * FROM Orderss
WHERE orders_date >= CURDATE() - INTERVAL 90 DAY;

-- Q.13] Find the highest single order amount for each customer.
SELECT C.customers_id, C.customers_name, MAX(O.Amount) AS Highest_Order_Amount
FROM Customerss AS C
JOIN Orderss AS O
	 ON C.customers_id = O.customers_id
GROUP BY C.customers_id, C.customers_name;


-- SCENARIO 3
-- SCHOOL DATABASE
-- Creating 'Students' table :-
CREATE TABLE Students
(
	student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_id INT,
    marks DECIMAL(5,2),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

INSERT INTO Students (student_id, student_name, class_id, marks)
VALUES
	(1, 'Aarav', 5, 78),
	(2, 'Meera', 6, 85),
	(3, 'Rohan', 7, 92),
	(4, 'Anika', 8, 66),
	(5, 'Kabir', 9, 74),
	(6, 'Tanya', 10, 88),
	(7, 'Vihaan', NULL, 81),
	(8, 'Aisha', NULL, 69),
	(9, 'Arjun', 6, 95),
	(10, 'Siya', 7, 55);
SELECT * FROM Students;

-- Creating 'Classes' table :-
CREATE TABLE Classes
(
	class_id INT PRIMARY KEY,
    class_name VARCHAR(50)
);

INSERT INTO Classes (class_id, class_name)
VALUES
	(5, '5th'),
	(6, '6th'),
	(7, '7th'),
	(8, '8th'),
	(9, '9th'),
	(10, '10th');
SELECT * FROM Classes;

-- Q.14] List all students in Class 10.
SELECT student_id, student_name, marks
FROM students
WHERE class_id = 10;

-- Q.15] Find students who scored more than 80 marks.
SELECT student_id, student_name, class_id, marks
FROM Students
WHERE marks > 80;

-- Q.16] Find the average marks for each class.
SELECT class_id, ROUND(AVG(marks),2) AS Average_Marks
FROM Students
WHERE class_id IS NOT NULL
GROUP BY class_id;

-- Q.17] List students who scored above the class average.
 -- Unsolved
 
 -- Q.18] Find students who are not assigned to any class.
SELECT student_id, student_name, class_id
FROM Students
WHERE class_id IS NULL;


-- SCENARIO 4
-- BANKING TRANSACTIONS
-- Creating 'Accounts' table :-
CREATE TABLE Accounts
(
	account_id INT PRIMARY KEY,
    account_holder VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO Accounts (account_id, account_holder, balance)
VALUES
	(1001, 'Rajesh Sharma', 5000.00),
	(1002, 'Priya Singh', 800.00),
	(1003, 'Anil Kumar', 1200.00),
	(1023, 'Sneha Patil', 950.00),
	(1045, 'Rohit Mehta', 4500.00),
	(1050, 'Kavita Joshi', 3000.00),
	(1067, 'Manish Reddy', 700.00),
	(1089, 'Pooja Verma', 4000.00),
	(1100, 'Vikram Das', 2000.00),
	(1111, 'Neha Chavan', 6000.00);
SELECT * FROM Accounts;

-- Creating 'Transactions' table :-
CREATE TABLE Transactions
(
	txn_id INT PRIMARY KEY,
    account_id INT,
    txn_date DATE,
    amount DECIMAL(10,2),
    txn_type ENUM('credit','debit'),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

INSERT INTO Transactions (txn_id, account_id, txn_date, amount, txn_type)
VALUES
	(201, 1001, '2025-08-10', 1500.00, 'credit'),
	(202, 1001, '2025-08-12', 500.00, 'debit'),
	(203, 1001, '2025-08-15', 1200.00, 'credit'),
	(204, 1002, '2025-08-05', 200.00, 'debit'),
	(205, 1003, '2025-07-25', 500.00, 'credit'),
	(206, 1023, '2025-08-01', 100.00, 'debit'),
	(207, 1045, '2025-07-30', 2500.00, 'credit'),
	(208, 1050, '2025-07-15', 1200.00, 'debit'),
	(209, 1067, '2025-08-12', 300.00, 'debit'),
	(210, 1089, '2025-06-28', 1500.00, 'credit');
SELECT * FROM Transactions;

-- Q.19] Fetch all transactions for account ID 1001.
SELECT * FROM Transactions
WHERE account_id = '1001'
ORDER BY txn_date;

-- Q.20] Find the total credited amount for each account.
SELECT A.account_id, A.account_holder, SUM(T.amount) AS Total_Credit
FROM Accounts AS A
JOIN Transactions AS T
	 ON T.account_id = A.account_id
WHERE T.txn_type = 'credit'
GROUP BY A.account_id, A.account_holder;

-- Q.21] List accounts that have never made a transaction.
SELECT A.account_id, A.account_holder, A.balance
FROM Accounts AS A
LEFT JOIN Transactions AS T
		  ON A.account_id = T.account_id
WHERE T.txn_id IS NULL;

-- Q.22] Find accounts where the balance is less than 1000.
SELECT * FROM Accounts
WHERE BALANCE < 1000;

-- Q.23] Fetch the last transaction date for each account.
SELECT A.account_id, A.account_holder, MAX(T.txn_date) AS Last_Transaction_Date
FROM Accounts AS A
LEFT JOIN Transactions AS T
		  ON A.account_id = T.account_id
GROUP BY A.account_id, A.account_holder;

-- Q.24] Calculate the net transaction amount (credits – debits) for each account
-- Unsolved.



-- SCENARIO 5
-- MOVIE DATABASE
-- Creating 'Movies' table :-
CREATE TABLE Movies
(
	movie_id INT PRIMARY KEY,
    title VARCHAR(250) NOT NULL,
    release_year YEAR,
    rating DECIMAL(3,1)
);

INSERT INTO Movies (movie_id, title, release_year, rating) VALUES
	(1, 'Inception', 2021, 8.8),
	(2, 'The Matrix Resurrections', 2021, 7.2),
	(3, 'Dune', 2022, 8.6),
	(4, 'Avatar: The Way of Water', 2022, 8.1),
	(5, 'Spider-Man: No Way Home', 2021, 8.4),
	(6, 'Everything Everywhere All at Once', 2022, 8.9),
	(7, 'Top Gun: Maverick', 2022, 8.3),
	(8, 'Black Panther: Wakanda Forever', 2022, 7.8),
	(9, 'Doctor Strange in the Multiverse of Madness', 2022, 7.9),
	(10, 'The Batman', 2022, 8.2);
SELECT * FROM Movies;

-- Creating 'Actors' table :-
CREATE TABLE Actors
(
	actor_id INT PRIMARY KEY,
    actor_name VARCHAR(255) NOT NULL
);

INSERT INTO Actors (actor_id, actor_name) VALUES
	(1, 'Leonardo DiCaprio'),
	(2, 'Joseph Gordon-Levitt'),
	(3, 'Elliot Page'),
	(4, 'Keanu Reeves'),
	(5, 'Carrie-Anne Moss'),
	(6, 'Zendaya'),
	(7, 'Timothée Chalamet'),
	(8, 'Rebecca Ferguson'),
	(9, 'Michelle Yeoh'),
	(10, 'Robert Pattinson');
SELECT * FROM Actors;

-- Creating 'Movie_Actors' table :-
CREATE TABLE Movie_Actors
(
	movie_id INT,
    actor_id INT,
    PRIMARY KEY(movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

-- Inception has 3 actors
INSERT INTO Movie_Actors (movie_id, actor_id)
VALUES
	(1, 1), 
	(1, 2), 
	(1, 3),
	(2, 4), 
	(2, 5),
	(3, 6), 
	(3, 7), 
	(3, 8),
	(6, 9), 
	(6, 3), 
	(6, 7),
	(5, 6), 
	(5, 7),
	(10, 10);

-- Q.25] List all movies released in 2022.
SELECT * FROM Movies
WHERE release_year = 2022;

-- Q.26] Find movies with a rating above 8.5.
SELECT * FROM Movies
WHERE rating > 8.5;

-- Q.27] List all actors who worked in the movie Inception.
SELECT A.actor_id, A.actor_name
FROM Actors AS A
JOIN Movie_Actors AS MA 
	 ON A.actor_id = MA.actor_id
JOIN Movies AS M
	 ON MA.movie_id = M.movie_id
WHERE M.title = 'Inception';

-- Q.28] Count the number of movies each actor has acted in.
SELECT A.actor_id, A.actor_name, COUNT(MA.movie_id) AS Movies_Count
FROM Actors AS A
LEFT JOIN Movie_Actors AS MA
		  ON A.actor_id = MA.actor_id
GROUP BY A.actor_id, A.actor_name;

-- Q.29] Find movies that have more than 3 actors.
SELECT M.movie_id, M.title, COUNT(MA.actor_id) AS Actor_Count
FROM Movies AS M
JOIN Movie_Actors AS MA
	 ON M.movie_id = MA.movie_id
GROUP BY M.movie_id, M.title
HAVING COUNT(MA.actor_id) >= 3;


