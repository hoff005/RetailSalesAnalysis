**Project Background**

This is a retail sales data cleaning and Exploratory Data Analysis (EDA) project based upon the an abridged version of this dataset: https://www.kaggle.com/datasets/sahilprajapati143/retail-analysis-large-dataset/data
I have taken a sample of 9,880 rows for example purposes and worked on the following: 

**Data Cleaning**
-	creating a staging copy of the database table, 
-	splitting fields into more logical/understandable names using regular expressions
-	reformatted some numbers with rounding for readability  
-	appended phone numbers and date formats with SUBSTRING functionalities
-	appended blank values to NULLs, sought to update these fields/rows where possible and found and removed duplicates using window functions. 

**Exploratory Data Analysis (EDA)**

Where analysis was conducted with the following insights to be gleaned, in focus:

**Sales Performance Insights**
-	Which products or services are generating the most revenue?
-	How many products in total were sold in 2023 vs 2024? Year on year (YOY)
comparison
-	What is the average order value (AOV)?    

**Customer Insights**
-	Do top spending customers follow a particular: gender, age and/or income
pattern?
-	Percentages of customers by: gender, age and income
-	How much revenue is driven by repeat vs new customers? 
  
**Product (Market) Trends**
-	Which products are underperforming? 
-	Which product categories are performing? and which are not?
-	Are there particular brands performing better/worse than others?
And any other, not previously noted, notable trends in general prevailing throughout the data. 
