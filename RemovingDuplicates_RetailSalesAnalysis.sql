# Removing duplicates 

# Searches for duplicated transactions (i.e. Transaction_ID) with either COUNT or window function
SELECT Transaction_ID, COUNT(Transaction_ID)
FROM new_retail_data
GROUP BY Transaction_ID
HAVING COUNT(Transaction_ID) > 1;

