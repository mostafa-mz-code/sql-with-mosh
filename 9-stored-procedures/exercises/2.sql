-- write a stored procedure to return invoices
-- for a given client
--
-- get_invoices_by_client_id

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client_id ( id INT )

BEGIN
SELECT *
FROM invoices i
WHERE i.client_id = id;

END $$
DELIMITER ;

-- call the procedure

CALL get_invoices_by_client_id(1);