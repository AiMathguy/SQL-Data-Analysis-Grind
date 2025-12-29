USE practice_db;
SELECT * FROM customer_purchases;
SELECT * FROM vendor ;

ALTER TABLE customer_purchases 
ADD vendor_id INT NOT NULL DEFAULT 0;

SELECT * FROM customer_purchases;

UPDATE cp
SET cp.vendor_id =vi.vendor_id FROM customer_purchases cp
INNER JOIN  vendor_inventory vi 
ON cp.product_id =vi.product_id 
AND cp.market_date=vi.market_date;


SELECT * FROM customer_purchases;

INSERT INTO customer_purchases (vendor_id) SELECT vendor_id FROM vendor;
    
GO
CREATE VIEW vw_sales AS
SELECT 
    cp.market_date,
    md.market_day,
    md.market_week,
    md.market_year,
    cp.vendor_id, 
    v.vendor_name,
    v.vendor_type,
    ROUND(SUM(cp.quantity * cp.cost_to_customer_per_qty),2) AS sales
FROM customer_purchases AS cp
    LEFT JOIN market_date_info AS md
        ON cp.market_date = md.market_date
    LEFT JOIN vendor AS v
        ON cp.vendor_id = v.vendor_id
GROUP BY cp.market_date,
    md.market_day,
    md.market_week,
    md.market_year,
    cp.vendor_id, 
    v.vendor_name,
    v.vendor_type
;
GO


-- question 1 

SELECT SUM(sales) as weekly_sales FROM vw_sales
GROUP BY market_week ;

-- question 2

SELECT
    market_date, 
    vendor_id,
    booth_number,
    LAG(booth_number,1) OVER (PARTITION BY vendor_id ORDER BY market_date, 
vendor_id) AS previous_booth_number
FROM vendor_booth_assignments
ORDER BY market_date, vendor_id, booth_number


SELECT * FROM vendor_booth_assignments

;WITH sec_question AS 
    (
SELECT
    market_date, 
    vendor_id,
    booth_number,
    LAG(booth_number,1) OVER (PARTITION BY vendor_id ORDER BY market_date, 
vendor_id) AS previous_booth_number
FROM vendor_booth_assignments)
SELECT * FROM sec_question 
;

-- question 3
SELECT * FROM vendor
SELECT * FROM vendor_booth_assignments
SELECT * FROM vendor_inventory

;WITH  calcs  AS 
(SELECT SUM(quantity* cost_to_customer_per_qty) AS sales, COUNT(booth_number) AS num_of_booths FROM
customer_purchases 
INNER JOIN vendor_booth_assignments ON customer_purchases.vendor_id = vendor_booth_assignments.vendor_id
)
SELECT sales / num_of_booths AS average_per_booth FROM calcs;
