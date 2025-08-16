SELECT * FROM public.retail_sales
ORDER BY transactions_id ASC;

SELECT * FROM retail_sales
LIMIT 10;

--
SELECT * FROM retail_sales
WHERE 
		sale_date IS NULL
		or
		sale_time IS NULL
		or
		age IS NULL
		or
		customer_id IS NULL
		or
		category IS NULL
		or
		quantity IS NULL
		or
		price_per_unit IS NULL
		or
		cogs IS NULL
		or
		total_sale IS NULL;
		
--DATA cleaning--

DELETE FROM retail_sales
WHERE 
		sale_date IS NULL
		or
		sale_time IS NULL
		or
		age IS NULL
		or
		customer_id IS NULL
		or
		category IS NULL
		or
		quantity IS NULL
		or
		price_per_unit IS NULL
		or
		cogs IS NULL
		or
		total_sale IS NULL;

--DATA Exploration--
--How many sales we have?--
SELECT COUNT (*) AS total_sales FROM retail_sales;

--How many unique customers we have?

SELECT COUNT (DISTINCT (customer_id)) AS total_customers FROM retail_sales

--How many categories we have?

SELECT COUNT (DISTINCT (category)) AS total_categories FROM retail_sales;

SELECT DISTINCT (category) AS list FROM retail_sales;

--Data analysis & Business key problems & answers--

--Q.1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT total_sale
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q.2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *		
FROM retail_sales
WHERE
	category= 'Clothing' 
	AND 
	EXTRACT ('month' FROM sale_date)= '11'
    AND
	quantity >= 4;

--Q.3.Write a SQL query to calculate the total sales (total_sale) for each category

SELECT category,
		SUM (total_sale) AS net_sale,
		COUNT (*) AS total_orders
FROM retail_sales
GROUP BY category;

--Q.4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT ROUND (AVG (age), 2)
FROM retail_sales
WHERE category = 'Beauty';

--Q.5.Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * 
FROM retail_sales
WHERE total_sale>1000
ORDER BY total_sale

--Q.6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT category, gender, COUNT (transactions_id) AS total_transactions
FROM retail_sales
GROUP BY 2, 1
ORDER BY category;

--Q.7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


SELECT  year, month, avg_total_sales
		FROM
		(SELECT 
				EXTRACT (year FROM sale_date) AS year,
				EXTRACT (month FROM sale_date) AS month,
				AVG (total_sale) AS avg_total_sales,
				RANK () OVER (PARTITION BY EXTRACT (year FROM sale_date) ORDER BY AVG (total_sale) DESC) AS Rank
		FROM retail_sales
		GROUP BY 1, 2) AS t1
WHERE rank = 1

--Q.8.**Write a SQL query to find the top 5 customers based on the highest total sales **

SELECT customer_id, SUM (total_sale) AS total_sales,
		RANK() OVER (ORDER BY SUM (total_sale) DESC)
FROM retail_sales
GROUP BY customer_id
LIMIT 5

--Q.9.Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT (DISTINCT (customer_id)) AS num_customer
FROM retail_sales
GROUP BY category

--Q.10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales
AS
(SELECT *,
			CASE
			WHEN EXTRACT (hour FROM sale_time) <12 THEN 'Morning'
			WHEN EXTRACT (hour FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
	        END AS shift
FROM retail_sales
) 	 
SELECT shift, COUNT (*) AS total_orders
FROM hourly_sales
GROUP BY 1

--END OF PROJECT
