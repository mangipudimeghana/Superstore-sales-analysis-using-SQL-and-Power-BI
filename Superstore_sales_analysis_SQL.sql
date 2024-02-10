/* Top 3 customers with highest total value of orders */

SELECT TOP 3 Customer_Name, ROUND(SUM(Sales), 3) AS TotalOrderValue FROM superstore_final_dataset 
GROUP BY Customer_Name ORDER BY SUM(sales) DESC

/* Top 5 items with the highest average sales per day */

SELECT TOP 5 Product_ID, ROUND(AVG(sales), 3) AS Average_Sales FROM superstore_final_datset
GROUP BY Product_ID ORDER BY Average_Sales DESC

/* Query to find the average order value for each customer, and rank the customers by their average order value */

SELECT Customer_Name, ROUND(AVG(sales), 3) AS avg_order_value, DENSE_RANK() OVER (ORDER BY AVG(sales) DESC) AS sales_rank
FROM superstore_final_datset GROUP BY Customer_Name

/* Name of customers who ordered highest and lowest orders from each city */

WITH cte AS (
    SELECT City, ROUND(MAX(sales), 4) AS highest_order, ROUND(MIN(sales), 4) AS lowest_order
    FROM superstore_final_datset GROUP BY City
),
highest_orders AS (
    SELECT s.City, cte.highest_order, cte.lowest_order, s.Customer_Name
    FROM superstore_final_datset s INNER JOIN cte ON s.City = cte.City
    WHERE s.Sales = cte.highest_order
),
lowest_orders AS (
    SELECT s.City, cte.highest_order, cte.lowest_order, s.Customer_Name
    FROM superstore_final_datset s INNER JOIN cte ON s.City = cte.City
    WHERE s.Sales = cte.lowest_order
)
SELECT h.City, h.highest_order, h.Customer_Name AS highest_order_customer, l.lowest_order, l.Customer_Name AS lowest_order_customer
FROM highest_orders h INNER JOIN lowest_orders l ON h.City = l.City ORDER BY h.City;

/* What is the most demanded sub-category in the west region */

SELECT TOP 1 Sub_Category, ROUND(SUM(sales), 3) AS total_quantity
FROM superstore_final_datset WHERE Region = 'West'
GROUP BY Sub_Category ORDER BY total_quantity DESC

/* Which order has the highest number of items */

SELECT TOP 1 order_id, COUNT(order_id) AS num_item
FROM superstore_final_datset GROUP BY order_id ORDER BY num_item DESC

/* Which order has the highest cumulative value */

SELECT TOP 1 order_id, ROUND(SUM(sales), 3) AS order_value
FROM superstore_final_datset GROUP BY order_id ORDER BY order_value DESC

/* Which segment’s order is more likely to be shipped via first class */

SELECT segment, COUNT(order_id) AS num_of_order
FROM superstore_final_datset WHERE ship_mode = 'First Class'
GROUP BY segment ORDER BY num_of_order DESC

/* Which city is least contributing to total revenue */

SELECT TOP 1 city, ROUND(SUM(sales), 3) AS TotalSales
FROM superstore_final_datset GROUP BY city ORDER BY TotalSales ASC

/* What is the average time for orders to get shipped after order is placed */

SELECT AVG(DATEDIFF(hour,ship_date, order_date)) AS avg_ship_time FROM superstore_final_datset

/* Which segment places the highest number of orders from each state and which segment places the largest individual orders from each state */
       
WITH cte AS (
    SELECT state, segment, COUNT(order_id) AS num_orders, RANK() OVER (PARTITION BY state ORDER BY COUNT(order_id) DESC) AS state_rank
    FROM superstore_final_datset GROUP BY state, segment
)
SELECT state, segment FROM cte WHERE state_rank = 1

