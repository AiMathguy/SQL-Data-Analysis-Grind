USE Practice_db;
-- Exploratory Data Analysis Questions
-- question 1)
SELECT 
	MIN(market_date) AS earliest_purchase , 
	MAX(market_date) AS latest_purchase 
FROM customer_purchases;
SELECT * FROM customer_purchases;

SELECT 
COUNT(DISTINCT customer_id) AS customer_per_timeframe,
DATEPART(HOUR,transaction_time) AS hour_of_transaction,
DATENAME(WEEKDAY,market_date) AS day_of_week 
FROM customer_purchases
GROUP BY DATEPART(HOUR,transaction_time),DATENAME(WEEKDAY,market_date);

SELECT * FROM product;

-- which products sell most over time

SELECT market_date,customer_purchases.product_id, SUM(quantity*cost_to_customer_per_qty) AS sales FROM customer_purchases
LEFT JOIN product ON customer_purchases.product_id=product.product_id
GROUP BY market_date,customer_purchases.product_id;

-- when to time stock up when does stock deplete
SELECT market_date,product_id,SUM(quantity) AS total_quantity,vendor_id  FROM vendor_inventory
GROUP BY vendor_id,market_date,product_id ;