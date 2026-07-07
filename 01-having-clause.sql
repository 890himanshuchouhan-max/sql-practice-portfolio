
-- 01-having-clause.sql
-- Topic: HAVING Clause + Nested Subqueries (average-of-grouped-totals pattern)
-- Dataset: E-commerce (orders)

-- Q1: Find total order amount per customer, 
-- showing only customers whose total exceeds 3000

SELECT 
    customer_id,
    SUM(order_amount) AS total_amount
FROM orders
GROUP BY customer_id
HAVING SUM(order_amount) > 3000
ORDER BY total_amount DESC;

-- Insight: HAVING filters groups AFTER aggregation, unlike WHERE 
-- which filters individual rows BEFORE aggregation. This is why 
-- HAVING can reference SUM(), COUNT(), AVG() directly in its 
-- condition, while WHERE cannot.


-- Q2: Find customers whose total order amount is greater than 
-- the average total order amount across all customers

SELECT 
    customer_id, 
    SUM(order_amount) AS total_amount
FROM orders
GROUP BY customer_id
HAVING SUM(order_amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(order_amount) AS total_amount, customer_id
        FROM orders
        GROUP BY customer_id
    ) AS customer_table
);

-- Insight: A common mistake here is comparing against 
-- AVG(order_amount) directly on the orders table — that averages 
-- individual order lines, not each customer's total. To get the 
-- true "average of totals," the subquery must first GROUP BY and 
-- SUM(), then average THAT result — hence the nested subquery.


-- Q3: Find customers whose total order amount is LESS than 
-- the average total order amount across all customers

SELECT 
    SUM(order_amount) AS total_amount, 
    customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(order_amount) < (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(order_amount) AS total_amount, customer_id
        FROM orders
        GROUP BY customer_id
    ) AS customer_table
);

-- Insight: Same nested pattern as Q2, just flipping the comparison 
-- operator. Useful for identifying below-average / underperforming 
-- customers, e.g. for targeted re-engagement campaigns.


-- Q4: Find customers who placed MORE orders than the average 
-- number of orders placed per customer

SELECT 
    customer_id, 
    COUNT(order_id) AS total_order
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > (
    SELECT AVG(total_order)
    FROM (
        SELECT customer_id, COUNT(order_id) AS total_order
        FROM orders
        GROUP BY customer_id
    ) AS customer_table
);

-- Insight: Same nested pattern applies to COUNT, not just SUM — 
-- the key rule is: aggregate first in the inner subquery, alias it, 
-- then reference that alias (not the original raw column) in the 
-- outer aggregate. Referencing the original column name at the 
-- outer level is the most common bug in this pattern.
