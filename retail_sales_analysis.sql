CREATE DATABASE IF NOT EXISTS retail; 

USE retail;

CREATE TABLE retailsales (
  transactions_id int DEFAULT NULL,
  sale_date text,
  sale_time text,
  customer_id int DEFAULT NULL,
  gender text,
  age int DEFAULT NULL,
  category text,
  quantiy int DEFAULT NULL,
  price_per_unit int DEFAULT NULL,
  cogs int DEFAULT NULL,
  total_sale int DEFAULT NULL );
	
    SELECT * FROM retailsales 
    LIMIT 20;
    
    SELECT
    COUNT(*)
    FROM retailsales;
    
    SELECT * FROM retailsales
    WHERE transactions_id IS NULL
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
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs  IS NULL
    OR
    total_sale IS NULL;
    # OR operator if any of them condition setify AND operator have to setisfy condn
    
    DELETE FROM retailsales
    WHERE transactions_id IS NULL
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
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs  IS NULL
    OR
    total_sale IS NULL;
# for clean NULL data from table 

SET SQL_SAFE_UPDATES = 0; #FOR desable safe mode to delete items
# DATA EXPLORATION

# How many sales we have ?
SELECT COUNT(*) AS total_sale FROM retailsales ;

# How may customer we have?
 SELECT COUNT(*) AS customer_id FROM retailsales;
SELECT COUNT(DISTINCT customer_id) FROM retailsales; # remove duplicate item

# How may category we have?
SELECT COUNT(category) FROM retailsales;
SELECT DISTINCT category FROM retailsales; # show diffrent category

# DATA ANALYSIS & BUSINESS KEY PROBLEMS & SOLUTION

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
	
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retailsales
WHERE sale_date = '2022-11-05' ;

SELECT category FROM retailsales
WHERE
Category = 'Clothing'
AND 
TO_CHAR(sale_date,'YYYY-MM') ='2022-11'
AND
quantiy >= 3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
category,
SUM(total_sale) AS net_sale,
COUNT(*) AS total_order
FROM retailsales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT AVG(age)
FROM retailsales
WHERE category = 'beauty';

SELECT ROUND(AVG(age),1) # ROUND() show 1st no roundoff
FROM retailsales
WHERE category = 'beauty';

--  Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retailsales
WHERE total_sale >= 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category, # if we have to go within the column declare in select 1 or more col
gender,
COUNT(*) AS tran_count
FROM retailsales
GROUP BY category,gender 
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year # IMP BUT NOT SOLVED
SELECT 
year_sales,month_sales,avg_sales
FROM(
SELECT
	YEAR(sale_date) AS year_sales , # extract year from given (col) value
	MONTH(sale_date) AS month_sales,
	AVG(total_sale) AS avg_sales,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retailsales
GROUP BY sale_date ,total_sale
) AS T
WHERE RANK = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
    SUM(total_sale) AS totalsales
FROM retailsales
GROUP BY customer_id          # show col in result table
ORDER BY 2 DESC
limit 5 ; # limit the col 

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retailsales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT *,
CASE                    # CREATE NEW COL WITH GIVEN LOGIC           STX
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'             # WHEN (CONDITION) OPEND THEN 'TEXT'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN ' Afternoon' # WHEN (CONDITION) OPEND THEN 'TEXT' no of condition
    ELSE 'Evening'                                                      # ELSE 'NOTE'
    END AS shift                                                        # CASE CONDITION END COLUMN DECL 
    FROM retailsales;

					           -- END OF PROJECT--
						    # WORDSMITH BY JITENDRA PANDE
