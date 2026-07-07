
-- 01-having-clause.sql
-- Topic: HAVING Clause (basic)
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


