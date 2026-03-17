-- Write a stored procedure called get_payments
-- with two parameters
--
-- client_id => INT(4)
-- payment_method_id => TINYINT(1) 
-- 
-- both parameters should check for NULL and return all payments if the parameter is NULL
DROP PROCEDURE IF EXISTS get_payments;

--  DELIMITER $$
CREATE PROCEDURE get_payments (client_id INT , payment_method_id TINYINT ) BEGIN
SELECT
  *
FROM
  payments p
WHERE
  p.client_id = IFNULL (client_id, p.client_id)
  AND p.payment_method = IFNULL (payment_method_id, p.payment_method);

END
--  DELIMITER ;
select
  *
from
  payments
where
  client_id = 3
  or payment_method = 1;

CALL get_payments (null, 2 );