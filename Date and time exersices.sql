USE Practice_db;

-- Date and time  exersices.
-- question 1
SELECT 
	customer_id, EXTRACT(MONTH FROM market_date) AS month_purchased ,
	EXTRACT(YEAR FROM market_date) AS year_purchased
FROM customer_purchases;

SELECT 
	customer_id,DATEPART(month,market_date) AS month_purchased ,
	DATEPART(yy,market_date) AS year_purchased
FROM customer_purchases;


--question 2
SELECT MIN(market_date) AS sales_since_date, 
SUM(quantity * cost_to_customer_per_qty) AS total_sales
FROM customer_purchases
WHERE DATEDIFF(DAY,'2019- 03- 31', market_date) <= 14

--Question 3

SELECT market_date,market_day,
CASE 
WHEN market_day = DATENAME(weekday,market_date)  THEN 'TRUE'
ELSE 'FALSE'
END AS quality_control
FROM market_date_info
;
