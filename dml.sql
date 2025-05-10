-- 1. Create database and tables
DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

-- 1. Create sample tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE 
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) CHECK (price > 0),
    stock_quantity INT DEFAULT 0
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    order_total DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    department VARCHAR(50)
);

-- 2. Insert sample data
INSERT INTO customers (customer_name, email) VALUES
('John Smith', 'john@example.com'),
('Sarah Johnson', 'sarah@example.com'),
('Mike Brown', 'mike@example.com');

INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 999.99, 10),
('Smartphone', 'Electronics', 699.99, 15),
('Desk Chair', 'Furniture', 199.50, 5),
('Coffee Table', 'Furniture', 299.00, 3);

INSERT INTO employees (employee_name, salary, department) VALUES
('Alice Chen', 75000.00, 'Sales'),
('Bob Wilson', 85000.00, 'IT'),
('Carol Davis', 65000.00, 'HR');

INSERT INTO orders (customer_id, order_total) VALUES
(1, 999.99),
(2, 899.49),
(1, 299.00);

INSERT INTO order_items VALUES
(1, 1, 1, 999.99),
(2, 2, 1, 699.99),
(2, 3, 1, 199.50),
(3, 4, 1, 299.00);

-- 3. Query 1: Basic SELECT with WHERE
SELECT product_name, price 
FROM products 
WHERE price > 50 AND category = 'Electronics';

-- 4. Query 2: JOIN with GROUP BY
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 5. Query 3: Subquery in WHERE clause
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 6. Query 4: Correlated Subquery
SELECT product_name, price
FROM products p
WHERE price = (SELECT MAX(price) 
               FROM products 
               WHERE category = p.category);

-- 7. Query 5: View Creation
CREATE VIEW high_value_orders AS
SELECT o.order_id, c.customer_name, o.order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_total > 500;

-- 8. Query 6: View Usage
SELECT * FROM high_value_orders
ORDER BY order_total DESC;

-- 9. Query 7: EXISTS Subquery
SELECT customer_name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o 
              WHERE o.customer_id = c.customer_id
              AND o.order_total > 800);

-- 10. Query 8: UPDATE with Subquery
UPDATE products
SET price = price * 0.9  -- 10% discount
WHERE product_id IN (SELECT product_id 
                     FROM order_items 
                     GROUP BY product_id
                     HAVING SUM(quantity) < 2);

-- 11. Query 9: DELETE with Subquery
DELETE FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- 12. Query 10: Complex JOIN with Aggregation
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) AS orders_count,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 13. Cleanup (optional)
-- DROP VIEW IF EXISTS high_value_orders;
-- DROP TABLE IF EXISTS order_items, orders, products, customers, employees;
