-- Create a stored procedure called
-- get_invoices_with_balance
-- to return all the invoices with a balance > 0

DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
SELECT
  invoice_id,
  client_id,
  invoice_total,
  payment_total,
  SUM(invoice_total - payment_total) AS balance
FROM
  invoices
GROUP BY invoice_id
HAVING SUM(invoice_total - payment_total) > 0;
END$$
DELIMITER ;

-- or we can use the already existing view invoice_with_balances

DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
SELECT * FROM invoices_with_balance
where balance > 0;
END $$
DELIMITER ;