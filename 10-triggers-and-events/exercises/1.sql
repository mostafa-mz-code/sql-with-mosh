-- create a trigger that gets fired when we delete a payment.


DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete ;

CREATE TRIGGER payments_after_delete
AFTER DELETE ON payments
FOR EACH ROW

BEGIN
UPDATE invoices
SET payment_total = payment_total - OLD.amount
WHERE invoice_id = OLD.invoice_id;
END $$
DELIMITER ;

-- delete the payment we just inserted to see the trigger in action.

DELETE FROM payments WHERE payment_id = 9;