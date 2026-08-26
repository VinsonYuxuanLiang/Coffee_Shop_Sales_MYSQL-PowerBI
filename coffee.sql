-- ============================================================
-- I. Data Cleaning & Table Preparation (Q1-6)
-- ============================================================

-- Q1: Date Formatting - Convert transaction_date string to proper date format

Update coffee_shop_sales
SET transaction_date = str_to_date(transaction_date, '%m/%d/%Y');

-- Q2: Date Data Type Alteration - Change column type to DATE

Alter table coffee_shop_sales
Modify Column transaction_date DATE;

-- Q3: Time Formatting - Convert transaction_time string to proper time format

Update coffee_shop_sales
SET transaction_time = str_to_date(transaction_time, '%H:%i:%s');

-- Q4: Time Data Type Alteration - Change column type to TIME

Alter table coffee_shop_sales
Modify Column transaction_time TIME;

-- Q5: Schema Verification - Inspect column names and data types

Describe coffee_shop_sales;

-- Q6: Column Renaming - Fix corrupted column headers (e.g., BOM prefix)

ALTER TABLE coffee_shop_sales
CHANGE COLUMN `ï»¿transaction_id` `transaction_id` INT;


-- ============================================================
-- II. Core Key Performance Indicators (KPIs) (Q7-12)
-- ============================================================

-- Q7: Monthly Total Sales - Total sales revenue for May

Select Round(SUM(unit_price * transaction_qty)) AS Total_Sales
From coffee_shop_sales
Where Month (transaction_date) = 5;

-- Q8: Sales MoM Growth - Month-over-Month difference and percentage (April vs May)

SELECT
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    Round((SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))), -2) AS sales_diff,
    Round((SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date)) * 100, 1) AS mom_increase_percentage

FROM
    coffee_shop_sales
WHERE
    MONTH(transaction_date) IN (4, 5)
GROUP BY
    MONTH(transaction_date)
ORDER BY
    MONTH(transaction_date);

-- Q9: Monthly Total Orders - Total number of transactions in May

SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales
WHERE MONTH (transaction_date)= 5;

-- Q10: Orders MoM Growth - Month-over-Month difference and percentage (April vs May)

SELECT
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1)
    OVER (ORDER BY MONTH(transaction_date))) AS order_diff,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1)
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM
    coffee_shop_sales
WHERE
    MONTH(transaction_date) IN (4, 5)
GROUP BY
    MONTH(transaction_date)
ORDER BY
    MONTH(transaction_date);

-- Q11: Monthly Total Quantity Sold - Total items sold in May

SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5;

-- Q12: Quantity Sold MoM Growth - Month-over-Month difference and percentage (April vs May)

SELECT
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) AS trans_diff,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM
    coffee_shop_sales
WHERE
    MONTH(transaction_date) IN (4, 5)
GROUP BY
    MONTH(transaction_date)
ORDER BY
    MONTH(transaction_date);


-- ============================================================
-- III. Calendar & Daily Performance Metrics (Q13-17)
-- ============================================================

-- Q13: Daily KPI Snapshot - Total sales, quantity, and orders for a specific date (May 18, 2023)

SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023

-- Q14: Formatted KPI Values - Format daily metrics into rounded "K" (thousands) display
-- (Covered in Q13 query above using CONCAT + 'K')

Select
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000, 1), 'K') AS total_sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000, 1), 'K') AS total_qty_sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000, 1), 'K') AS total_orders
FROM
    coffee_shop_sales
WHERE
    transaction_date = '2023-05-18';

-- Q15: Average Daily Sales - Average daily sales revenue across all days in May

SELECT AVG(total_sales) AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;

-- Q16: Daily Sales Breakdown - Total sales for each individual day in May

SELECT 
	Day(transaction_date) as day_of_month,
	Round(SUM(unit_price * transaction_qty), 2) AS total_sales
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
	transaction_date;

-- Q17: Sales vs. Average Status - Each day's sales compared to monthly daily average (Above/Below Average)

SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    Round(total_sales, 2)
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;


-- ============================================================
-- IV. Categorical & Dimensional Analysis (Q18-21)
-- ============================================================

-- Q18: Weekday vs. Weekend Sales - Sales comparison between weekdays and weekends in May

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;


-- Q19: Sales by Store Location - Total sales breakdown and ranking across store locations

SELECT 
	store_location,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY SUM(unit_price * transaction_qty) DESC;


-- Q20: Sales by Product Category - Total sales generated by each product category

SELECT 
	product_category,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY product_category
ORDER BY 	SUM(unit_price * transaction_qty) DESC;

-- Q21: Top 10 Products by Sales - Best-selling product types by total revenue in May

SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10; 

-- ============================================================
-- V. Time & Schedule Patterns (Q22-24)
-- ============================================================

-- Q22: Sales by Specific Day & Hour - Sales for a specific weekday and hour combination (e.g., Tuesdays at 8 AM in May)

SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)


-- Q23: Sales by Day of Week - Total sales breakdown from Monday through Sunday for May

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;


-- Q24: Sales by Hour of Day - Sales distribution across operating hours (6 AM - 8 PM) in May

SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);


