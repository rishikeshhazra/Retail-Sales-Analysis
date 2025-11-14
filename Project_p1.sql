CREATE DATABASE Project_p1;
USE Project_p1;
TABLE Retail_Sale_Analysis (
		transactions_id INT,	
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR (15),
		age	INT,
		category  VARCHAR (25),
		quantity INT,	
        price_per_unit INT,	
		cogs INT,
		total_sale INT
);
SET SQL_SAFE_UPDATES = 0;
SELECT * FROM Retail_Sale_Analysis;
SELECT COUNT(*) FROM Retail_Sale_Analysis;


-- Deleting null rows to filter out the table -- 

DELETE FROM retail_sale_analysis
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Q1. Write a SQL Querry to retrieve all columns for sales made on  2022-11-05.
SELECT * FROM retail_sale_analysis
WHERE sale_date = "2022-11-05";

-- Q2. Write a SQL Querry to retrieve all transactions where the category is "Clothing" and the quantity sold is more than 3 in the month of Nov-2022.
SELECT *
FROM retail_sale_analysis
WHERE category = "Clothing"
AND
	DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND
	quantity > 3;
-- There DATE_FORMAT is used to find the desirable date. If you use "M" it means the code will find the month in words. e.g. "January/November....etc". But when you put "m" it will find the number of the month on the particular column. After using DATE_FORMAT "%" is mendatory to use in month and year.


-- Q3. Write a SQL Query to calculate the total sales (total_sale) for each category.
SELECT
	category,
    SUM(total_sale)
FROM retail_sale_analysis
GROUP BY 1
ORDER BY 2 DESC;


-- Q4. Write a SQL Query to find the avg age of customers who purchased items from the beauty category.
SELECT
	category,
    AVG(age) AS avg_age
FROM retail_sale_analysis
WHERE 
	category = "Beauty"
GROUP BY 1;


-- Q5. Write a SQL Query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM
retail_sale_analysis
WHERE total_sale > 1000;


-- Q6. Write a SQL Query to find the total number of transactions (transactions_id) made by each gender and each category.
SELECT
	category,
    gender,
    COUNT(DISTINCT transactions_id) as total_transactions
FROM retail_sale_analysis
GROUP BY 1,2
ORDER BY 1;


-- Q7. Write a SQL Query to calculate the avg sale for each month. Find out best selling month in each year.
WITH monthly_avg AS (
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date)AS month,
    AVG(total_sale) AS avg_sale
FROM retail_sale_analysis
GROUP BY 1,2
)
SELECT * FROM monthly_avg
WHERE (year, avg_sale) 
IN(
SELECT year, MAX(avg_sale)
FROM monthly_avg
GROUP BY YEAR
);


-- Q8. Write a SQL Query to find the top 5 customers based on the highest total sales.
SELECT
	DISTINCT customer_id,
    SUM(total_sale) AS total_sale
FROM retail_sale_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q9. Write a SQL Query to find the number of unique customers who purchased items from each category.
SELECT
	category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sale_analysis
GROUP BY 1;


-- Q10. Write a SQL Query to create each shift and number of orders (Example Morning <=12, Afternoon 12 & 17, Evening >17).
WITH new_table
AS (
SELECT *,
	CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        ELSE 'Evening'
END AS shift
FROM retail_sale_analysis
)
SELECT 
	shift,
    COUNT(total_sale) AS num_of_orders
FROM new_table
GROUP BY 1;


						-- END OF THE PROJECT-- 