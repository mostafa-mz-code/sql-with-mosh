-- find the customers who have more than 3000 points
-- treat them as gold customers and update their comment on orders to "GOLD CUSTOMER"
USE sql_store;

UPDATE orders
SET
  comments = 'GOLD CUSTOMER'
WHERE
  customer_id IN (
    SELECT
      customer_id
    FROM
      customers
    WHERE
      points > 3000
      and order_date is not null
  )