CREATE Database Practice_db;
USE Practice_db;
-- Creating the database to practice on.


-- 1. Create market_date_info table
CREATE TABLE market_date_info (
    market_date DATE PRIMARY KEY,
    market_day VARCHAR(45),
    market_week VARCHAR(45),
    market_year VARCHAR(45),
    market_start_time VARCHAR(45),
    market_end_time VARCHAR(45),
    special_notes VarBinary,
    market_season VARCHAR(45),
    market_min_temp VARCHAR(200),
    market_max_temp VARCHAR(45),
    market_rain_flag INT,
    market_snow_flag INT
);

-- 2. Create booth table
CREATE TABLE booth (
    booth_number INT PRIMARY KEY,
    booth_price_level VARCHAR(45),
    booth_description VARCHAR(255),
    booth_type VARCHAR(45)
);

-- 3. Create vendor table
CREATE TABLE vendor (
    vendor_id INT PRIMARY KEY,
    vendor_name VARCHAR(45),
    vendor_type VARCHAR(45),
    vendor_owner_first_name VARCHAR(45),
    vendor_owner_last_name VARCHAR(45)
);

-- 4. Create vendor_booth_assignments table (Junction table for market_date_info, booth, and vendor)
CREATE TABLE vendor_booth_assignments (
    vendor_id INT,
    booth_number INT,
    market_date DATE,
    PRIMARY KEY (vendor_id, booth_number, market_date),
    FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
    FOREIGN KEY (booth_number) REFERENCES booth(booth_number),
    FOREIGN KEY (market_date) REFERENCES market_date_info(market_date)
);

-- 5. Create product_category table
CREATE TABLE product_category (
    product_category_id INT PRIMARY KEY,
    product_category_name VARCHAR(45)
);

-- 6. Create product table
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(45),
    product_size VARCHAR(45),
    product_category_id INT,
    product_qty_type VARCHAR(45),
    FOREIGN KEY (product_category_id) REFERENCES product_category(product_category_id)
);

-- 7. Create vendor_inventory table
CREATE TABLE vendor_inventory (
    market_date DATE,
    quantity DECIMAL(10, 0), -- Assuming quantity is a whole number
    vendor_id INT,
    product_id INT,
    original_price DECIMAL(10, 3), -- Assuming price needs 3 decimal places for cents/fractions
    PRIMARY KEY (market_date, vendor_id, product_id),
    FOREIGN KEY (market_date) REFERENCES market_date_info(market_date),
    FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 8. Create customer table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_first_name VARCHAR(45),
    customer_last_name VARCHAR(45),
    customer_zip VARCHAR(45)
);

-- 9. Create customer_purchases table (Fact table)
CREATE TABLE customer_purchases (
    product_id INT,
    market_date DATE,
    customer_id INT,
    quantity DECIMAL(16, 2), -- Allowing up to 14 digits before decimal point
    cost_to_customer_per_qty DECIMAL(16, 2), -- Price per unit at purchase
    transaction_time TIME,
    PRIMARY KEY (product_id, market_date, customer_id, transaction_time), -- Assuming a combination of these is unique per transaction
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (market_date) REFERENCES market_date_info(market_date),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Re-enable foreign key checks
-- SET FOREIGN_KEY_CHECKS = 1;
SELECT * FROM market_date_info

-- market_date_info: Two different market dates
INSERT INTO market_date_info (market_date, market_day, market_week, market_year, market_start_time, market_end_time, special_notes, market_season, market_min_temp, market_max_temp, market_rain_flag, market_snow_flag) VALUES
('2024-07-20', 'Saturday', '29', '2024', '08:00', '13:00', NULL, 'Summer', '18C', '28C', 0, 0),
('2024-10-12', 'Saturday', '41', '2024', '09:00', '14:00', NULL, 'Autumn', '10C', '16C', 1, 0);

-- booth: Various booth types
INSERT INTO booth (booth_number, booth_price_level, booth_description, booth_type) VALUES
(101, 'Premium', 'Corner spot with high traffic', 'Large'),
(102, 'Standard', 'Mid-aisle spot, good visibility', 'Medium'),
(205, 'Economy', 'Back row, sheltered', 'Small');

-- product_category: Categories for products
INSERT INTO product_category (product_category_id, product_category_name) VALUES
(1, 'Vegetables'),
(2, 'Fruits'),
(3, 'Baked Goods'),
(4, 'Crafts');

-- product: Products available (linked to categories)
INSERT INTO product (product_id, product_name, product_size, product_category_id, product_qty_type) VALUES
(1001, 'Heirloom Tomatoes', 'Large', 1, 'Lb'),
(1002, 'Blueberries', 'Pint', 2, 'Container'),
(1003, 'Sourdough Bread', 'Loaf', 3, 'Unit'),
(1004, 'Fresh Basil', 'Bunch', 1, 'Bunch'),
(1005, 'Apple Cider Donuts', 'Dozen', 3, 'Dozen');

-- vendor: Vendors participating
INSERT INTO vendor (vendor_id, vendor_name, vendor_type, vendor_owner_first_name, vendor_owner_last_name) VALUES
(1, 'Green Acres Farm', 'Produce', 'Alex', 'Smith'),
(2, 'The Bread Basket', 'Bakery', 'Maria', 'Garcia'),
(3, 'Sweet Berry Patch', 'Produce', 'David', 'Lee');

-- vendor_booth_assignments: Assigning vendors to booths on specific dates
INSERT INTO vendor_booth_assignments (vendor_id, booth_number, market_date) VALUES
(1, 101, '2024-07-20'),
(2, 102, '2024-07-20'),
(3, 205, '2024-07-20'),
(1, 102, '2024-10-12'),
(2, 101, '2024-10-12');

-- vendor_inventory: What vendors brought and their starting price (market_date, vendor_id, product_id must match)
INSERT INTO vendor_inventory (market_date, quantity, vendor_id, product_id, original_price) VALUES
-- Green Acres (ID 1) on 2024-07-20
('2024-07-20', 150, 1, 1001, 3.50), -- Tomatoes
('2024-07-20', 50, 1, 1004, 2.00), -- Basil
-- Bread Basket (ID 2) on 2024-07-20
('2024-07-20', 30, 2, 1003, 7.50), -- Sourdough
('2024-07-20', 40, 2, 1005, 12.00), -- Donuts
-- Sweet Berry Patch (ID 3) on 2024-07-20
('2024-07-20', 75, 3, 1002, 6.00), -- Blueberries
-- Green Acres (ID 1) on 2024-10-12
('2024-10-12', 100, 1, 1001, 3.80); -- Tomatoes (price adjustment)


-- customer: Sample customers
INSERT INTO customer (customer_id, customer_first_name, customer_last_name, customer_zip) VALUES
(1, 'Chris', 'Baker', '10001'),
(2, 'Pat', 'Johnson', '10005'),
(3, 'Jamie', 'Chen', '10001');

-- customer_purchases: Transactions made by customers
INSERT INTO customer_purchases (product_id, market_date, customer_id, quantity, cost_to_customer_per_qty, transaction_time) VALUES
-- Customer 1 purchases on 2024-07-20
(1001, '2024-07-20', 1, 2.50, 3.50, '09:15:00'), -- 2.5 lbs Tomatoes
(1003, '2024-07-20', 1, 1.00, 7.50, '09:30:00'), -- 1 Loaf Sourdough
-- Customer 2 purchases on 2024-07-20
(1002, '2024-07-20', 2, 3.00, 6.00, '10:45:00'), -- 3 Pints Blueberries
-- Customer 3 purchases on 2024-10-12
(1001, '2024-10-12', 3, 4.00, 3.80, '11:00:00'), -- 4 lbs Tomatoes
(1005, '2024-07-20', 3, 1.00, 12.00, '12:05:00'); -- 1 Dozen Donuts (Note: Jamie bought this on the first date, but is making a purchase later in the day)



-- Aggregating results for analysis exersices

-- question 1


SELECT * FROM vendor
LEFT JOIN vendor_booth_assignments ON vendor.vendor_id = vendor_booth_assignments.vendor_id 
ORDER BY vendor_name,market_date;

SELECT * FROM vendor
RIGHT JOIN vendor_booth_assignments ON vendor.vendor_id = vendor_booth_assignments.vendor_id 
ORDER BY vendor_name,market_date;

SELECT product_name,market_season FROM market_date_info  
LEFT JOIN customer_purchases ON market_date_info.market_date = customer_purchases.market_date
LEFT JOIN product ON customer_purchases.product_id = product.product_id;


-- question 1

SELECT vendor_id,COUNT(booth_number) FROM vendor_booth_assignments GROUP BY vendor_id;

-- question 2

SELECT MIN(market_date_info.market_date) AS earliest_date, MAX(market_date_info.market_date) AS latest_date FROM market_date_info 
LEFT JOIN customer_purchases ON market_date_info.market_date = customer_purchases.market_date 
LEFT JOIN product ON customer_purchases.product_id=product.product_id
LEFT JOIN product_category ON product.product_category_id = product_category.product_category_id
LEFT JOIN vendor_inventory ON market_date_info.market_date=vendor_inventory.market_date;


-- question  3 

SELECT 
    c.customer_first_name, 
    c.customer_last_name
FROM customer c
JOIN customer_purchases cp ON c.customer_id = cp.customer_id
GROUP BY c.customer_id, c.customer_first_name, c.customer_last_name
HAVING SUM(cp.quantity * cp.cost_to_customer_per_qty) > 50
ORDER BY c.customer_last_name, c.customer_first_name;



SELECT 

    MIN(customer_purchases.market_date) AS earliest, 
    MAX(customer_purchases.market_date) AS latest FROM customer_purchases 
    JOIN vendor_inventory ON customer_purchases.market_date=vendor_inventory.market_date
    JOIN vendor ON vendor_inventory.vendor_id = vendor.vendor_id
    GROUP BY vendor.vendor_name;


SELECT * FROM product_category LEFT JOIN product ON product_category.product_category_id=product.product_category_id;

SELECT product.product_category_id, product_category_name
FROM product JOIN vendor_inventory ON 
product.product_id = vendor_inventory.product_id
JOIN product_category ON product.product_category_id = product_category.product_category_id
GROUP BY product.product_category_id , product_category_name
HAVING AVG(original_price) > 50;