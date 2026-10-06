-- ============================================================
-- WEEK 40 - SQL FUNDAMENTALS
-- TrailShop Database
-- ============================================================

-- ============================================================
-- TASK 1.1 - CREATE DATABASE
-- ============================================================

-- Run this first if the database does not already exist:
-- CREATE DATABASE trailshop;

-- Then connect to the database:
-- \c trailshop


-- ============================================================
-- TASK 1.2 - CREATE ALL SIX TABLES
-- ============================================================

-- 1. Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);


-- 2. Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 3. Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 4. Product Categories
-- This is a junction table between products and categories.
CREATE TABLE product_categories (
    product_id INTEGER NOT NULL
        REFERENCES products(product_id)
        ON DELETE CASCADE,

    category_id INTEGER NOT NULL
        REFERENCES categories(category_id)
        ON DELETE CASCADE,

    PRIMARY KEY (product_id, category_id)
);


-- 5. Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL
        REFERENCES customers(customer_id),

    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'))
);


-- 6. Order Items
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,

    order_id INTEGER NOT NULL
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    product_id INTEGER NOT NULL
        REFERENCES products(product_id),

    quantity INTEGER NOT NULL CHECK (quantity > 0),

    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0)
);


-- Check that the tables were created:
-- \dt


-- ============================================================
-- TASK 1.3 - INSERT SAMPLE DATA
-- ============================================================


-- ------------------------------------------------------------
-- CATEGORIES
-- ------------------------------------------------------------

INSERT INTO categories (name, description) VALUES
('Footwear', 'Hiking boots, trail runners, and sandals'),
('Backpacks', 'Day packs, overnight packs, and expedition packs'),
('Tents', 'One-person to family-size tents'),
('Clothing', 'Outdoor clothing for all seasons'),
('Accessories', 'Water bottles, headlamps, trekking poles');


-- Check categories:
-- SELECT * FROM categories;


-- ------------------------------------------------------------
-- CUSTOMERS
-- ------------------------------------------------------------

INSERT INTO customers (first_name, last_name, email) VALUES
('Anna', 'Virtanen', 'anna.v@email.com'),
('Mikko', 'Korhonen', 'mikko.k@email.com'),
('Sara', 'Mäkinen', 'sara.m@email.com'),
('Juha', 'Nieminen', 'juha.n@email.com'),
('Laura', 'Hämäläinen', 'laura.h@email.com');


-- Check customers:
-- SELECT * FROM customers;


-- ------------------------------------------------------------
-- PRODUCTS
-- ------------------------------------------------------------

INSERT INTO products (name, description, price, stock) VALUES
('TrailMaster X4',
 'Professional hiking boot with Gore-Tex lining',
 149.99, 25),

('LiteStep Pro',
 'Lightweight trail runner for day hikes',
 89.99, 40),

('Summit 45L',
 'Multi-day hiking backpack with rain cover',
 199.99, 15),

('DayTripper 20L',
 'Compact day pack with hydration sleeve',
 59.99, 50),

('CloudNest 2P',
 'Two-person ultralight tent',
 349.99, 10),

('StormShield 4P',
 'Four-season family tent',
 499.99, 5),

('ThermoLayer Jacket',
 'Insulated mid-layer for cold weather',
 129.99, 30),

('RainGuard Pro',
 'Waterproof breathable rain jacket',
 179.99, 20),

('HydroFlask 1L',
 'Insulated stainless steel water bottle',
 34.99, 100),

('LumaBeam 800',
 'Rechargeable headlamp, 800 lumens',
 44.99, 60);


-- Check products:
-- SELECT * FROM products;


-- ------------------------------------------------------------
-- PRODUCT CATEGORIES
-- ------------------------------------------------------------

-- Category IDs:
-- 1 = Footwear
-- 2 = Backpacks
-- 3 = Tents
-- 4 = Clothing
-- 5 = Accessories
--
-- RainGuard Pro belongs to both Clothing and Accessories.

INSERT INTO product_categories (product_id, category_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(8, 5),
(9, 5),
(10, 5);


-- Check product categories:
-- SELECT * FROM product_categories;


-- ------------------------------------------------------------
-- ORDERS
-- ------------------------------------------------------------

INSERT INTO orders (customer_id, status) VALUES
(1, 'delivered'),
(2, 'shipped'),
(1, 'pending'),
(3, 'delivered'),
(4, 'pending');


-- Check orders:
-- SELECT * FROM orders;


-- ------------------------------------------------------------
-- ORDER ITEMS
-- ------------------------------------------------------------

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 149.99),
(1, 9, 2, 34.99),
(2, 3, 1, 199.99),
(2, 7, 1, 129.99),
(3, 5, 1, 349.99),
(4, 2, 1, 89.99),
(4, 4, 1, 59.99),
(4, 10, 1, 44.99),
(5, 6, 1, 499.99),
(5, 8, 1, 179.99);


-- Check order items:
-- SELECT * FROM order_items;


-- ============================================================
-- TASK 1.4 - PRACTICE UPDATE
-- ============================================================


-- 1. Increase the price of Footwear products by 10%.
-- Footwear category_id is 1.

UPDATE products
SET price = price * 1.10
WHERE product_id IN (
    SELECT product_id
    FROM product_categories
    WHERE category_id = 1
);


-- 2. Change customer #3's email.

UPDATE customers
SET email = 'sara.new@email.com'
WHERE customer_id = 3;


-- 3. Change order #2 from shipped to delivered.

UPDATE orders
SET status = 'delivered'
WHERE order_id = 2
AND status = 'shipped';


-- 4. Set HydroFlask 1L stock to 85.

UPDATE products
SET stock = 85
WHERE name = 'HydroFlask 1L';


-- 5. Add a description to a product with NULL description.

-- First, make product #10 NULL for practice:
UPDATE products
SET description = NULL
WHERE product_id = 10;

-- Now add a description:
UPDATE products
SET description = 'Rechargeable outdoor headlamp for hiking and camping'
WHERE product_id = 10
AND description IS NULL;


-- Verify UPDATE:
-- SELECT * FROM products;
-- SELECT * FROM customers;
-- SELECT * FROM orders;


-- ============================================================
-- TASK 1.5 - PRACTICE DELETE
-- ============================================================


-- 1. Delete the most recently created order.
-- Order #5 is the latest order in our sample data.
-- Its order_items will also be deleted because of ON DELETE CASCADE.

DELETE FROM orders
WHERE order_id = 5;


-- 2. Try to delete a product that is used in order_items.
--
-- This should give a foreign key error because
-- order_items refers to this product.
--
-- Run this separately:
--
-- DELETE FROM products
-- WHERE product_id = 1;


-- 3. Delete a category.
-- The product will remain, but the link in
-- product_categories will be removed.

DELETE FROM categories
WHERE category_id = 5;


-- Check that the products still exist:
-- SELECT * FROM products;
-- SELECT * FROM product_categories;


-- 4. Delete a customer who has no orders.
-- Customer #5 has no order in the original sample data.

DELETE FROM customers
WHERE customer_id = 5;


-- ============================================================
-- TASK 1.6 - PRACTICE ALTER TABLE
-- ============================================================


-- 1. Add phone number to customers.

ALTER TABLE customers
ADD COLUMN phone VARCHAR(20);


-- 2. Add weight to products.

ALTER TABLE products
ADD COLUMN weight_grams INTEGER;


-- 3. Add a CHECK constraint.
-- NULL values are allowed.

ALTER TABLE products
ADD CONSTRAINT chk_products_weight
CHECK (weight_grams > 0);


-- 4. Rename stock to quantity_in_stock.

ALTER TABLE products
RENAME COLUMN stock TO quantity_in_stock;


-- The assignment says to change it back afterwards
-- because later weeks still use the name stock.

ALTER TABLE products
RENAME COLUMN quantity_in_stock TO stock;


-- ============================================================
-- EXERCISE 2 - THEORY REVIEW QUESTIONS
-- ============================================================


-- 1. What does SQL stand for?
--
-- Answer:
-- SQL stands for Structured Query Language.
-- It is used to work with relational databases.
-- SQL was designed to look similar to English so that
-- database commands would be easier for people to read
-- and understand.


-- 2. Difference between DDL and DML.
--
-- Answer:
-- DDL means Data Definition Language. It is used to
-- create and change the structure of a database.
-- Examples are CREATE and ALTER.
--
-- DML means Data Manipulation Language. It is used to
-- work with the data inside tables.
-- Examples are INSERT and UPDATE.
-- SELECT and DELETE are also DML commands.


-- 3. Difference between DCL and TCL.
--
-- Answer:
-- DCL means Data Control Language. It is used to manage
-- database permissions. GRANT and REVOKE are examples.
--
-- TCL means Transaction Control Language. It is used to
-- manage transactions. BEGIN, COMMIT and ROLLBACK are
-- examples.
--
-- I would use DCL when managing user permissions and TCL
-- when I need to safely manage a group of database changes.


-- 4. Why must tables be created in a specific order?
--
-- Answer:
-- Tables must be created in dependency order because
-- foreign keys reference other tables.
--
-- The referenced table must exist before the table that
-- contains the foreign key can be created.
--
-- The TrailShop order is:
-- categories
-- customers
-- products
-- product_categories
-- orders
-- order_items


-- 5. Column-level vs table-level constraints.
--
-- Answer:
-- A column-level constraint is written directly after
-- the column data type.
--
-- Example:
-- price NUMERIC(10,2) CHECK (price > 0)
--
-- A table-level constraint is written after the column
-- definitions.
--
-- Table-level constraints are needed when a constraint
-- involves more than one column, such as a composite
-- primary key.


-- 6. DELETE vs TRUNCATE.
--
-- Answer:
-- DELETE can remove specific rows by using a WHERE condition.
--
-- TRUNCATE removes all rows from a table and is normally
-- faster when the whole table needs to be emptied.
--
-- I would use DELETE when I want to remove specific data.
-- I would use TRUNCATE when I want to empty the whole table,
-- for example during testing.


-- 7. What does ON DELETE CASCADE do?
--
-- Answer:
-- ON DELETE CASCADE automatically deletes related child rows
-- when the parent row is deleted.
--
-- It is useful for order_items because if an order is deleted,
-- its order items should also be deleted.
--
-- It can be dangerous for important historical information
-- because deleting one parent row could delete many related
-- records automatically.


-- 8. Why store unit_price in order_items?
--
-- Answer:
-- The price of a product can change later.
-- unit_price stores the price that the customer actually paid
-- when the order was created.
--
-- For example, if a product costs 100 euros today but the
-- customer bought it for 80 euros, the old order should still
-- show 80 euros.


-- 9. SERIAL vs GENERATED ALWAYS AS IDENTITY.
--
-- Answer:
-- SERIAL is a PostgreSQL way of creating an auto-incrementing
-- integer.
--
-- GENERATED ALWAYS AS IDENTITY is the newer SQL standard way
-- to create automatically generated numbers.
--
-- For a new project I would prefer GENERATED ALWAYS AS IDENTITY
-- because it follows the SQL standard and is safer.
--
-- However, this course uses SERIAL in the TrailShop examples,
-- so I used SERIAL here.


-- 10. Why is UPDATE without WHERE dangerous?
--
-- Answer:
-- The following statement is dangerous:
--
-- UPDATE products SET price = 9.99;
--
-- It changes the price of every product because there is
-- no WHERE condition.
--
-- Before running UPDATE, I should first use SELECT with the
-- same WHERE condition to check which rows will be affected.
-- For important changes, I can also use BEGIN, COMMIT and
-- ROLLBACK.


-- ============================================================
-- EXERCISE 3 - OPTIONAL SQL PRACTICE
-- ============================================================


-- 3.1 CREATE TABLE - suppliers

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL UNIQUE,
    contact_name VARCHAR(150),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    country VARCHAR(100) NOT NULL DEFAULT 'Finland'
);


-- 3.2 CREATE TABLE - product_reviews

CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,

    product_id INTEGER NOT NULL
        REFERENCES products(product_id),

    customer_id INTEGER NOT NULL
        REFERENCES customers(customer_id),

    rating INTEGER NOT NULL
        CHECK (rating BETWEEN 1 AND 5),

    review_text TEXT,

    created_at TIMESTAMPTZ NOT NULL
        DEFAULT CURRENT_TIMESTAMP
);


-- 3.3 INSERT - Single Row

INSERT INTO categories (name, description)
VALUES (
    'Electronics',
    'GPS devices, solar chargers, and tech gear'
);


-- 3.4 INSERT - Multiple Rows

INSERT INTO customers (first_name, last_name, email)
VALUES
('Eero', 'Lahtinen', 'eero.l@email.com'),
('Maria', 'Salminen', 'maria.s@email.com'),
('Petri', 'Kallio', 'petri.k@email.com');


-- 3.5 INSERT with RETURNING

INSERT INTO products (name, price, stock)
VALUES ('NorthStar GPS', 229.99, 12)
RETURNING product_id, created_at;


-- The Electronics category is category #6
-- because it was added after the original five categories.

INSERT INTO product_categories (product_id, category_id)
VALUES (
    (SELECT product_id
     FROM products
     WHERE name = 'NorthStar GPS'),
    6
);


-- 3.6 UPDATE - Simple

UPDATE customers
SET email = 'mikko.korhonen@newmail.com'
WHERE customer_id = 2;


-- 3.7 UPDATE - Expression

UPDATE products
SET stock = stock - 1
WHERE stock > 0;


-- 3.8 UPDATE - Multiple Columns

-- The assignment says to assume cancelled_at already exists.
-- We add it here so the example can be tested.

ALTER TABLE orders
ADD COLUMN cancelled_at TIMESTAMPTZ;


UPDATE orders
SET status = 'cancelled',
    cancelled_at = CURRENT_TIMESTAMP
WHERE order_id = 3;


-- 3.9 DELETE - With Condition

DELETE FROM orders
WHERE status = 'cancelled';


-- 3.10 ALTER TABLE

-- a) Add discount_percent

ALTER TABLE products
ADD COLUMN discount_percent NUMERIC(5,2)
DEFAULT 0
CHECK (discount_percent >= 0 AND discount_percent <= 100);


-- b) Remove description from categories

ALTER TABLE categories
DROP COLUMN description;


-- c) Prevent a customer from reviewing the same product twice

ALTER TABLE product_reviews
ADD CONSTRAINT unique_customer_product_review
UNIQUE (customer_id, product_id);


-- ============================================================
-- EXERCISE 4 - ERROR DIAGNOSIS
-- ============================================================


-- ------------------------------------------------------------
-- 4.1
-- ------------------------------------------------------------

-- Error:
-- The opening parenthesis after the table name is missing.
--
-- Correct SQL:

CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);


-- ------------------------------------------------------------
-- 4.2
-- ------------------------------------------------------------

-- Error:
-- Text values must use single quotes.
-- Double quotes are used for identifiers.
--
-- Correct SQL:

INSERT INTO products (name, price, stock)
VALUES ('Alpine Sleeping Bag', 89.99, 20);


-- ------------------------------------------------------------
-- 4.3
-- ------------------------------------------------------------

-- Error:
-- A comma is missing after the order_id foreign key.
--
-- Correct SQL:

CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    shipped_date DATE NOT NULL,
    carrier VARCHAR(100)
);


-- ------------------------------------------------------------
-- 4.4
-- ------------------------------------------------------------

-- Error:
-- UPDATE should use only one SET keyword.
-- Multiple columns are separated with commas.
--
-- Correct SQL:

UPDATE products
SET price = price * 0.9,
    stock = stock + 10
WHERE product_id = 3;


-- ------------------------------------------------------------
-- 4.5
-- ------------------------------------------------------------

-- Error:
-- The table has two PRIMARY KEY definitions.
-- A table can have only one primary key.
--
-- Correct SQL:

CREATE TABLE wishlists (
    wishlist_id SERIAL,
    customer_id INTEGER NOT NULL
        REFERENCES customers(customer_id),

    product_id INTEGER NOT NULL
        REFERENCES products(product_id),

    added_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (customer_id, product_id)
);


-- ============================================================
-- END OF WEEK 40
-- ============================================================
