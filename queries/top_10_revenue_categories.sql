-- TODO: This query will return a table with the top 10 revenue categories in 
-- English, the number of orders and their total revenue. The first column will 
-- be Category, that will contain the top 10 revenue categories; the second one 
-- will be Num_order, with the total amount of orders of each category; and the 
-- last one will be Revenue, with the total revenue of each catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.

--Category | Num_order | Revenue
WITH JoinedDB AS (
	SELECT 
		o.order_id, o.order_status, o.order_delivered_customer_date, 
		i.product_id, pr.product_category_name, pa.payment_value, t.product_category_name_english AS Category
	FROM olist_orders AS o
	JOIN olist_order_items AS i ON o.order_id = i.order_id 
	JOIN olist_products AS pr ON i.product_id = pr.product_id
	JOIN olist_order_payments AS pa ON o.order_id = pa.order_id
	JOIN product_category_name_translation AS t ON pr.product_category_name = t.product_category_name 
	WHERE 
		o.order_status = 'delivered' 
		AND o.order_delivered_customer_date IS NOT NULL
		AND pr.product_category_name IS NOT NULL
)
SELECT Category, COUNT(DISTINCT order_id || Category) AS Num_order, SUM(payment_value) AS Revenue
FROM JoinedDB
GROUP BY Category
ORDER BY Revenue DESC
LIMIT 10
;
