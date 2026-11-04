create database pizza_DB;
use pizza_db;

create table pizza_sales(
pizza_id int primary key,
order_id int,
pizza_name_id varchar(50),
quantity int,
order_date date,
order_time time,
unit_price float,
total_price float,
pizza_size varchar(50),
pizza_category varchar(50),
pizza_ingredients varchar(200),
pizza_name varchar(50)
);
desc pizza_sales1;

show variables like "secure_file_priv";
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_sales.csv'
INTO TABLE pizza_sales1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    @order_date,
    order_time,
    unit_price,
    total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
)
SET order_date = STR_TO_DATE(@order_date, '%d-%m-%Y');

#---------------------- KPI's Requirements ------------------
---- To get Total Revenue
select ROUND(SUM(total_price),2) as Total_Revenue 
from pizza_sales;

--- Average Order Value
SELECT ROUND(SUM(total_price) /COUNT(distinct order_id),2) as AVG_ORDER_VALUE 
from pizza_sales;

---- Total Pizzas_Sold
SELECT SUM(quantity) as Total_Pizzas_Sold 
from Pizza_Sales;

--- Total Orders Placed
SELECT COUNT(DISTINCT order_id) as Total_Orders from pizza_sales;

--- Average Pizzas Sold Per Order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS Average_Pizzas_Per_Order
FROM pizza_sales;

------------------------- Charts Requirements ------------------------
select * from pizza_sales;

 ----- Daily Trend for total Orders
SELECT DAYNAME(order_date) AS order_day,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DAYNAME(order_date)
order by Total_Orders desc ;

------ Monthly Trend for Total Orders
SELECT MonthName(order_date) AS Month_Name,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY MonthName(order_date)
ORDER BY Total_Orders DESC;

----- % of Sales as Pizza Category
SELECT pizza_category,ROUND(SUM(total_price),2) as Total_Revenue, ROUND(SUM(total_price) * 100/(SELECT SUM(total_price) from pizza_sales),2)  as PCT
from pizza_sales
GROUP BY pizza_category
ORDER BY PCT DESC ;

----- % of Sales BY Pizza Size
SELECT pizza_size,ROUND(SUM(total_price),2) as Total_Revenue, ROUND(SUM(total_price) * 100/(SELECT SUM(total_price) from pizza_sales),2)  as PCT
from pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC ;

---- Total pizzas sold by pizza category;
SELECT pizza_category,SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC ;

--- Top 5 pizzas by revenue
SELECT pizza_name,SUM(total_price) as Total_Revenue
FROm pizza_sales
GROUP BY pizza_name
ORDER BY  Total_Revenue DESC
LIMIT 5;

----- Bottom 5 Pizzas by Revenue
SELECT pizza_name,ROUND(SUM(total_price),2) as Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY  Total_Revenue ASC
LIMIT 5;

--- Top 5 Pizzas by Quantity
SELECT pizza_name,SUM(quantity) as Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

--- Bottom 5 Pizzas by Quantity
SELECT pizza_name,SUM(quantity) as Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

--- Top 5 pizzas by Total Orders
SELECT pizza_name,COUNT(DISTINCT order_id) as Total_Orders
From pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5 ;

--- Bottom 5 pizzas by Total Orders
SELECT pizza_name,COUNT(DISTINCT order_id) as Total_Orders
From pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5 ;


