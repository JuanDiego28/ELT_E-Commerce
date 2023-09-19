-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

WITH JDB AS(
	SELECT 
		STRFTIME('%m',o.order_delivered_customer_date) AS month_no,
		(CASE STRFTIME('%m', o.order_delivered_customer_date)
			WHEN '01' THEN 'Jan' WHEN '02' THEN 'Feb' WHEN '03' THEN 'Mar' WHEN '04' THEN 'Apr'
			WHEN '05' THEN 'May' WHEN '06' THEN 'Jun' WHEN '07' THEN 'Jul' WHEN '08' THEN 'Aug'
			WHEN '09' THEN 'Sep' WHEN '10' THEN 'Oct' WHEN '11' THEN 'Nov' WHEN '12' THEN 'Dec' 
		END) AS month,
		STRFTIME('%Y',order_delivered_customer_date) AS year,
		o.order_id, o.order_purchase_timestamp, o.order_delivered_customer_date, 
        o.order_status, p.payment_value, o.order_approved_at
	FROM olist_orders AS o
	JOIN olist_order_payments AS p ON o.order_id = p.order_id
	WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
), DB AS (
SELECT
	month_no, month, year, order_id, order_purchase_timestamp, 
    order_delivered_customer_date, order_status, order_approved_at,
    MIN(payment_value) AS min_payment_value
FROM JDB
GROUP BY month_no, month, year, order_id, order_delivered_customer_date
ORDER BY month_no
)
SELECT month_no, month,
	SUM(CASE WHEN year = '2016' THEN min_payment_value END) AS Year2016,
	SUM(CASE WHEN year = '2017' THEN min_payment_value END) AS Year2017,
	SUM(CASE WHEN year = '2018' THEN min_payment_value END) AS Year2018
FROM DB
GROUP BY month_no, month
ORDER BY month_no

