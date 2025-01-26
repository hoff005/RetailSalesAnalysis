# REMOVING DUPLICATE TRANSACTIONS 

# Some example code that was written to perform the below tasks; some of these steps in particular were later abandoned in favour of completing these faster in excel
# Leaving these just to show my work and evidence the ability to do this in SQL also*/  

# Searches for duplicated transactions (i.e. Transaction_ID) with either COUNT or window function
SELECT Transaction_ID, COUNT(Transaction_ID)
FROM new_retail_data
GROUP BY Transaction_ID
HAVING COUNT(Transaction_ID) > 1;


SELECT *
FROM  (
		SELECT Transaction_ID,
		ROW_NUMBER() OVER (PARTITION BY Transaction_ID ORDER BY Transaction_ID) AS row_num
		FROM new_retail_data) AS table_row
		WHERE row_num > 1; 


# Removes the found duplicate transaction_IDs below
/*
1129797
1636104
3060058
4117992
4428772
7176556
*/ 

DELETE FROM new_retail_data
WHERE Transaction_ID IN (

SELECT Transaction_ID
FROM  (
		SELECT Transaction_ID,
		ROW_NUMBER() OVER (PARTITION BY Transaction_ID ORDER BY Transaction_ID) AS row_num
		FROM new_retail_data) AS table_row
		WHERE row_num > 1);
		
 # To check if the deletion occured without error
 SELECT Transaction_ID
 FROM new_retail_data
 WHERE Transaction_ID = 1129797
	OR Transaction_ID = 1636104
 	OR Transaction_ID = 3060058
	OR Transaction_ID = 4117992
	OR Transaction_ID = 4428772
	OR Transaction_ID = 7176556;

# no results found; meaning they are successfully deleted
