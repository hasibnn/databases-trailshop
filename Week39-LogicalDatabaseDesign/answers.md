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
