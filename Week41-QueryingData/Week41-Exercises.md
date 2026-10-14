# Week 41: Querying Data

**Course:** Databases  
**Project:** TrailShop  
**Topics:** SELECT, WHERE, JOINs, Aggregate Functions, GROUP BY and HAVING

## Exercise 1: TrailShop Project Task

### Basic Queries (SELECT + WHERE)

### Question 1: List all products in the Footwear category

```sql
-- Select product name, price and stock.
-- Join the tables to find products in the Footwear category.

SELECT p.name, p.price, p.stock
FROM products p
JOIN product_categories pc
    ON p.product_id = pc.product_id
JOIN categories c
    ON pc.category_id = c.category_id
WHERE c.name = 'Footwear';
```

**Explanation:** The products table contains product information. The product_categories table connects products to categories, and the categories table contains category names. The WHERE clause selects only products in the Footwear category.

### Question 2: Find products priced between €50 and €150, sorted by price ascending

```sql
-- BETWEEN includes both the minimum and maximum values.
-- ASC sorts from lowest price to highest price.

SELECT name, price
FROM products
WHERE price BETWEEN 50 AND 150
ORDER BY price ASC;
```

**Explanation:** BETWEEN selects products costing at least €50 and at most €150. ORDER BY price ASC displays the cheapest products first.

### Question 3: Show customers whose last name starts with M or K

```sql
-- ILIKE performs a case-insensitive text search.
-- The percent sign matches any sequence of characters.

SELECT first_name, last_name
FROM customers
WHERE last_name ILIKE 'M%'
   OR last_name ILIKE 'K%';
```

**Explanation:** The query finds customers whose last name starts with either M or K. The OR operator means that either condition can be true.

### Question 4: List pending or shipped orders, newest first

```sql
-- IN checks whether a value matches one of the listed values.
-- DESC sorts the most recent orders first.

SELECT *
FROM orders
WHERE status IN ('pending', 'shipped')
ORDER BY order_date DESC;
```

**Explanation:** The query returns orders with a status of pending or shipped. The results are sorted by order date from newest to oldest.

### Question 5: Find products containing Pro or pro in their name

```sql
-- ILIKE ignores uppercase and lowercase differences.
-- Percent signs allow characters before and after the word.

SELECT name, price, stock
FROM products
WHERE name ILIKE '%pro%';
```

**Explanation:** The query finds product names containing the letters pro anywhere in the name, regardless of capitalization.

## Aggregate Queries

### Question 6: Count all products in the database

```sql
-- COUNT(*) counts all rows in the products table.

SELECT COUNT(*) AS total_products
FROM products;
```

**Explanation:** COUNT(*) returns the total number of product records. AS total_products gives the result a readable column name.

### Question 7: Calculate the average price of all products

```sql
-- AVG calculates the average.
-- ROUND limits the result to two decimal places.

SELECT ROUND(AVG(price), 2) AS average_price
FROM products;
```

**Explanation:** AVG(price) adds the product prices and calculates their average. ROUND(..., 2) displays the result to two decimal places.

### Question 8: Find the cheapest and most expensive products

```sql
-- First, find the minimum and maximum prices.
-- Then return products matching either price.

WITH price_limits AS (
    SELECT MIN(price) AS cheapest_price,
           MAX(price) AS highest_price
    FROM products
)
SELECT p.name,
       p.price,
       CASE
           WHEN p.price = pl.cheapest_price
               THEN 'Cheapest'
           WHEN p.price = pl.highest_price
               THEN 'Most expensive'
       END AS price_category
FROM products p
CROSS JOIN price_limits pl
WHERE p.price = pl.cheapest_price
   OR p.price = pl.highest_price
ORDER BY p.price ASC;
```

**Explanation:** MIN finds the lowest price and MAX finds the highest price. The query then displays the products that match those prices. If several products share the same minimum or maximum price, all matching products are returned.

### Question 9: Count orders for each customer

```sql
-- LEFT JOIN includes customers who have no orders.
-- COUNT(o.order_id) counts only matching orders.

SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC;
```

**Explanation:** The query joins customers with their orders and groups the results by customer. COUNT calculates each customer's order count. Customers without orders are included with a count of zero.

### Question 10: Calculate total revenue for each order status

```sql
-- Calculate revenue for each item using quantity * unit_price.
-- SUM adds the item revenue for each order status.

SELECT o.status,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY total_revenue DESC;
```

**Explanation:** The query joins orders with order_items. It multiplies each item's quantity by its unit price, adds the amounts together for each status, and displays the highest revenue first. Only statuses with matching order items appear.

## JOIN Queries

### Question 11: List all products with their category names

```sql
-- Join products to product_categories and categories.
-- Sort by category name and then product name.

SELECT p.name AS product_name,
       c.name AS category_name
FROM products p
JOIN product_categories pc
    ON p.product_id = pc.product_id
JOIN categories c
    ON pc.category_id = c.category_id
ORDER BY category_name ASC, product_name ASC;
```

**Explanation:** The joins connect products to their category names. A product belonging to two categories appears twice, once for each category.

### Question 12: Show orders with customer name, date and status

```sql
-- Combine the first and last names into one column.

SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer,
       o.order_date,
       o.status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;
```

**Explanation:** Each order contains a customer ID. The JOIN connects that ID to the customers table so the query can display the customer's full name alongside the order details.

### Question 13: Show the details of order number 1

```sql
-- Calculate the total price for each order item.

SELECT p.name AS product_name,
       oi.quantity,
       oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE oi.order_id = 1;
```

**Explanation:** The query finds items belonging to order number 1. It displays the product name, quantity, unit price and line total. The line total is quantity multiplied by unit price.

### Question 14: Find customers who have never placed an order

```sql
-- LEFT JOIN keeps all customers.
-- IS NULL identifies customers without a matching order.

SELECT c.first_name,
       c.last_name,
       c.email
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

**Explanation:** LEFT JOIN keeps every customer, even when no order exists. For customers without an order, o.order_id is NULL. The WHERE condition selects only those customers.

### Question 15: Show category statistics where inventory value exceeds €500

```sql
-- COUNT(DISTINCT ...) counts unique products.
-- AVG calculates the average price.
-- SUM calculates the total inventory value.
-- HAVING filters the grouped results.

SELECT c.name AS category_name,
       COUNT(DISTINCT p.product_id) AS product_count,
       ROUND(AVG(p.price), 2) AS average_price,
       SUM(p.price * p.stock) AS total_inventory_value
FROM categories c
JOIN product_categories pc
    ON c.category_id = pc.category_id
JOIN products p
    ON pc.product_id = p.product_id
GROUP BY c.category_id, c.name
HAVING SUM(p.price * p.stock) > 500
ORDER BY total_inventory_value DESC;
```

**Explanation:** The query groups products by category. It counts products, calculates their average price, and adds their inventory values. HAVING keeps only categories with an inventory value greater than €500.

**Note:** This calculation assumes a product is assigned to a category only once. Products assigned to multiple categories contribute to each category's inventory value.

---

## Exercise 2: Theory Review Questions

### Question 1: What is the logical execution order of a SQL query? Why does it matter?

The logical execution order is:

1. FROM and JOIN
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. DISTINCT
7. ORDER BY
8. LIMIT and OFFSET

This order matters because SQL processes clauses in a different order from how we write them. For example, WHERE is processed before SELECT, so a column alias created in SELECT cannot normally be used in WHERE.

### Question 2: What is the difference between WHERE and HAVING?

WHERE filters individual rows before grouping. HAVING filters groups after GROUP BY.

For example, WHERE price > 100 selects products costing more than €100. HAVING COUNT(*) > 2 selects groups containing more than two rows.

### Question 3: Explain COUNT(*), COUNT(column), and COUNT(DISTINCT column).

COUNT(*) counts all rows, including rows with NULL values.

COUNT(column) counts rows where the specified column is not NULL.

COUNT(DISTINCT column) counts unique, non-NULL values in the column.

These functions are useful when we need to count all records, records with available values, or unique values.

### Question 4: What is the difference between INNER JOIN and LEFT JOIN?

INNER JOIN returns only rows with matching values in both tables.

LEFT JOIN returns all rows from the left table and matching rows from the right table. If no matching row exists, the right table's columns contain NULL.

I would use INNER JOIN when I only need matching records. I would use LEFT JOIN when I also need records without a match, such as customers who have never placed an order.

### Question 5: Why should we avoid SELECT * in production code?

SELECT * returns all columns from a table. Some columns may not be needed, which can transfer unnecessary data and make queries harder to understand.

It can also make the query output change when the table structure changes. Selecting only the required columns makes the query clearer and easier to maintain.

### Question 6: What does DISTINCT do? Does it operate on columns or entire rows?

DISTINCT removes duplicate rows from the query result. It operates on the complete combination of selected columns.

For example, SELECT DISTINCT status FROM orders returns each unique order status once. If multiple columns are selected, duplicate combinations across all selected columns are removed.

### Question 7: Can we use a column alias in a WHERE clause? Why or why not?

Normally, we cannot use a SELECT column alias in WHERE because WHERE is processed before SELECT creates the alias.

For example, if we create the alias price_with_vat, we should use the original expression in WHERE:

```sql
SELECT name, price * 1.24 AS price_with_vat
FROM products
WHERE price * 1.24 > 100;
```

### Question 8: What happens if a selected column is neither aggregated nor included in GROUP BY?

PostgreSQL normally returns an error because it cannot determine which value of that column should represent each group.

Every selected column must either appear in GROUP BY or be used in an aggregate function, subject to PostgreSQL's grouping rules.

For example, when grouping products by category, we can calculate COUNT(*) for each category. However, selecting an individual product name without grouping or aggregating it is normally invalid because a category can contain several products.

---

## Final Checklist

Before submitting the assignment:

1. Run all 15 SQL queries in your own TrailShop database.
2. Check that the queries execute without errors and that their results make sense.
3. Review the eight theory answers and make sure you understand them.
4. Save the completed file in your GitHub repository.
5. Submit the direct link to your Week 41 assignment file.

**Lecture attendance:** You must also demonstrate that the first five basic queries work in your database to receive the attendance mark.

**Optional practice:** Exercises 3 and 4 are recommended for additional practice and exam preparation. They are not listed as required in the submission checklist.
