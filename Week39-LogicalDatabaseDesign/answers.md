# Week 39 Exercises

## Exercise 1: TrailShop Project Task

### Data Type Justifications

1. **NUMERIC(10,2) for price**

I used NUMERIC(10,2) for price because money needs exact decimal values. It avoids rounding problems that can happen with REAL or DOUBLE PRECISION.

2. **INTEGER for stock quantity**

I used INTEGER for stock quantity because the number of products must be a whole number. I also used a CHECK constraint so the stock quantity cannot be negative.

3. **TIMESTAMPTZ for dates**

I used TIMESTAMPTZ for dates and times because it supports timezone information. This is useful when users are in different time zones.

### Foreign Key Actions

1. **product_categories.product_id → products.product_id**

I used ON DELETE CASCADE because the link between a product and a category is not needed if the product is deleted.

2. **product_categories.category_id → categories.category_id**

I used ON DELETE CASCADE because the link is not needed if the category is deleted.

3. **orders.customer_id → customers.customer_id**

I used ON DELETE RESTRICT because a customer should not be deleted if they have existing orders. Order history should be kept.

4. **order_items.order_id → orders.order_id**

I used ON DELETE CASCADE because order items belong to an order. If the order is deleted, its items should also be deleted.

5. **order_items.product_id → products.product_id**

I used ON DELETE RESTRICT because a product should not be deleted if it is part of an existing order history.

### Design Decision

I decided to make the shipping address fields optional. The customer's normal address can be used as the default shipping address, but a different shipping address can be stored when needed.
## Exercise 2: Theory Review

### 1. Database Development Lifecycle

The seven phases are Requirements Gathering, Conceptual Design, Logical Design, Physical Design, Implementation, Testing & Validation, and Maintenance & Evolution. This week's focus is Logical Design, where the ER model is transformed into a relational schema with tables, data types, keys, and constraints.
### 2. One-to-Many Relationship

For a 1:N relationship, the primary key of the "one" side is added as a foreign key to the "many" side. The foreign key is placed on the many side because each row there needs to refer to one row on the one side, while one row on the one side can be related to many rows.

### 3. Junction Table

A junction table is a table used to resolve a many-to-many relationship between two entities. It contains foreign keys to both tables. For example, in a university database, a student can take many courses and a course can have many students, so an `enrollments` table could connect students and courses.

### 4. One-to-One Relationship

For a 1:1 relationship, the foreign key can be placed in either table depending on the participation of the entities. If one side is mandatory and the other is optional, the foreign key is normally placed on the mandatory side. A UNIQUE constraint is used on the foreign key to make sure that each row can have only one related row.

### 5. Weak Entity

A weak entity depends on another entity and cannot exist independently. Its table contains the owner's primary key as a foreign key, and the owner's key becomes part of the weak entity's composite primary key. This identifies the weak entity together with its owner.

### 6. REAL and DOUBLE PRECISION for Money

REAL and DOUBLE PRECISION should not be used for monetary values because floating-point numbers can cause rounding and precision problems. NUMERIC(10,2) should be used instead because it stores exact decimal values.

### 7. TIMESTAMP and TIMESTAMPTZ

TIMESTAMP stores a date and time without timezone information, while TIMESTAMPTZ stores a date and time with timezone handling. TIMESTAMPTZ is preferred because it helps avoid timezone problems when users are in different time zones.

### 8. CASCADE and RESTRICT

CASCADE automatically deletes related child rows when the parent row is deleted. RESTRICT prevents the parent row from being deleted when related child rows exist. For example, CASCADE is suitable for deleting order items when an order is deleted, while RESTRICT is suitable for preventing deletion of a product that appears in order history.

### 9. Insertion Anomaly

An insertion anomaly happens when you cannot add some information without also adding unrelated information. For example, if products and categories were stored in one table, you could not add a new category unless you also added a product. Separating categories and products into different tables prevents this problem.

### 10. Surrogate Key and Natural Key

A surrogate key is a system-generated identifier that has no business meaning, such as a SERIAL integer. A natural key has real-world meaning, such as an email address. A surrogate key is useful because it is stable and simple, while a natural key can directly represent a real-world identifier.

### 11. PostgreSQL Identifiers and snake_case

PostgreSQL converts unquoted identifiers to lowercase. Using snake_case, such as `order_items` and `customer_id`, keeps names simple and consistent without needing quotation marks. It also makes the database easier to read and maintain.

### 12. SET NULL

SET NULL changes the foreign key value to NULL when the referenced parent row is deleted. It is useful when the child row should remain in the database but should no longer be connected to the deleted parent. The foreign key column must allow NULL values.
All foreign keys use ON UPDATE CASCADE because if a referenced primary key changes, the related foreign key values are updated automatically.
## Exercise 3: Hotel Booking System

### Why is Room a weak entity?

Room is a weak entity because a room belongs to a hotel. The room number alone cannot identify a room because different hotels can have the same room number. Therefore, the primary key uses both hotel_id and room_number.
