
-- Create the BookStore database
CREATE DATABASE IF NOT EXISTS BookStore;
USE BookStore;

-- Create tables for the BookStore database

-- 1. Book Language table
CREATE TABLE IF NOT EXISTS book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);

-- 2. Publisher table
CREATE TABLE IF NOT EXISTS publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 3. Book table
CREATE TABLE IF NOT EXISTS book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10, 2),
    publication_year INT,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- 4. Author table
CREATE TABLE IF NOT EXISTS author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    bio TEXT
);

-- 5. Book_Author (junction table)
CREATE TABLE IF NOT EXISTS book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- 6. Country table
CREATE TABLE IF NOT EXISTS country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- 7. Address table
CREATE TABLE IF NOT EXISTS address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- 8. Address_Status table
CREATE TABLE IF NOT EXISTS address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- 9. Customer table
CREATE TABLE IF NOT EXISTS customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- 10. Customer_Address table
CREATE TABLE IF NOT EXISTS customer_address (
    customer_address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    address_id INT,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- 11. Shipping_Method table
CREATE TABLE IF NOT EXISTS shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    estimated_days INT
);

-- 12. Order_Status table
CREATE TABLE IF NOT EXISTS order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- 13. Cust_Order table
CREATE TABLE IF NOT EXISTS cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipping_method_id INT,
    order_status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(status_id)
);

-- 14. Order_Line table
CREATE TABLE IF NOT EXISTS order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- 15. Order_History table
CREATE TABLE IF NOT EXISTS order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Create user groups with appropriate permissions
-- Admin user with full access
CREATE USER IF NOT EXISTS 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON BookStore.* TO 'bookstore_admin'@'localhost';

-- Sales staff with read/write access to customer and order tables
CREATE USER IF NOT EXISTS 'sales_staff'@'localhost' IDENTIFIED BY 'sales_password';
GRANT SELECT, INSERT, UPDATE ON BookStore.customer TO 'sales_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BookStore.cust_order TO 'sales_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BookStore.order_line TO 'sales_staff'@'localhost';
GRANT SELECT ON BookStore.book TO 'sales_staff'@'localhost';
GRANT SELECT ON BookStore.author TO 'sales_staff'@'localhost';

-- Inventory manager with read/write access to book and inventory tables
CREATE USER IF NOT EXISTS 'inventory_manager'@'localhost' IDENTIFIED BY 'inventory_password';
GRANT SELECT, INSERT, UPDATE ON BookStore.book TO 'inventory_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BookStore.book_author TO 'inventory_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BookStore.author TO 'inventory_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BookStore.publisher TO 'inventory_manager'@'localhost';

-- Read-only user for reports
CREATE USER IF NOT EXISTS 'report_user'@'localhost' IDENTIFIED BY 'report_password';
GRANT SELECT ON BookStore.* TO 'report_user'@'localhost';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- Insert sample data for testing

-- Insert languages
INSERT INTO book_language (language_name) VALUES 
('English'), ('Spanish'), ('French'), ('German'), ('Chinese');

-- Insert publishers
INSERT INTO publisher (name) VALUES 
('Penguin Random House'), ('HarperCollins'), ('Simon & Schuster'), 
('Macmillan Publishers'), ('Hachette Book Group');

-- Insert authors
INSERT INTO author (first_name, last_name, bio) VALUES
('Jane', 'Austen', 'English novelist known primarily for her six major novels'),
('George', 'Orwell', 'English novelist, essayist, journalist, and critic'),
('J.K.', 'Rowling', 'British author, philanthropist, film producer, and screenwriter'),
('Stephen', 'King', 'American author of horror, supernatural fiction, suspense, and fantasy novels'),
('Agatha', 'Christie', 'English writer known for her 66 detective novels');

-- Insert books
INSERT INTO book (title, isbn, language_id, publisher_id, price, publication_year) VALUES
('Pride and Prejudice', '9780141439518', 1, 1, 9.99, 1813),
('1984', '9780451524935', 1, 2, 12.50, 1949),
('Harry Potter and the Philosopher''s Stone', '9780747532743', 1, 3, 15.99, 1997),
('The Shining', '9780307743657', 1, 4, 11.25, 1977),
('Murder on the Orient Express', '9780062693662', 1, 5, 10.75, 1934);

-- Link books to authors
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1), -- Pride and Prejudice - Jane Austen
(2, 2), -- 1984 - George Orwell
(3, 3), -- Harry Potter - J.K. Rowling
(4, 4), -- The Shining - Stephen King
(5, 5); -- Murder on the Orient Express - Agatha Christie

-- Insert countries
INSERT INTO country (country_name) VALUES
('United States'), ('United Kingdom'), ('Canada'), ('Australia'), ('Germany');

-- Insert address statuses
INSERT INTO address_status (status_name) VALUES
('Current'), ('Previous'), ('Shipping'), ('Billing'), ('Business');

-- Insert addresses
INSERT INTO address (street, city, postal_code, country_id) VALUES
('123 Main St', 'New York', '10001', 1),
('456 High St', 'London', 'SW1A 1AA', 2),
('789 Maple Ave', 'Toronto', 'M5V 2L7', 3),
('101 Ocean Dr', 'Sydney', '2000', 4),
('202 Berlin Blvd', 'Berlin', '10115', 5);

-- Insert customers
INSERT INTO customer (first_name, last_name, email, phone) VALUES
('John', 'Smith', 'john.smith@example.com', '555-123-4567'),
('Emily', 'Johnson', 'emily.johnson@example.com', '555-234-5678'),
('Michael', 'Williams', 'michael.williams@example.com', '555-345-6789'),
('Sarah', 'Brown', 'sarah.brown@example.com', '555-456-7890'),
('David', 'Jones', 'david.jones@example.com', '555-567-8901');

-- Link customers to addresses
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1), -- John Smith's current address
(2, 2, 1), -- Emily Johnson's current address
(3, 3, 1), -- Michael Williams's current address
(4, 4, 1), -- Sarah Brown's current address
(5, 5, 1); -- David Jones's current address

-- Insert shipping methods
INSERT INTO shipping_method (method_name, estimated_days) VALUES
('Standard', 5),
('Express', 2),
('Overnight', 1),
('International', 10),
('Store Pickup', 0);

-- Insert order statuses
INSERT INTO order_status (status_name) VALUES
('Pending'), ('Processing'), ('Shipped'), ('Delivered'), ('Cancelled');

-- Insert orders
INSERT INTO cust_order (customer_id, order_date, shipping_method_id, order_status_id) VALUES
(1, '2025-03-10 10:30:00', 1, 3), -- John Smith's order, shipped
(2, '2025-03-12 14:45:00', 2, 2), -- Emily Johnson's order, processing
(3, '2025-03-15 09:15:00', 1, 1), -- Michael Williams's order, pending
(4, '2025-03-18 16:20:00', 3, 4), -- Sarah Brown's order, delivered
(5, '2025-03-20 11:05:00', 5, 5); -- David Jones's order, cancelled

-- Insert order lines
INSERT INTO order_line (order_id, book_id, quantity, price) VALUES
(1, 1, 1, 9.99),   -- John ordered Pride and Prejudice
(1, 3, 1, 15.99),  -- John also ordered Harry Potter
(2, 2, 2, 12.50),  -- Emily ordered two copies of 1984
(3, 4, 1, 11.25),  -- Michael ordered The Shining
(4, 5, 1, 10.75),  -- Sarah ordered Murder on the Orient Express
(5, 3, 3, 15.99);  -- David ordered three copies of Harry Potter (cancelled)

-- Insert order history
INSERT INTO order_history (order_id, status_id, timestamp) VALUES
(1, 1, '2025-03-10 10:30:00'), -- John's order placed
(1, 2, '2025-03-10 14:15:00'), -- John's order processing
(1, 3, '2025-03-11 09:45:00'), -- John's order shipped
(2, 1, '2025-03-12 14:45:00'), -- Emily's order placed
(2, 2, '2025-03-13 10:30:00'), -- Emily's order processing
(3, 1, '2025-03-15 09:15:00'), -- Michael's order placed
(4, 1, '2025-03-18 16:20:00'), -- Sarah's order placed
(4, 2, '2025-03-18 18:45:00'), -- Sarah's order processing
(4, 3, '2025-03-19 08:30:00'), -- Sarah's order shipped
(4, 4, '2025-03-20 14:20:00'), -- Sarah's order delivered
(5, 1, '2025-03-20 11:05:00'), -- David's order placed
(5, 5, '2025-03-20 15:30:00'); -- David's order cancelled

-- Sample queries for testing

-- 1. Get all books with their authors
SELECT b.book_id, b.title, b.isbn, a.first_name, a.last_name
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;

-- 2. Get customer order history with book details
SELECT c.first_name, c.last_name, o.order_date, b.title, ol.quantity, ol.price,
       os.status_name, sm.method_name
FROM customer c
JOIN cust_order o ON c.customer_id = o.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id
JOIN order_status os ON o.order_status_id = os.status_id
JOIN shipping_method sm ON o.shipping_method_id = sm.shipping_method_id;

-- 3. Get total sales by book
SELECT b.title, SUM(ol.quantity) AS total_sold, SUM(ol.quantity * ol.price) AS total_revenue
FROM book b
JOIN order_line ol ON b.book_id = ol.book_id
JOIN cust_order o ON ol.order_id = o.order_id
WHERE o.order_status_id != 5 -- Excluding cancelled orders
GROUP BY b.book_id
ORDER BY total_revenue DESC;

-- 4. Get customer addresses with status
SELECT c.first_name, c.last_name, a.street, a.city, a.postal_code, co.country_name, ast.status_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN country co ON a.country_id = co.country_id
JOIN address_status ast ON ca.status_id = ast.status_id;

-- 5. Track the status history of an order
SELECT o.order_id, c.first_name, c.last_name, os.status_name, oh.timestamp
FROM order_history oh
JOIN cust_order o ON oh.order_id = o.order_id
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_status os ON oh.status_id = os.status_id
WHERE o.order_id = 1 -- Checking history for order #1
ORDER BY oh.timestamp;
