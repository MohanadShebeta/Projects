use Pizza_Db

SELECT *
FROM pizza_sales


SELECT SUM(total_price) as Total_Revenue
FROM pizza_sales


SELECT SUM(total_price) / COUNT(Distinct order_id) as AVG_Order_Value
FROM pizza_sales


SELECT SUM(quantity) as Total_Pizza_Sold
FROM pizza_sales


SELECT COUNT(Distinct order_id) as Total_pizza_Ordered
FROM pizza_sales



SELECT CAST(SUM(quantity) as float) / CAST(COUNT(distinct order_id) as float) as AVG_Pizzas_per_Order
FROM pizza_sales




-- Calculating the Daily Trend for orders

SELECT DATENAME(DW, order_date) as Order_Day, COUNT(Distinct order_id) as total_orders
from pizza_sales
group by DATENAME(DW, order_date)


--calculating Monthly trend for orders

SELECT datename(month, order_date) as Month, count(distinct order_id) as Tota_Orders
from pizza_sales
group by datename(month, order_date)
order by 2 DESC


/* calcualting the percentage of sales for each pizza category, and the total sales for each pizza
 category. and adding the where clause to filter for month to get each month's sales
 */

Select pizza_category,sum(total_price) as Total_Sales,
sum(total_price) * 100 / (select sum(total_price) 
from pizza_sales where month(order_date) = 1) as Sales_Percentage
from pizza_sales
where month(order_date) = 1
group by pizza_category
order by Sales_Percentage DESC


--percentage of sales for pizza size

Select pizza_size,sum(total_price) as Total_Sales,
sum(total_price)	* 100 / (select sum(total_price) from pizza_sales where DATEPART(quarter, order_date) = 1)
as Sales_Percentage
from pizza_sales
where DATEPART(quarter, order_date) = 1
group by pizza_size
order by Sales_Percentage DESC




--Total pizza sold by category

select pizza_category, sum(quantity) as total_pizza_sold
from pizza_sales
group by pizza_category
order by total_pizza_sold desc



--best 5 sellers by Quantity

select TOP 5 pizza_name, sum(quantity) as total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_Pizza_Sold DESC


--Top 5 by Revenue

select TOP 5 pizza_name, sum(total_price) as total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY 2 DESC


-- Top 5 Ordered Pizza

select TOP 5 pizza_name, count(DISTINCT order_id) as total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY 2 DESC


-- Worst Sellers, filtering with the month

select TOP 5 pizza_name, sum(quantity) as total_Pizza_Sold
FROM pizza_sales
--Where month(order_date) = 1
GROUP BY pizza_name
ORDER BY total_Pizza_Sold ASC


-- Worst 5 by Revenue

select TOP 5 pizza_name, sum(total_price) as total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY 2 ASC



-- Worst 5 Ordered Pizza

select TOP 5 pizza_name, count(DISTINCT order_id) as total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY 2 ASC