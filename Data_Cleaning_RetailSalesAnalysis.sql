### DATA CLEANING TASKS

#Some example code that was written to perform the below tasks; some of these steps in particular were later abandoned in favour of completing these faster in excel
#Leaving these just to show my work and evidence the ability to do this in SQL also  
	
# Creates staging copy of the database
CREATE TABLE all_retail_data_staging AS SELECT * FROM all_retail_data;

### Example Splitting of Columns - Name field  
# Splits out `Name` column into `first name` and `last name` columns 
SELECT  
  SUBSTRING_INDEX(Name," ",1) AS first_name_,
  SUBSTRING_INDEX(SUBSTRING_INDEX(Name," ",2)," ",-1) AS last_name_
FROM all_retail_data;


# Adds new first_name and last_name columns to database 
ALTER TABLE all_retail_data
ADD first_name_ varchar(60),
ADD last_name_ varchar(60);


# Insert the above split of first and last names into the newly created columns
UPDATE all_retail_data
SET first_name_ =
	(SELECT  
	SUBSTRING_INDEX(Name," ",1) AS first_name_),
	last_name_ =
	(SELECT(SUBSTRING_INDEX(SUBSTRING_INDEX(Name," ",2)," ",-1)) AS last_name_);


# Subsequently drop "Name" column no longer required 
ALTER TABLE all_retail_data
DROP COLUMN Name; 


# Renames transaction ID column removing special characters preceding 
ALTER TABLE all_retail_data
RENAME COLUMN `ï»¿Transaction_ID` TO `Transaction_ID`; 


### Address field formatting

# Splits Address column out into street_number and street_name
SELECT
  SUBSTRING_INDEX(Address," ",1) AS street_number,
  REGEXP_SUBSTR(Address,' .+') AS street_name
 FROM all_retail_data;


# Adds new street_number and street_name columns to database 
ALTER TABLE all_retail_data
ADD COLUMN street_number varchar(10),
ADD COLUMN street_name varchar(60);


# Updates newly created street_number and street_name columns
UPDATE all_retail_data
SET street_number = 
	(SELECT SUBSTRING_INDEX(Address," ",1) AS street_number);
SET street_name =
	(SELECT REGEXP_SUBSTR(Address,' .+') AS street_name);


# Split out remaining Apt. Number and Suite Details from Address Field 
SELECT Address, REGEXP_SUBSTR(Address,'Apt.+') AS Apt_Number, REGEXP_SUBSTR(Address,'Suite.+') AS Suite
FROM all_retail_data;


# Add the two new columns Apt_Number and Suite and update the columns with the values 
ALTER TABLE all_retail_data
ADD COLUMN Apt_Number varchar(10),
ADD COLUMN Suite varchar(60);


# Insert the above split Apt. No. and Suite details into the newly created columns
UPDATE all_retail_data
SET Apt_Number =
(SELECT REGEXP_SUBSTR(Address, 'Apt.+')); 

UPDATE all_retail_data
SET Suite =
(SELECT REGEXP_SUBSTR(Address, 'Suite.+'));


# Trims the "Apt. and number" off the end of the street name field
UPDATE all_retail_data 
SET street_name = (SELECT REGEXP_REPLACE(street_name, 'Apt.+', ''));


# Trims the "Suite and number" off the end of the street name field
UPDATE all_retail_data 
SET street_name = (SELECT REGEXP_REPLACE(street_name, 'Suite.+', ''));


# Renames the Address Field to Full_Address
ALTER TABLE all_retail_data
RENAME COLUMN Address to Full_Address;


/*
Now have split out Address field as separate fields and have
retained a column with full address - in case there is a need to filter
by either of these:
 - street_number
 - street_name
 - Apt_Number and
 - Suite
*/


### Rounding totals formatting  

# Round Total_Amount to 2 decimal places 
UPDATE all_retail_data
SET Total_Amount = ROUND(Total_Amount,2); 


# Round Amount to 2 decimal places 
UPDATE all_retail_data
SET Amount = ROUND(Amount,2); 


### Phone number formatting  

# Phone number reformating for readability
SELECT Phone, CONCAT(SUBSTRING(Phone,1,3),"-", SUBSTRING(Phone,4,3),"-", SUBSTRING(Phone,7,4))
FROM all_retail_data
WHERE Phone <> '';

 
# Update the reformatted Phone number for readability
UPDATE all_retail_data
SET `Phone` = CONCAT(SUBSTRING(Phone,1,3),"-", SUBSTRING(Phone,4,3),"-", SUBSTRING(Phone,7,4))
WHERE `Phone` <> '';

# Did not work so have to change the datatype of Phone field to accomodate
ALTER TABLE all_retail_data
MODIFY COLUMN Phone varchar(12);


### Date reformating

# Standardises Date Field to Australian date format DD-MM-YYYY 
SELECT CONCAT(SUBSTRING(newDateFormat,9,2), "-", SUBSTRING(newDateFormat,6,2),"-", SUBSTRING(newDateFormat,1,4)) AS Transaction_Date
FROM (
		SELECT STR_TO_DATE(`Date`,"%m/%d/%Y") AS newDateFormat 
		FROM all_retail_data) AS newDateFormat;

        
# Adds a new column Transaction_Date to replace Date field
ALTER TABLE all_retail_data
ADD Transaction_Date date;























