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
    
*/

## Sales Performance Insights

# Top 20 Selling Products in 2024 
SELECT 
	RANK() OVER(ORDER BY SUM(Total_Amount) DESC) as "Rank",
	`Year`, Products, Country, Product_Type, Product_Brand, Product_Category, 
	FORMAT(SUM(Total_Amount), 'N','en-us') AS "Total_Spent_$"
FROM all_retail_sales
	WHERE Year = 2024
    AND Country = "Australia"
	GROUP BY Products, Country, Product_Type, Product_Brand, Product_Category, "Total_Spent_$"
	ORDER BY SUM(Total_Amount) DESC
	LIMIT 20;


# Top 20 Selling Products in 2023 
SELECT 
	RANK() OVER(ORDER BY SUM(Total_Amount) DESC) as "Rank",
	`Year`, Products, Country, Product_Type, Product_Brand, Product_Category, 
	FORMAT(SUM(Total_Amount), 'N','en-us') AS "Total Spent $"
FROM all_retail_sales
	WHERE Year = 2023
	GROUP BY Products, Country, Product_Type, Product_Brand, Product_Category
	ORDER BY SUM(Total_Amount) DESC
	LIMIT 20; 


# Top 20 Products by Revenue Across 2023 and 2024
SELECT 
	RANK() OVER(ORDER BY SUM(Total_Amount) DESC) as "Rank",
	`Year`, Products, Product_Type, Product_Brand, Product_Category,
	FORMAT(SUM(Total_Purchases), 'N', 'en-us') AS "Total Amount Purchased", 
	FORMAT(SUM(Total_Amount), 'N', 'en-us') AS "Total Spent $"
FROM all_retail_sales
	GROUP BY `Year`, Products, Product_Type, Product_Brand, Product_Category
	ORDER BY SUM(Total_Amount) DESC
	LIMIT 20; 


# Total Products Sold Per Country 2024
SELECT `Year`, Country,
	FORMAT(SUM(Total_Purchases), 'N', 'en-us') AS "Total Amount of Products Purchased 2024"
FROM all_retail_sales
	WHERE `Year` = 2024
	GROUP BY Country
	ORDER BY 3 DESC;


# Total Products Sold Per Country 2023
SELECT `Year`, Country,
	FORMAT(SUM(Total_Purchases), 'N', 'en-us') AS "Total Amount of Products Purchased 2023"
FROM all_retail_sales
	WHERE `Year` = 2023
	GROUP BY Country
	ORDER BY 3 DESC;

 
# Year on Year (YOY) Comparison - Total Amount of Products Purchased and Percentage Change
WITH cte1 AS (
    SELECT 
		`Year`,
        Country, 
        FORMAT(SUM(Total_Purchases), 'N', 'en-us') AS Total_Purchases_2023
    FROM 
        all_retail_sales
    WHERE 
        `Year` = 2023
        AND
        Country <> "N/A"
    GROUP BY `Year`, Country
    ),
    
    cte2 AS (
    SELECT 
		`Year`,
        Country, 
        FORMAT(SUM(Total_Purchases),'N', 'en-us') AS Total_Purchases_2024
    FROM 
         all_retail_sales
    WHERE 
         `Year` = 2024
         AND
         Country <> "N/A"
    GROUP BY `Year`, Country
    )
    SELECT 
    cte1.`Year`,
    cte1.Country,
    cte1.Total_Purchases_2023,
    cte2.`Year`,
    cte2.Country,
    cte2.Total_Purchases_2024,
    (SELECT FORMAT(SUM(Total_Purchases),'N', 'en-us') FROM all_retail_sales) AS Overall_Total_Purchases,
    (SELECT FORMAT(((cte2.Total_Purchases_2024 - cte1.Total_Purchases_2023) /
    cte1.Total_Purchases_2023 * 100), 'N','en-us')) AS Percentage_Change_YOY  
FROM 
    cte1
LEFT JOIN 
	cte2
ON cte1.Country = cte2.Country
ORDER BY 
    cte1.Total_Purchases_2023 DESC;


# Average Order Value (AOV)
SELECT FORMAT(AVG(Total_Amount), 'N', 'en-us') AS "Average Order Value (AOV) $"
FROM all_retail_sales;


# Average Order Quantity 
SELECT FORMAT(AVG(Total_Purchases), 'N', 'en-us') AS "Average Order Quantity"
FROM all_retail_sales; 


### Customer Insights 

## Do top spending customers follow a particular: gender, age and/or income pattern?

# Top 20 Spending Customers Overall
SELECT 
	ROW_NUMBER() OVER(ORDER BY Total_Amount DESC) as "Rank",
	Customer_ID, Full_Name, Gender, Age, Income, FORMAT((Total_Amount),'N', 'en-us') AS Total_Customer_Spend
FROM all_retail_sales
WHERE Country = "Australia"
	GROUP BY Customer_ID, Full_Name, Gender, Age, Income, Total_Amount
	ORDER BY Total_Amount DESC
	LIMIT 20;


# Percentage Split of Customers by Gender
SELECT 
	# Overall percentage of Male Customers
	ROUND(((SELECT COUNT(Gender) FROM all_retail_sales WHERE Gender = 'Male') 
	/ 
	(SELECT COUNT(Gender) FROM all_retail_sales) * 100),0) AS "% of Male Customers Overall",

	# Overall percentage of Female Customers
	ROUND(((SELECT COUNT(Gender) FROM all_retail_sales WHERE Gender = 'Female') 
	/
	(SELECT COUNT(Gender) FROM all_retail_sales) * 100),0) AS "% of Female Customers Overall"

FROM all_retail_sales
	GROUP BY Customer_ID, Transaction_ID, Gender, Age, Income, Total_Amount
	ORDER BY Total_Amount DESC
	LIMIT 1;


# Percentage Split of Customers By Income Level
SELECT
	# Overall percentage of Low Income Customers
	ROUND(((SELECT COUNT(Income) FROM all_retail_sales WHERE Income = 'Low') 
	/
	(SELECT COUNT(Income) FROM all_retail_sales) * 100),0) AS "% of Customers At Low Income Bracket",

	# Overall percentage of Medium Income Customers
	ROUND(((SELECT COUNT(Income) FROM all_retail_sales WHERE Income = 'Medium') 
	/ 
	(SELECT COUNT(Income) FROM all_retail_sales) * 100),0) AS "% of Customers At Medium Income Bracket",

	# Overall percentage of High Income Customers
	ROUND(((SELECT COUNT(Income) FROM all_retail_sales WHERE Income = 'High') 
	/ 
	(SELECT COUNT(Income) FROM all_retail_sales) * 100),0) AS "% of Customers At High Income Bracket"

FROM all_retail_sales
	GROUP BY Customer_ID, Transaction_ID, Gender, Age, Income, Total_Amount
	ORDER BY Total_Amount DESC
	LIMIT 1;


# Average Age of Customer
SELECT ROUND(AVG(Age),0) AS "Average Age of Customer"  
FROM all_retail_sales;



# Split of Customers By Recorded Age 
(SELECT 
    '18-25' AS Age_Ranges,
    FORMAT(COUNT(Customer_ID),'N', 'en-us') AS Customer_Count
FROM 
    all_retail_sales
WHERE 
    Age BETWEEN 18 AND 25)
UNION ALL
(SELECT 
    '26-40' AS Age_Ranges,
    FORMAT(COUNT(Customer_ID),'N', 'en-us') AS Customer_Count
FROM 
    all_retail_sales
WHERE 
    Age BETWEEN 26 AND 40)
UNION ALL
(SELECT 
    '41-70' AS Age_Ranges,
    FORMAT(COUNT(Customer_ID),'N', 'en-us') AS Customer_Count
FROM 
    all_retail_sales
WHERE 
    Age BETWEEN 41 AND 70
ORDER BY 
    Customer_Count DESC);


# How much revenue is driven by repeat vs new customers? 

# Total Transactions From Repeat Customers (More Than One Transaction)
SELECT 
	FORMAT((COUNT(Customer_ID) OVER())  ,'N','en-us') AS Total_Transaction_Count_From_Repeat_Customers
FROM all_retail_sales
	GROUP BY Customer_ID, Full_Name, Customer_ID
	HAVING COUNT(Customer_ID) > 1
	ORDER BY COUNT(Customer_ID) DESC
	LIMIT 1;


# Total Transactions From One-Off/New Customers
SELECT 
	FORMAT((COUNT(Customer_ID) OVER())  ,'N','en-us') AS Total_Transaction_Count_From_One_Off_Customers
FROM all_retail_sales
	GROUP BY Customer_ID, Full_Name, Customer_ID
	HAVING COUNT(Customer_ID) = 1
	ORDER BY COUNT(Customer_ID) DESC 
	LIMIT 1;

SELECT
	(SELECT
		FORMAT((COUNT(Customer_ID) OVER())  ,'N','en-us')
	FROM all_retail_sales
		GROUP BY Customer_ID, Full_Name, Customer_ID
		HAVING COUNT(Customer_ID) > 1
		ORDER BY COUNT(Customer_ID) DESC LIMIT 1) AS "Total Transaction Count From Repeat Customers",
	(SELECT 
		FORMAT((COUNT(Customer_ID) OVER())  ,'N','en-us') 
	FROM all_retail_sales
	GROUP BY Customer_ID, Full_Name, Customer_ID
	HAVING COUNT(Customer_ID) = 1
	ORDER BY COUNT(Customer_ID) DESC 
		LIMIT 1) AS "Total Transaction Count From One Off Customers",
		FORMAT( (SELECT(52712 / 159334) * 100), 'N','en-us') AS "Repeat Customers Percentage",
		FORMAT( (SELECT(106622 / 159334) * 100), 'N', 'en-us') AS "Once Off Customers Percentage"
	FROM all_retail_sales
	LIMIT 1;


# Product (Market) Trends 

# Underperforming Products 

# Products That Have Sold Less Than 10 Units and With Customer Rating Less Than 5
SELECT 
	Products, Product_Brand, Country, Product_Type, Ratings, SUM(Total_Purchases) "Total Purchases Of Product"
FROM all_retail_sales
GROUP BY Products, Product_Brand, Country, Product_Type, Ratings, "Total Purchases"
HAVING SUM(Total_Purchases) < 10 AND Ratings < 5
ORDER BY Product_Type;


# Products That Have Sold Just One Unit And Have Rating Lower Than 5 
SELECT 
	Products, Product_Brand, Country, Product_Type, Ratings, SUM(Total_Purchases) "Total Purchases Of Product"
FROM all_retail_sales
GROUP BY Products, Product_Brand, Country, Product_Type, Ratings, "Total Purchases"
HAVING SUM(Total_Purchases) = 1 AND Ratings < 5
ORDER BY Product_Type;


# Which product categories are performing? and which are not?

# Top 20 Selling Categories 
SELECT 
	Product_Category, Country, ROUND(AVG(Ratings),0) AS "Average Product Rating",
    FORMAT(SUM(Total_Purchases), 'N', 'en-us') "Total Purchases In Product Category"
FROM all_retail_sales
GROUP BY Product_Category, Country, Ratings 
ORDER BY SUM(Total_Purchases) DESC
LIMIT 20;


# 20 Lowest Selling Product Categories 
SELECT
	Product_Category, Country, ROUND(AVG(Ratings),0) "Average Product Rating" ,
    FORMAT(SUM(Total_Purchases), 'N', 'en-us') "Total Purchases In Product Category"
FROM all_retail_sales
GROUP BY Product_Category, Country, Ratings 
ORDER BY SUM(Total_Purchases) ASC
LIMIT 20;


# Are there particular brands performing better/worse than others?

# Best Selling Brands By Country
SELECT 
	Product_Brand, Country, `Year`, FORMAT(SUM(Total_Purchases), 'N','en-us') 
    "Total Purchases Of Brand In Country"
FROM all_retail_sales
GROUP BY Product_Brand, Country, `Year`
ORDER BY SUM(Total_Purchases) DESC;


# Brands That Have Sold Just One Unit And Have Rating Lower Than 5 
SELECT
	Product_Brand, Country, Ratings, SUM(Total_Purchases) "Total Purchases Of Product"
FROM all_retail_sales
WHERE Country <> "N/A"
AND Product_Brand <> "N/A"
GROUP BY Products, Product_Brand, Country, Product_Type, Ratings, "Total Purchases"
HAVING SUM(Total_Purchases) = 1 AND Ratings < 5;
