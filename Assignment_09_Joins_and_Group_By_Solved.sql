-- ============================================================
--  ASSIGNMENT 09 — Joins & Group By
--  Database : BikeStores
--  Topics   : INNER / LEFT / RIGHT / FULL OUTER JOIN,
--             multi-table joins, aggregate functions,
--             GROUP BY, HAVING
-- ============================================================

USE BikeStores;
GO


-- ============================================================
--  Question 1 — INNER JOIN
--  Return the product_name, brand_name, and list_price of all
--  products by joining production.products with
--  production.brands.
--  Sort the results by brand_name ascending, then list_price
--  descending.
-- ============================================================

-- Write your query below:

SELECT
    p.product_name,
    b.brand_name,
    p.list_price
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
ORDER BY
    b.brand_name ASC,
    p.list_price DESC;




-- ============================================================
--  Question 2 — Joining Three Tables
--  Return the product_name, brand_name, category_name, and
--  model_year of every product by joining products, brands and
--  categories.
--  Only include products with a list_price above 1000.
-- ============================================================

-- Write your query below:

SELECT
    p.product_name,
    b.brand_name,
    c.category_name,
    p.model_year
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE p.list_price > 1000;




-- ============================================================
--  Question 3 — LEFT JOIN
--  a) List every customer (first_name, last_name, city) along
--     with the order_id and order_date of their orders.
--     Customers who never placed an order must still appear.
--  b) Modify the query to return ONLY the customers who have
--     never placed an order.
--     Hint: filter on a NULL value from the right-hand table.
-- ============================================================

-- Part a:

SELECT
    c.first_name,
    c.last_name,
    c.city,
    o.order_id,
    o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;      -- LEFT JOIN keeps customers with no orders


-- Part b:

SELECT
    c.first_name,
    c.last_name,
    c.city,
    o.order_id,
    o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;                  -- no matching order = never ordered




-- ============================================================
--  Question 4 — RIGHT JOIN & FULL OUTER JOIN
--  a) Using a RIGHT JOIN, list every store (store_name) with
--     the staff members (first_name, last_name) working there.
--     Join sales.staffs and sales.stores.
--  b) Using a FULL OUTER JOIN between production.products and
--     production.stocks, find the products that have no stock
--     record at all. Return product_name and quantity.
-- ============================================================

-- Part a:

SELECT
    st.store_name,
    sf.first_name,
    sf.last_name
FROM sales.staffs AS sf
RIGHT JOIN sales.stores AS st
    ON sf.store_id = st.store_id;          -- RIGHT JOIN keeps every store


-- Part b:

SELECT
    p.product_name,
    s.quantity
FROM production.products AS p
FULL OUTER JOIN production.stocks AS s
    ON p.product_id = s.product_id
WHERE s.product_id IS NULL;                -- product exists but has no stock row




-- ============================================================
--  Question 5 — Multi-Table Join (Order Details)
--  Build an order-detail report with the following columns:
--    order_id, order_date, customer full name
--    (first_name + last_name), product_name, quantity,
--    and line_total = quantity * order_items.list_price
--                     * (1 - discount)
--  Join sales.orders, sales.customers, sales.order_items and
--  production.products.
--  Sort by order_id, then product_name.
-- ============================================================

-- Write your query below:

SELECT
    o.order_id,
    o.order_date,
    c.first_name + ' ' + c.last_name AS customer_name,
    p.product_name,
    oi.quantity,
    oi.quantity * oi.list_price * (1 - oi.discount) AS line_total
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
ORDER BY
    o.order_id,
    p.product_name;




-- ============================================================
--  Question 6 — Aggregate Functions
--  From production.products, write a single query that returns:
--    • total number of products
--    • lowest, highest and average list_price
--      (round the average to 2 decimals)
--  Give every column a meaningful alias.
-- ============================================================

-- Write your query below:

SELECT
    COUNT(*)                   AS total_products,
    MIN(list_price)            AS lowest_price,
    MAX(list_price)            AS highest_price,
    ROUND(AVG(list_price), 2)  AS average_price
FROM production.products;




-- ============================================================
--  Question 7 — GROUP BY
--  a) Count the number of products in each category. Show
--     category_name and product_count (join with categories),
--     sorted by product_count descending.
--  b) For each brand_name and model_year combination, find the
--     average list_price. Sort by brand_name, then model_year.
-- ============================================================

-- Part a:

SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products AS p
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;


-- Part b:

SELECT
    b.brand_name,
    p.model_year,
    ROUND(AVG(p.list_price), 2) AS avg_list_price
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
GROUP BY
    b.brand_name,
    p.model_year
ORDER BY
    b.brand_name,
    p.model_year;




-- ============================================================
--  Question 8 — GROUP BY with Joins
--  a) Find the total number of orders placed by each customer.
--     Show customer_id, full name and total_orders, sorted by
--     total_orders descending.
--  b) Find the total revenue per store.
--     revenue = SUM(quantity * list_price * (1 - discount))
--     Show store_name and total_revenue, highest first.
--     Join orders, order_items and stores.
-- ============================================================

-- Part a:

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    COUNT(o.order_id)                AS total_orders
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC;


-- Part b:

SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;




-- ============================================================
--  Question 9 — HAVING
--  a) List the brands (brand_name) that have more than 20
--     products.
--  b) List the customers (full name) who have placed 3 or more
--     orders.
--  c) Explain in a comment: what is the difference between
--     WHERE and HAVING?
-- ============================================================

-- Part a:

SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 20;


-- Part b:

SELECT
    c.first_name + ' ' + c.last_name AS full_name,
    COUNT(o.order_id)                AS total_orders
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,        -- grouped by id so two customers with the same name stay separate
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) >= 3;


-- Part c (answer as a comment):

-- WHERE filters individual ROWS BEFORE grouping happens, so it cannot use
-- aggregate functions like COUNT() or SUM().
-- HAVING filters GROUPS AFTER GROUP BY has been applied, so it is used with
-- aggregate functions (e.g. HAVING COUNT(*) > 20).
-- Order of execution: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY.




-- ============================================================
--  Question 10 — Combined Challenge
--  Find the top 5 best-selling products by total quantity sold.
--  Show product_name, category_name, total_quantity_sold and
--  total_revenue.
--  Only count orders that are completed (order_status = 4).
--  Hint: join order_items, orders, products and categories,
--  then use WHERE, GROUP BY, ORDER BY and TOP.
-- ============================================================

-- Write your query below:

SELECT TOP 5
    p.product_name,
    c.category_name,
    SUM(oi.quantity)                                      AS total_quantity_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))  AS total_revenue
FROM sales.order_items AS oi
INNER JOIN sales.orders AS o
    ON oi.order_id = o.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE o.order_status = 4                 -- completed orders only
GROUP BY
    p.product_name,
    c.category_name
ORDER BY total_quantity_sold DESC;
