SELECT *
FROM products AS p
INNER JOIN order_items AS oi
  ON p.product_id = oi.product_id