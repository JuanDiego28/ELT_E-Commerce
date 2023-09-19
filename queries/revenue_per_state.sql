-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 

-- REVENUE PER STATE
-- REVENUE PER STATE
WITH DB AS (
	SELECT 
		c.customer_id, 
		c.customer_state, 
		o.order_id, 
		p.payment_value 
	FROM olist_orders AS o
	JOIN olist_order_payments AS p ON o.order_id = p.order_id 
	JOIN olist_customers AS c ON o.customer_id = c.customer_id
	WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
)
SELECT 
	DB.customer_state AS customer_state,
	SUM(DB.payment_value) AS Revenue
FROM DB
GROUP BY DB.customer_state
ORDER BY revenue DESC
LIMIT 10;