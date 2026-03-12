-- write a query that lists, all the customers 
-- full name and phone numbers
-- if no phone number is available, use 'unknown'

USE sql_store;

SELECT
CONCAT(first_name, ' ', last_name) as customer,
IFNULL(phone, "unknown") as phone
FROM customers;