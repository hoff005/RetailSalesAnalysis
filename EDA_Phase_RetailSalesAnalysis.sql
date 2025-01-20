/* ### EDA Phase - Exploratory Data Analysis

 I will be analysing this data to uncover the below insights: 
   
   Sales Performance Insights
   - Which products or services are generating the most revenue?
   - How many products in total were sold in 2023 vs 2024? Year on year (YOY) comparison
   - What is the average order value (AOV)? 
   
   Customer Insights 
   - Do top spending customers follow a particular: gender, age and/or income pattern?
   - Percentages of customers by: gender, age and income
   - How much revenue is driven by repeat vs new customers? 
   
   Product (Market) Trends
   - Which products are underperforming? 
   - Which product categories are performing? and which are not?
   - Are there particular brands performing better/worse than others?

	Are there any more notable trends in general prevailing throughout the data?
    
*/
SELECT * FROM sales_analysis_db.new_retail_data;

## Sales Performance Insights

# Which products or services generated the most revenue in 2024? 
SELECT `Year`, products, product_Type, Product_Brand, Product_Category, ROUND(SUM(Total_Amount),2) AS "Total Spent"
FROM new_retail_data
WHERE Year = 2024
GROUP BY products, product_Type, Product_Brand, Product_Category
ORDER BY SUM(Total_Amount) DESC;

# Which products or services generated the most revenue in 2023? 
SELECT `Year`, products, product_Type, Product_Brand, Product_Category, ROUND(SUM(Total_Amount),2) AS "Total Spent"
FROM new_retail_data
WHERE Year = 2023
GROUP BY products, product_Type, Product_Brand, Product_Category
ORDER BY SUM(Total_Amount) DESC; 

# Or most overall across 2024 and 2023
SELECT `year`, products, product_Type, Product_Brand, Product_Category, SUM(Total_Purchases) AS "Total Amount Purchased", ROUND(SUM(Total_Amount),2) AS "Total Spent"
FROM new_retail_data
GROUP BY `year`, products, product_Type, Product_Brand, Product_Category
ORDER BY SUM(Total_Amount) DESC; 


# How many products in total were sold in 2023?
SELECT `Year`,
SUM(Total_Purchases) AS "Total Amount of Products Purchased in 2023"
FROM new_retail_data
WHERE `Year` IN (2023);


# How many products in total were sold in 2024?
SELECT `Year`, SUM(Total_Purchases) AS "Total Amount of Products Purchased in 2024"
FROM new_retail_data
WHERE `Year` IN (2024)
GROUP BY `Year`;

 
# Displays comparison of YOY Growth of Total Amount of Products Purchased and Percentage Decrease In Total Amount of Products Purchased
SELECT
(
SELECT
SUM(Total_Purchases)
FROM new_retail_data
WHERE `Year` = 2023
)  AS "Total Amount of Products Purchased 2023",
(
SELECT
SUM(Total_Purchases)
FROM new_retail_data 
WHERE `Year` = 2024
)  AS "Total Amount of Products Purchased 2024", 
(8999-44182) / 8999 * 100 AS "Percentage Change_Total Products Purchased"
FROM new_retail_data
GROUP BY Year
LIMIT 1;


#- What is the average order value (AOV)?
SELECT ROUND(AVG(Total_Amount),2) AS "Average Order Value (AOV)"
FROM new_retail_data;

#- What is the average order quantity?
SELECT ROUND(AVG(Total_Purchases),0) AS "Average Order Quantity"
FROM new_retail_data; 


### Customer Insights 

## Do top spending customers follow a particular: gender, age and/or income pattern?

# Displays Top Spending Customers Overall 
SELECT Customer_ID, Transaction_ID, Gender, Age, Income, Total_Amount
FROM new_retail_data
GROUP BY Customer_ID, Transaction_ID, Gender, Age, Income, Total_Amount
ORDER BY Total_Amount DESC;


# Uncovers Percentages of Customers By Gender
SELECT 
# Overall percentage of Male Customers
ROUND(((SELECT COUNT(Gender) FROM new_retail_data WHERE Gender = 'Male') 
/ 
(SELECT COUNT(Gender) FROM new_retail_data) * 100),0) AS "% of Male Customers Overall",

# Overall percentage of Female Customers
ROUND(((SELECT COUNT(Gender) FROM new_retail_data WHERE Gender = 'Female') 
/
(SELECT COUNT(Gender) FROM new_retail_data) * 100),0) AS "% of Female Customers Overall",

# Overall percentage of Low Income Customers
((SELECT COUNT(Income) FROM new_retail_data WHERE Income = 'Low') 
/ 
(SELECT COUNT(Income) FROM new_retail_data) * 100) AS "% of Customers At Low Income Bracket",

# Overall percentage of Medium Income Customers
((SELECT COUNT(Income) FROM new_retail_data WHERE Income = 'Medium') 
/ 
(SELECT COUNT(Income) FROM new_retail_data) * 100) AS "% of Customers At Medium Income Bracket",

# Overall percentage of High Income Customers
((SELECT COUNT(Income) FROM new_retail_data WHERE Income = 'High') 
/ 
(SELECT COUNT(Income) FROM new_retail_data) * 100) AS "% of Customers At High Income Bracket",

# Average Age of Customer
ROUND(AVG(Age),0) AS "Average Age of Customers"  
FROM new_retail_data
GROUP BY Customer_ID, Transaction_ID, Gender, Age, Income, Total_Amount
ORDER BY Total_Amount DESC
LIMIT 1;


# Total instances of gender
SELECT COUNT(Gender) FROM new_retail_data; #9880

# Total instances of male 
SELECT COUNT(Gender) FROM new_retail_data WHERE Gender = 'Male'; #5915

# Total instances of female 
SELECT COUNT(Gender) FROM new_retail_data WHERE Gender = 'Female'; #3950 



# How much revenue is driven by repeat vs new customers? 

# Customers with multiple transactions and how many transactions there are
# Have discovered, through the below query, that there instances of customers with the same Customer ID 
SELECT 
Customer_ID, 
first_name, 
last_name, 
Transaction_ID,
COUNT(Customer_ID) OVER(PARTITION BY Customer_ID) AS Customer_Transaction_Count 
FROM new_retail_data
ORDER BY Customer_Transaction_Count DESC;


# Assigns a unique customer ID to every individual customer 
SELECT customer_ID, transaction_ID, first_name, last_name, CONCAT("C000",ROW_NUMBER () OVER()) AS New_Customer_ID
FROM new_retail_data;

# Creates a new column New_Customer_ID
ALTER TABLE new_retail_data
ADD COLUMN New_Customer_ID varchar(50);


# Inserts above New_Customer_ID values into new New_Customer_ID field 
