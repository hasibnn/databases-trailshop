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
