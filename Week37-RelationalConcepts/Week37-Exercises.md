# Week 37 — Exercises & Project Task

## Part 1: TrailShop Project Task

### Task 1: Identify Keys

#### 1. What is the primary key of the `products` table? Why is it a good choice?

The primary key of the `products` table is `product_id`. It is a good choice because it uniquely identifies each product, cannot be NULL, and is stable.

#### 2. What is the primary key of the `categories` table?

The primary key of the `categories` table is `category_id`. It uniquely identifies each category.

#### 3. What is the foreign key in the `products` table? What does it reference?

The foreign key in the `products` table is `category_id`. It references `category_id` in the `categories` table. This connects each product to its category and ensures that the category exists.

#### 4. Is `name` in `products` a candidate key? Under what assumption? What would make it unsuitable as a primary key?

Yes, `name` can be a candidate key if every product name is unique. It would be unsuitable as a primary key if two products could have the same name or if product names could change. A primary key should be stable and reliably identify a product.

#### 5. Give an example of a superkey for the `products` table that is NOT a candidate key. Explain why it's not minimal.

`{product_id, name}` is an example of a superkey. It uniquely identifies each product because `product_id` is already unique. However, it is not a candidate key because `name` is unnecessary. `product_id` alone is enough, so the combination is not minimal.

#### 6. Give an example of a composite key using a hypothetical `order_items` table. Explain why neither column alone would be sufficient.

A composite key could be `(order_id, product_id)`. `order_id` alone is not unique because one order can contain multiple products. `product_id` alone is also not unique because the same product can appear in different orders. Together, `(order_id, product_id)` uniquely identifies each product within an order.

#### 7. Is `email` in `customers` a candidate key? What makes it different from `customer_id` as a PK choice?

Yes, `email` can be a candidate key if every customer's email address is unique. However, `customer_id` is a surrogate key and is a better choice for the primary key because it does not have business meaning and should remain stable. Email is a natural key and may change if a customer changes their email address.
## Task 2: Define Business Rules

| Business Rule | Constraint Type | Table.Column | SQL |
|---|---|---|---|
| Every product must have a name. | NOT NULL | products.name | `name VARCHAR(100) NOT NULL` |
| Product price must be greater than zero. | CHECK | products.price | `CHECK (price > 0)` |
| Category names must be unique. | UNIQUE | categories.category_name | `category_name VARCHAR(50) UNIQUE` |
| Stock quantity cannot be negative. | CHECK | products.stock_quantity | `CHECK (stock_quantity >= 0)` |
| Every product must belong to an existing category. | NOT NULL + FOREIGN KEY | products.category_id | `category_id INTEGER NOT NULL REFERENCES categories(category_id)` |
## Task 3: Integrity Violations

### Statement A

**FAIL**

The statement fails because `category_id` is the primary key of the `categories` table, and a primary key cannot be NULL. This violates entity integrity.
### Statement B

**SUCCESS**

The statement succeeds because product 109 has a unique product ID, a valid name, a positive price, and category 2 exists.
### Statement C

**FAIL**

The statement fails because the price is `-5.00`. The `price` column has a CHECK constraint that requires the price to be greater than zero.
### Statement D

**FAIL**

The statement fails because `product_id` 103 already exists in the `products` table. Since `product_id` is the primary key, it must be unique.
### Statement E

**FAIL**

The statement fails because `category_id` 10 does not exist in the `categories` table. This violates referential integrity because the foreign key must reference an existing category.
### Statement F

**FAIL**

The statement fails because the product name is NULL. The `name` column has a NOT NULL constraint, so every product must have a name.
### Statement G

**FAIL**

The statement fails because the stock quantity is `-3`. The `stock_quantity` column has a CHECK constraint that does not allow negative values.

### Statement H

**FAIL**

The statement fails because the quantity is `0`. The `quantity` column has a CHECK constraint that requires the quantity to be greater than zero.
## Task 4: Foreign Key Actions

### 1. ON DELETE RESTRICT

The deletion will fail. Category 2 cannot be deleted because products 102 and 106 still use this category.

### 2. ON DELETE CASCADE

The deletion will succeed. Category 2 will be deleted, and products 102 and 106 will also be deleted because they use category 2.

### 3. ON DELETE SET NULL

The deletion will succeed. Category 2 will be deleted, and the `category_id` of products 102 and 106 will be changed to NULL.

### Recommended Action

I would use `ON DELETE RESTRICT` for the TrailShop `products.category_id` relationship. It prevents a category from being deleted while products still use it, so product records are not accidentally deleted. This keeps the product data safe.
## Part 2: Theory Review Questions

### Q1. Relation, Tuple, Attribute, Domain

A relation is a table in a database. For example, the `products` table is a relation.

A tuple is one row in a table. For example, one row containing a product such as `Alpine Pro Hiking Boots` is a tuple.

An attribute is a column in a table. For example, `price` in the `products` table is an attribute.

A domain is the set of allowed values for an attribute. For example, the domain of `price` can be positive numbers.
### Q2. Candidate Key and Primary Key

A candidate key is a column or group of columns that can uniquely identify each row and is minimal. A primary key is the candidate key chosen as the main key for the table. Yes, a table can have more than one candidate key, but only one is chosen as the primary key.

### Q3. Entity Integrity

Entity integrity means that every table must have a primary key and the primary key cannot be NULL. A primary key is used to identify each row, so if it were NULL, the row could not be reliably identified.

### Q4. Referential Integrity

Referential integrity means that a foreign key must refer to an existing primary key in another table, or be NULL if NULL is allowed. For example, this statement would fail if category 99 does not exist:

```sql
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (109, 'Ghost Product', 59.99, 5, 99);
### Q5. Surrogate Key and Natural Key

A surrogate key is an artificial key created by the database and has no business meaning. For example, `book_id` can be a surrogate key in a `books` table. A natural key comes from real-world data, such as an ISBN, so `ISBN` can be a natural key.

### Q6. NULL Value

NULL means that a value is unknown or not available. `WHERE price = NULL` is wrong because NULL cannot be compared using `=`. We should use `WHERE price IS NULL` instead.

### Q7. Junction Table

A junction table is a table used to connect two tables in a many-to-many relationship. For example, an `order_items` table can connect `orders` and `products` because one order can contain many products and one product can appear in many orders.

### Q8. Types of Relationships

A 1:1 relationship means one row in one table is connected to one row in another table. A 1:N relationship means one row can be connected to many rows, such as one category having many products. An M:N relationship means many rows can be connected to many rows, such as orders and products through the `order_items` table.

### Q9. ON DELETE CASCADE and ON DELETE RESTRICT

`ON DELETE CASCADE` deletes related rows when the referenced row is deleted. It can be used when related records should also be removed. `ON DELETE RESTRICT` prevents the referenced row from being deleted while related rows still exist.

### Q10. Atomic Entries

Atomic entries mean that each cell in a table should contain one single value, not a list of values. For example, storing `Football, Cricket, Badminton` in one `hobbies` column would violate the atomic entry rule.

## True/False

### 1. A superkey is always a candidate key.

**False.**

A superkey is not always a candidate key because it may contain unnecessary attributes. A candidate key must be minimal.

### 2. A primary key can consist of more than one column.

**True.**

A primary key can be a composite key made from two or more columns.

### 3. NULL = NULL evaluates to TRUE in SQL.

**False.**

`NULL = NULL` does not evaluate to TRUE. NULL represents an unknown or missing value. We should use `IS NULL` to check for NULL.

### 4. A foreign key must always be NOT NULL.

**False.**

A foreign key can be NULL if the database design allows it.

### 5. Referential integrity ensures that every FK value matches an existing PK value (or is NULL).

**True.**

A foreign key must match an existing primary key value, or it can be NULL when NULL values are allowed.

### 6. The degree of a relation is the number of rows.

**False.**

The degree of a relation is the number of columns. The number of rows is called the cardinality.

## Matching Exercise

| # | Your Match |
|---|---|
| 1 | F |
| 2 | G |
| 3 | B |
| 4 | H |
| 5 | E |
| 6 | D |
| 7 | J |
| 8 | C |
| 9 | A |
| 10 | K |
| 11 | I |
| 12 | L |
### Exercise 3.1

1. **SUCCESS**

2. **FAIL** — The salary violates the `CHECK (salary >= 0)` constraint.

3. **FAIL** — Employee ID 100 already exists, so it violates the primary key constraint.

4. **FAIL** — Department 5 does not exist, so it violates the foreign key constraint.

5. **FAIL** — `Engineering` already exists, so it violates the UNIQUE constraint.

6. **FAIL** — The employee name cannot be NULL because of the NOT NULL constraint.

7. **FAIL** — Department 1 is referenced by employees, so the foreign key constraint prevents deletion.

8. **SUCCESS**

### Exercise 3.2

```sql
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    isbn CHAR(13) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    publication_year INTEGER NOT NULL,
    CHECK (publication_year BETWEEN 1450 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id)
);

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

CREATE TABLE book_authors (
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    author_id INTEGER NOT NULL REFERENCES authors(author_id),
    PRIMARY KEY (book_id, author_id)
);
## Part 4: Design Exercise — Library System

### 1. Tables and Columns

The system needs these tables:

- `books`: ISBN, title, publication year, genre
- `copies`: barcode, book
- `members`: member number, name, email, phone
- `borrowings`: member, copy, borrow date, due date, return date

### 2. Primary Keys

- `books`: `isbn` — natural key because ISBN identifies a book.
- `copies`: `barcode` — natural key because each physical copy has a unique barcode.
- `members`: `member_number` — natural key because it identifies each member.
- `borrowings`: `borrowing_id` — surrogate key because each borrowing record needs a unique identifier.

### 3. Foreign Keys

- `copies.book_isbn` references `books.isbn`
- `borrowings.member_number` references `members.member_number`
- `borrowings.barcode` references `copies.barcode`

### 4. Candidate Keys

Possible candidate keys are:

- `books.isbn`
- `copies.barcode`
- `members.member_number`
- `members.email`

### 5. Business Rules

| Business Rule | Constraint Type |
|---|---|
| ISBN must be unique and not NULL | PRIMARY KEY / UNIQUE |
| Every book must have a title | NOT NULL |
| Every book must have a genre | FOREIGN KEY + NOT NULL |
| Every copy must have a unique barcode | PRIMARY KEY / UNIQUE |
| Member email should be unique | UNIQUE |
| Return date can be NULL when a book has not been returned | NULL allowed |
| Due date must be 14 days after borrow date | CHECK constraint |
| A member can borrow at most 5 copies at a time | Cannot be enforced by a simple column constraint |
| A copy cannot have more than one active borrowing | Cannot be enforced by a simple column constraint |

### 6. SQL Tables

```sql
CREATE TABLE books (
    isbn CHAR(13) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publication_year INTEGER NOT NULL,
    genre VARCHAR(100) NOT NULL
);

CREATE TABLE copies (
    barcode VARCHAR(50) PRIMARY KEY,
    book_isbn CHAR(13) NOT NULL REFERENCES books(isbn)
);

CREATE TABLE members (
    member_number INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(30)
);

CREATE TABLE borrowings (
    borrowing_id SERIAL PRIMARY KEY,
    member_number INTEGER NOT NULL REFERENCES members(member_number),
    barcode VARCHAR(50) NOT NULL REFERENCES copies(barcode),
CREATE UNIQUE INDEX one_active_borrowing_per_copy
ON borrowings(barcode)
WHERE return_date IS NULL;
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    CHECK (due_date = borrow_date + INTERVAL '14 days')
);
