-- 1. Create database and tables
DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

-- Create departments table with constraints

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(50) DEFAULT 'Headquarters'
);

-- Create employees table with multiple constraints
DROP TABLE IF EXISTS employee;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary DECIMAL(10,2) CHECK (salary > 0),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 2. Create a view
CREATE VIEW emp_dept_view AS
SELECT e.emp_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       d.dept_name, e.salary, e.hire_date
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- 3. Create an index
CREATE INDEX idx_emp_name ON employees(last_name, first_name);

-- 4. Insert sample data
INSERT INTO departments (dept_name, location) VALUES
('HR', 'Floor 1'),
('IT', 'Floor 2'),
('Finance', 'Floor 3');

INSERT INTO employees (first_name, last_name, email, salary, dept_id) VALUES
('John', 'Doe', 'john.doe@company.com', 50000, 1),
('Jane', 'Smith', 'jane.smith@company.com', 60000, 2),
('Mike', 'Johnson', 'mike.johnson@company.com', 55000, 3);

-- 5. DML Queries (10 examples)

-- 1. Select all employees
SELECT * FROM employees;

-- 2. Select specific columns with WHERE
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary > 55000;

-- 3. Join tables
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- 4. Aggregate function
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 5. Update record
UPDATE employees
SET salary = salary * 1.1
WHERE emp_id = 1;

-- 6. Delete record
DELETE FROM employees
WHERE emp_id = 3;

-- 7. Order by
SELECT * FROM employees
ORDER BY last_name ASC;

-- 8. Like operator
SELECT * FROM employees
WHERE last_name LIKE 'D%';

-- 9. Between operator
SELECT * FROM employees
WHERE salary BETWEEN 40000 AND 60000;

-- 10. Subquery
SELECT first_name, last_name
FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'Floor 1');

-- 6. Show view results
SELECT * FROM emp_dept_view;
