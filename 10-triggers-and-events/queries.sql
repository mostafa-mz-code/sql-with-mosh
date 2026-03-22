DELIMITER $$

CREATE TRIGGER payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW

BEGIN
UPDATE invoices
SET payment_total = payment_total + NEW.amount
WHERE invoice_id = NEW.invoice_id;
END $$

DELIMITER ;


INSERT INTO payments VALUES(DEFAULT, 5, 3, '2026-01-01', 10, 1);



-- Viewing triggers
SHOW TRIGGERS like 'payments%';

-- dropping a trigger

DROP TRIGGER payments_after_insert;


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


-- ------------------------ auditing version of the above triggers ------------------------

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert ;
CREATE TRIGGER payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW

BEGIN
UPDATE invoices
SET payment_total = payment_total + NEW.amount
WHERE invoice_id = NEW.invoice_id;

INSERT INTO payments_audit
VALUES(NEW.client_id, NEW.date, NEW.amount, 'INSERT', NOW());
END $$

DELIMITER ; 

-- AFTER DELETE trigger



DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete ;

CREATE TRIGGER payments_after_delete
AFTER DELETE ON payments
FOR EACH ROW

BEGIN
UPDATE invoices
SET payment_total = payment_total - OLD.amount
WHERE invoice_id = OLD.invoice_id;

INSERT INTO payments_audit
VALUES(OLD.client_id, OLD.date, OLD.amount, 'DELETE', NOW());

END $$
DELIMITER ;


--- testing the audit triggers now

INSERT INTO payments VALUES(DEFAULT, 5, 3, '2026-01-01', 10, 1);

DELETE FROM payments WHERE payment_id = 11; 

-------- events ---------


-- check if the event scheduler is enabled

SHOW VARIABLES LIKE 'event%';

-- enable the event scheduler, if it's not enabled already.

SET GLOBAL event_scheduler = ON;


-- create an event

DELIMITER $$

-- Note: 
-- to name an event, always use the format: <frequency>_<action>_<table_name>
-- for example: yearly_delete_stale_audit_rows
CREATE EVENT yearly_delete_stale_audit_rows

-- ON SCHEDULE AT '2026-01-01' schedules the event to run on the specified date, only once.
-- ON SCHEDULE EVERY 1 YEAR schedules the event to run every year, starting from the moment it's created.
-- EVERY 1 YEAR STARTS '2026-01-01' ENDS '2030-01-01', cerates an event that runs every year, starting from 2026-01-01 and ending on 2030-01-01.

ON SCHEDULE 
EVERY 1 YEAR STARTS '2026-01-01' ENDS '2030-01-01' 
DO
BEGIN
DELETE FROM payments_audit
WHERE action_date < DATE_SUB(NOW(), INTERVAL 1 YEAR);

END $$

DELIMITER ;


------------------------- viewing events ----------------------------

SHOW EVENTS;
SHOW EVENTS LIKE 'yearly%';

--- DROP EVENTS

DROP EVENT IF EXISTS yearly_delete_stale_audit_rowSs;

-- ALTER events, for example, to change the schedule of an event.
ALTER EVENT yearly_delete_stale_audit_rows
ON SCHEDULE 
EVERY 1 YEAR STARTS '2026-01-01' ENDS '2035-01-01' 
DO
BEGIN
DELETE FROM payments_audit
WHERE action_date < DATE_SUB(NOW(), INTERVAL 1 YEAR);

END $$

-- Or disable an event without dropping it.
ALTER EVENT yearly_delete_stale_audit_rows DISABLE; 
-- and
ALTER EVENT yearly_delete_stale_audit_rows ENABLE;