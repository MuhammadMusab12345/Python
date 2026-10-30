-- ============================================================
--  ASSIGNMENT 01 — Querying, Sorting & Filtering
--  Database : BikeStores
--  Topics   : SELECT, WHERE, ORDER BY, TOP/OFFSET-FETCH,
--             DISTINCT, AND / OR
-- ============================================================

USE BikeStores;
GO


-- ============================================================
--  Question 1 — SELECT & WHERE
--  Retrieve the first name, last name, city, and phone number
--  of all customers who live in the state of 'CA' (California)
--  and have a phone number on record.
-- ============================================================

-- Write your query below:

SELECT
    first_name,
    last_name,
    city,
    phone
FROM sales.customers
WHERE state = 'CA'
  AND phone IS NOT NULL;   -- "has a phone number on record"




-- ============================================================
--  Question 2 — ORDER BY (Multiple Columns)
--  Fetch the product_id, product_name, model_year, and
--  list_price of all products.
--  Sort the results by model_year in descending order, and
--  within the same year sort by list_price in ascending order.
-- ============================================================

-- Write your query below:

SELECT
    product_id,
    product_name,
    model_year,
    list_price
FROM production.products
ORDER BY
    model_year DESC,   -- newest year first
    list_price ASC;    -- within the same year, cheapest first




-- ============================================================
--  Question 3 — TOP N & TOP PERCENT
--  a) Return the top 5 most expensive products showing only
--     product_name and list_price.
--  b) Return the top 5% of cheapest products (all columns).
--     How many rows does the 5% result return? Add the row
--     count as a comment in your answer.
-- ============================================================

-- Part a:

SELECT TOP 5
    product_name,
    list_price
FROM production.products
ORDER BY list_price DESC;   -- most expensive first


-- Part b:

SELECT TOP 5 PERCENT *
FROM production.products
ORDER BY list_price ASC;    -- cheapest first

-- Row count: 17 rows
-- Explanation: the products table has 321 rows. 5% of 321 = 16.05,
-- and TOP PERCENT always rounds UP to the next whole row, so 17 rows
-- are returned. (Verify by running:  SELECT COUNT(*) FROM production.products;)




-- ============================================================
--  Question 4 — OFFSET & FETCH (Pagination)
--  The sales team wants to browse products page by page,
--  10 products per page, sorted by list_price descending.
--  Write queries to return:
--    a) Page 1  (rows  1 – 10)
--    b) Page 2  (rows 11 – 20)
--    c) Page 3  (rows 21 – 30)
-- ============================================================

-- Note: product_id is added as a second sort column so that products
-- with the same price always come in the same order on every page.

-- Page 1:

SELECT
    product_id,
    product_name,
    list_price
FROM production.products
ORDER BY list_price DESC, product_id
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;


-- Page 2:

SELECT
    product_id,
    product_name,
    list_price
FROM production.products
ORDER BY list_price DESC, product_id
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


-- Page 3:

SELECT
    product_id,
    product_name,
    list_price
FROM production.products
ORDER BY list_price DESC, product_id
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;




-- ============================================================
--  Question 5 — DISTINCT
--  a) List all unique states in which BikeStores has customers.
--     Sort the result alphabetically.
--  b) List every unique combination of state and city,
--     sorted by state then city (both ascending).
--  c) How many unique model years exist in the products table?
--     (Retrieve the distinct values; count them manually or
--     use COUNT — your choice.)
-- ============================================================

-- Part a:

SELECT DISTINCT state
FROM sales.customers
ORDER BY state ASC;


-- Part b:

SELECT DISTINCT
    state,
    city
FROM sales.customers
ORDER BY
    state ASC,
    city ASC;


-- Part c:

-- Distinct values:
SELECT DISTINCT model_year
FROM production.products
ORDER BY model_year;

-- Count of distinct values:
SELECT COUNT(DISTINCT model_year) AS unique_model_years
FROM production.products;




-- ============================================================
--  Question 6 — Logical Operators (AND / OR)
--  Write a single query that returns the product_id,
--  product_name, brand_id, category_id, and list_price for
--  products that meet ALL of the following conditions:
--    • list_price is between $500 and $1500 (inclusive)
--    • model_year is 2019 OR 2020
--  Sort the results by list_price ascending.
--  Hint: use parentheses to control the order of evaluation.
-- ============================================================

-- Write your query below:

SELECT
    product_id,
    product_name,
    brand_id,
    category_id,
    list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500        -- BETWEEN is inclusive
  AND (model_year = 2019 OR model_year = 2020)  -- parentheses so OR is evaluated first
ORDER BY list_price ASC;
