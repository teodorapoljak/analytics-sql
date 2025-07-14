--CREATE TABLES WITH PRIMARY AND FOREIGN KEYS

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

--cause I didn't define keys when firsty created employee table above, considering that sqlite doesn't support 'ALTER TABLE add FOREIGN KEY':
--I have to create the same but renamed table with added keys, then insert employee columns into employee_new table and after it run: 
--'ALTER TABLE employee_new RENAME TO employee'

CREATE TABLE employee_new (
	emp_id INT PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	birth_date DATE,
	sex VARCHARE(1),
	salary INT,
	super_id INT,
	branch_id INT,
	FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL,
	FOREIGN KEY(super_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

INSERT INTO employee_new (emp_id, first_name, last_name, birth_date, sex, salary, super_id, branch_id)
SELECT emp_id,first_name, last_name, birth_date , sex, salary, super_id, branch_id FROM employee;

DROP TABLE employee;

ALTER TABLE employee_new RENAME TO employee;

--enable foreign key option

PRAGMA foreign_key = on;

--Create CLIENT table

CREATE TABLE client (
	client_id INT PRIMARY KEY,
	client_name VARCHAR(40),
	branch_id INT(1),
	FOREIGN KEY(branch_id) REFERENCES employee (branch_id) ON DELETE SET NULL
);

--Create works_with table

CREATE TABLE work_with (
	emp_id INT,
	client_id INT,
	total_sales INT,
	FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
	FOREIGN KEY(client_id) REFERENCES client (client_id) ON DELETE CASCADE
);

--Create CLIENT branch_supplier table

CREATE TABLE branch_supplier (
	branch_id INT,
	supplier_name VARCHAR(30),
	supply_type VARCHAR(30),
	PRIMARY KEY(branch_id, supplier_name),
	FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

--insert date into employee table

--Corporate set up (branch_id = 1)

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, 1);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

--cause I intended to set branch_id as NULL for the first row, instead set it to 1, needed to update employee first row:

UPDATE employee
SET branch_id = NULL
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

--Scranton set up (branch_id = 2) & values

INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee 
SET branch_id = 2
WHERE emp_id = 102

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

--Stamford set up (branch_id = 3) & values

INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1973-07-22', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


--Branch Supplier values

INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

--Client values

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

--Works with values

INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

--cause I accidantly named table work_with instead of works_with, needed to rename it so the valuse above could be entered.
--* a could have just entered work_with name within values, but.. 

ALTER TABLE work_with RENAME TO works_with;

===========================================================================================================================
--BASIC QUERIES

--find all employees
SELECT * FROM employee;

--find all employees ordered by salary
SELECT * FROM employee
ORDER BY salary DESC;

--find all employees ordered by sex then name
SELECT * FROM employee 
ORDER BY sex, first_name;

--Find the first 5 employees in the table
SELECT * FROM employee
LIMIT 5;

--Find the first and last names of all employees
SELECT first_name, last_name FROM employee;

--Find the forename and surnames names of all employees
SELECT first_name AS forename, last_name AS surname
FROM employee;

--Find out all the different genders
SELECT DISTINCT sex FROM employee;

--Find all female employees
SELECT * from employee 
WHERE sex = 'F';

--Find all employees at branch 3
SELECT * FROM employee 
WHERE branch_id = 3;

--Find all employee's id's and names who were born after 1969
SELECT emp_id, first_name, birth_date FROM employee
WHERE birth_date > '1969%';

--Find all female employees at branch 2
SELECT * FROM employee
WHERE sex = 'F' AND branch_id = 2;

--Find all employees who are female & born after 1969 or who make over 80000
--if there are two conditions for where statement, but also 'or' condition, then we use: (1 AND 2) OR 3
SELECT * FROM employee
WHERE (sex = 'F' AND birth_date >= '1969-01-01') OR salary > 80000;

--Find all employees born between 1970 and 1975
SELECT * FROM employee
WHERE birth_date BETWEEN '1970-01-01' AND '1975-12-31';

--Find all employees named Jim, Michael, Johnny or David
--if the query demands more then two conditions in WHERE claus, then we use: IN (%, %, %...)
SELECT * FROM employee
WHERE first_name IN ('Jim', 'Michael', 'Johnny', 'David');

=======================================================================================================

--FUNCIONS

--Find the number of employees
--total employees
SELECT COUNT(emp_id) FROM employee;

--how many emloyees have superviser
SELECT COUNT(super_id) FROM employee;

--Find the average of all employee's salaries
SELECT AVG(salary) FROM employee;

--Find the sum of all employee's salaries
SELECT SUM(salary) FROM employee;

--Find out how many males and females there are
SELECT sex, COUNT(sex) FROM employee
GROUP BY sex;

--Find the total sales of each salesman
SELECT emp_id, SUM(total_sales) FROM works_with
GROUP BY emp_id;

--Find the total amount of money spent by each client
SELECT client_id, SUM(total_sales) FROM works_with
GROUP BY client_id;


=======================================================================================================
  
-- WILDCARDS
-- % = any # characters, _ = one character

--Find any client's who are an LLC
SELECT * FROM client
WHERE client_name LIKE '%LLC';

--Find any branch suppliers who are in the label business
SELECT * FROM branch_supplier
WHERE supplier_name LIKE '% Label%';

--Find any employee born on the 10th day of the month
SELECT * FROM employee
WHERE birth_date LIKE '_____10%';

--Find any clients who are schools
SELECT * FROM client
WHERE client_name LIKE '%school%';

========================================================================================================

-- UNION
  
--used when there're multiple SELECT statements.
--Union creates one row of all information pulled.
--Have to have same number of columns pulled from all SELECT statements.
--Pulled columns must have same data type.
--Generated column from UNION query will be named after first selected column in it.
--If renaming generated column: SELECT first_name AS Company_Names

SELECT first_name AS Company_Names FROM employee
UNION
SELECT branch_name FROM branch
UNION
SELECT client_name FROM client;

--Find a list of all clients & branch suppliers' names
SELECT client.client_name AS Client_and_Supplier_Names, client.branch_id 
FROM client
UNION 
SELECT branch_supplier.supplier_name, branch_supplier.branch_id 
FROM branch_supplier;


--JOINS

--Add the extra branch

INSERT INTO branch VALUES (4, 'Buffalo', NULL, NULL );

SELECT e.emp_id, e.first_name, e.branch_id FROM employee e
JOIN branch b
ON e.emp_id = b.mgr_id; 

-- Find all branches and the names of their managers
SELECT e.emp_id, e.first_name, e.last_name, b.branch_id
FROM employee e
LEFT JOIN branch b -- all rows from left table (employee) and data that matches in branch table. // All employees
ON e.emp_id = b.mgr_id;

SELECT e.emp_id, e.first_name, e.last_name, b.branch_id
FROM employee e
RIGHT JOIN branch b -- data that matches in employee table and all the rows from the right table (branch table) // All branches
ON e.emp_id = b.mgr_id;

--FULL OUTER JOIN  -- LEFT and RIGHT join combined.

=============================================================================================================

-- NESTED QUERIES

-- Find names of all employees who have sold over 30,000 to a single client
SELECT e.first_name, e.last_name
FROM employee e 
WHERE e.emp_id IN (	SELECT ww.emp_id
					FROM works_with ww 
					WHERE ww.total_sales > 30000);

-- Find names of all employees who have sold over 50,000
SELECT e.first_name 
FROM employee e
WHERE e.emp_id IN (	SELECT ww.emp_id
					FROM works_with ww
					WHERE ww.total_sales > 50000);

-- Find all clients who are handles by the branch that Michael Scott manages
-- Assume we know Michael's ID
SELECT c.client_name 
FROM client c 
WHERE c.branch_id = (	SELECT 	b.branch_id 
						FROM  branch b  
						WHERE mgr_id = 102
						LIMIT 1);

-- Find all clients who are handles by the branch that Michael Scott manages
-- Assume we DONT'T know Michael's ID
SELECT c.client_id, c.client_name 
FROM client c
WHERE c.branch_id IN (	SELECT b.branch_id
						FROM branch b
						WHERE b.mgr_id IN (	SELECT e.emp_id
											FROM employee e
											WHERE e.first_name = 'Michael' AND e.last_name = 'Scott'
											LIMIT 1))

-- Find the names of employees who work with clients handled by the scranton branch
SELECT e.first_name, e.last_name 		-- what will display as table
FROM employee e 
WHERE e.emp_id IN (	SELECT ww.emp_id
					FROM works_with ww) -- connect e.emp_id with clients (client_id)
AND e.branch_id = 2; 					-- without this all emp_id from worsk_with table would be displayed, but we need only scranton (2)
 	
-- Find the names of all clients who have spent more than 100,000 dollars
SELECT c.client_name
FROM client c 
WHERE c.client_id IN (	SELECT client_id
						FROM (	SELECT SUM(ww.total_sales) AS totals, client_id 
								FROM works_with ww
								GROUP BY client_id) AS total_client_sales
						WHERE totals > 100000
);

=======================================================================================================================

-- On Delete Set NULL / On Delete Cascade
  
-- For example, lets say that Michael is no longer in the company.
-- ON DELETE SET NULL basically means that after removing any information, that data will be updated with NUll.

--Deleting Michael Scott from the database
DELETE FROM employee
WHERE emp_id = 102;

SELECT * FROM branch;

SELECT * FROM employee e;


-- ON DELETE CASCADE basically when we remove the data, we will delete entire row in the database.

--Deleting branch 2 from the supplier table
DELETE FROM branch_supplier 
WHERE branch_id = 2;

SELECT * FROM branch_supplier bs;

======================================================================================================================
