drop table PizzaTable1

-- To call up the entire table we imported into SQL
SELECT *
FROM pizza_sales

-- To get the Total Revenue
SELECT SUM(total_price) [Total Revenue]
FROM pizza_sales

-- To calculate the Average Order Value
SELECT SUM(total_price) / COUNT(distinct order_id) [Average Order Value]
FROM pizza_sales 

-- To get the Total Pizzas Sold
SELECT SUM(quantity) [Total Pizza Sold]
FROM pizza_sales

-- To get the Total Orders
SELECT COUNT(distinct order_id) [Total Orders]
FROM pizza_sales

-- To get the Average Pizza Ordered in decimals up to 10 dp
SELECT CAST (SUM(quantity) AS DECIMAL(10,2))/ CAST(COUNT(distinct order_id) AS DECIMAL(10,2)) 
FROM pizza_sales

-- To get the Average Pizza Ordered in decimal up to 2 dp
SELECT CAST (CAST (SUM(quantity) AS DECIMAL(10,2))/ CAST(COUNT(distinct order_id) AS DECIMAL(10,2)) AS decimal(10,2)) [Avg Pizzas Per Order]
FROM pizza_sales

/*
Note that when you put a column and an aggregate column side by side, you have use GROUP BY to get it sorted
*/
-- To get the Daily Sales Trend
SELECT DATENAME(DW, order_date) [Order Day], COUNT(distinct order_id) [Total Orders]  -- the DATENAME(DW,) brings out the day of the week from the column order_date as retrieve it as a string, we also pass if alongside the distinct count of the order_id
From pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY [Total Orders] ASC -- this will sort the entire result by the Total Orders column in Ascending order

-- To calculate the Monthly Total Orders
SELECT DATENAME(MONTH, order_date) [Month Name], COUNT(distinct order_id) [Total Orders] -- Looking at the same thing we did for days of the week earlier, we are using same for the months of the year to clearly ascertain peak sales period during the year
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY [Total Orders] DESC -- sort our result by Total Orders in Descending Order

-- Calculate the Percentage of Sales
SELECT pizza_category, SUM(total_price) [Total Revenue], SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) [%age of Total Revenue]
FROM pizza_sales
GROUP BY pizza_category

SELECT pizza_category, SUM(total_price) [Total Revenue], SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) [%age of Total Revenue] -- we added the where clause in the select subquery
FROM pizza_sales
WHERE MONTH(order_date) = 1 -- to call out just the data for January, where 1 is Jan, 2 is February, etc
GROUP BY pizza_category

-- Percentage of Sales by Pizza Size
SELECT pizza_size [Pizza Size], SUM(total_price) [Total Revenue], SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) [%age of Total Revenue]
FROM pizza_sales
GROUP BY pizza_size
ORDER BY [%age of Total Revenue]

SELECT pizza_size [Pizza Size], SUM(total_price) [Total Revenue], SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date) = 1) [%age of Total Revenue]
FROM pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1 -- add this clause to view the details for the first quarter Jan - March
GROUP BY pizza_size
ORDER BY [%age of Total Revenue]


-- using CAST on same query to bring the figures to 2 decimal points *********
SELECT pizza_size [Pizza Size], cast(SUM(total_price) AS decimal(10,2)) [Total Revenue], CAST((SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales)) AS DECIMAL(10,2)) [%age of Total Revenue]
FROM pizza_sales
GROUP BY pizza_size
ORDER BY [%age of Total Revenue] DESC

-- to get for the first quarter, we put the where clause both in the main select statement and in the sub select statement
SELECT pizza_size [Pizza Size], cast(SUM(total_price) AS decimal(10,2)) [Total Revenue], CAST((SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date)=1)) AS DECIMAL(10,2)) [%age of Total Revenue]
FROM pizza_sales
WHERE DATEPART(QUARTER, order_date)=1
GROUP BY pizza_size
ORDER BY [%age of Total Revenue] DESC

-- To get the Top 5 Best Sellers by Revenue, Total Quantity and Total Orders
SELECT * FROM pizza_sales

-- BY REVENUE
select pizza_name, cast(SUM(total_price) AS decimal(10,2)) [Total Revenue] 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Revenue] DESC

select top 5 pizza_name [Pizza Name], cast(SUM(total_price) AS decimal(10,2)) [Total Revenue] -- to get the top 5 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Revenue] DESC

select top 5 pizza_name [Pizza Name], cast(SUM(total_price) AS decimal(10,2)) [Total Revenue] -- to get the top 5 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Revenue] ASC -- to get the bottom 5 we reverse the order by clause

-- BY QUANTITY
select pizza_name [Pizza Name], cast(SUM(quantity) AS decimal(10,2)) [Total Quantity] 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Quantity] DESC

select top 5 pizza_name [Pizza Name], cast(SUM(quantity) AS decimal(10,2)) [Total Quantity] -- to get the top 5 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Quantity] DESC

select top 5 pizza_name [Pizza Name], cast(SUM(quantity) AS decimal(10,2)) [Total Quantity] -- to get the top 5 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Quantity] ASC -- bottom 5

-- BY TOTAL ORDERS
select pizza_name [Pizza Name], COUNT(distinct order_id) [Total Orders]
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Orders] desc 

select top 5 pizza_name [Pizza Name], COUNT(distinct order_id) [Total Orders] -- to get the top 5
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Orders] desc 

select top 5 pizza_name [Pizza Name], COUNT(distinct order_id) [Total Orders] -- to get the bottom 5
FROM pizza_sales
GROUP BY pizza_name
ORDER BY [Total Orders] ASC -- to get the bottom 5 