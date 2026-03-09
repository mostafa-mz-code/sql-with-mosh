SELECT *
FROM orders
WHERE order_date >= '2019-01-01'

SELECT *
FROM order_items
WHERE order_id = 6 AND unit_price * quantity > 30
