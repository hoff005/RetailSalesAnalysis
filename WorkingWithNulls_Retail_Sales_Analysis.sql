###  Working with NULL Values

# Some example code that was written to perform the below tasks; some of these steps in particular were later abandoned in favour of completing these faster in excel
# Leaving these just to show my work and evidence the ability to do this in SQL also

# Finding each column that has blank '' values and replacing with NULL values
# Can find them by searching each individual column name in the formula below
# replacing the colum name in the formula with whatever column name we are searching for blanks in

SELECT COUNT(Address)
FROM all_retail_sales
WHERE Email IS NULL;


# In the case of the email column I found 8 blanks ''  
# Will replace these with NULLs

UPDATE all_retail_sales
SET Email = NULL 
WHERE Email = '';

# In the case of the Full_Address column I found 3 blanks ''  
# Will replace these with NULLs

UPDATE all_retail_sales
SET Email = NULL 
WHERE Email = '';

# And so and so forth for each column 
UPDATE all_retail_sales
SET Phone = NULL 
WHERE Phone = '';

# went through and ran first the select code then the update code to update to NULLs if any blanks '' were found
# now no longer and blanks and are replaced with NULLs 


# Locating the transaction records with NULL - In the case of Email 
SELECT *
FROM all_retail_sales
WHERE Email IS NULL;

# Do something like assign a gmail address and thus avoid NULLs in the email column 
UPDATE all_retail_sales 
SET Email = (SELECT(CONCAT(first_name, last_name,"@gmail.com")))
WHERE Email IS NULL; 
 
# Check to see it correctly returns no more NULL values in the email column
SELECT *
FROM all_retail_sales
WHERE Email IS NULL;


# Show the 3 x NULLs in Full_Address column 
SELECT *
FROM all_retail_sales
WHERE Full_Address IS NULL;


# Show the 8 x NULLs in Date column 
SELECT *
FROM all_retail_sales
WHERE `Date` IS NULL;


# Show the 18 x NULLs in Month column 
SELECT *
FROM all_retail_sales
WHERE Month IS NULL;
 
