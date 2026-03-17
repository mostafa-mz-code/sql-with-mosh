DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
  SELECT * FROM clients;
END$$
DELIMITER ;


CALL get_clients();

-- parameters

DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$

CREATE PROCEDURE get_clients_by_state (state VARCHAR(2))
BEGIN
  SELECT * FROM clients c
  WHERE c.state = state;
  
END $$

DELIMITER ;

CALL get_clients_by_state('CA');

-- procedures with default value for parameters

DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state( state CHAR(2))
BEGIN 
-- use IF statement to set default value for state parameter
IF state IS NULL THEN
SET state = 'CA';
END IF;
-- always end the if statement with END IF
SELECT * FROM clients c
WHERE c.state = state ;
END $$
DELIMITER ;


-- call our procedure with default value
-- but the default value is only returned when we pass NULL as the parameter value

CALL get_clients_by_state(NULL);

-- if you call a procedure without passing it a value for the parameter, it will return an error because the parameter is required
CALL get_clients_by_state();

-- checking for more than one value for the parameter
DELIMITER $$

CREATE PROCEDURE get_clients_by_state( state CHAR(2))
BEGIN 

-- use IF statement to set default value for state parameter
IF state IS NULL THEN
SELECT * FROM clients;

ELSE
SELECT * FROM clients c
WHERE c.state = state ;

END IF;
-- always end the if statement with END IF
END $$
DELIMITER ;

CALL get_clientS_by_state("nu");

-- using IFNULL for checking the null condition

DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$

CREATE PROCEDURE get_clients_by_state( state CHAR(2))

BEGIN

SELECT * FROM clients c
WHERE c.state = IFNULL(state, c.state);

END $$

DELIMITER;

CALL get_clients_by_state("ca");


-- create a procedure to make a payments

DROP PROCEDURE IF EXISTS make_payment;
DELIMITER $$

CREATE PROCEDURE make_payment (
  invoice_id INT,
  payment_amount DECIMAL(9, 2),
  payment_date DATE
)
BEGIN

IF payment_amount <= 0 THEN
  SIGNAL SQLSTATE '22003'
    SET MESSAGE_TEXT = 'Invalid payment amount';
    END IF;
UPDATE invoices i
SET
  i.payment_total = payment_amount,
  i.payment_date = payment_date
WHERE
  i.invoice_id = invoice_id;
  
END

DELIMITER ;

CALL make_payment(2, -100, '2019-01-01');

-- output parameters

DELIMITER $$

CREATE PROCEDURE get_unpaid_invoices_for_client (client_id INT)

BEGIN 

SELECT COUNT(*), SUM(invoice_total)
FROM invoices i
WHERE i.client_id = client_id AND payment_total = 0;

END $$
DELIMITER ;

CALL get_unpaid_invoices_for_client(3);

-- output parameters

DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;

DELIMITER $$

CREATE PROCEDURE get_unpaid_invoices_for_client (client_id INT,
OUT invoices_count INT,
OUT invoices_total DECIMAL(9, 2))

BEGIN 

SELECT COUNT(*), SUM(invoice_total)
INTO invoices_count, invoices_total
FROM invoices i
WHERE i.client_id = client_id AND payment_total = 0;

END $$
DELIMITER ;

SET @invoices_count = 0;
SET @invoices_total = 0;
CALL get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);

SELECT @invoices_count, @invoices_total; 

-- variables

DROP PROCEDURE IF EXISTS get_risk_factor;

DELIMITER $$
CREATE PROCEDURE get_risk_factor ()

BEGIN
DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
DECLARE invoiceS_total DECIMAL(9,2);
DECLARE invoices_count INT;
-- risk_factor = invoices_total / invoices_count * 5

SELECT COUNT(*), SUM(invoice_total)
INTO invoices_count, invoices_total
FROM invoices;

SET risk_factor = invoices_total / invoices_count * 5;
SELECT risk_factor;

END $$
DELIMITER ; 

CALL get_risk_factor();


-- functions

DROP FUNCTION IF EXISTS get_risk_factor_for_client;
DELIMITER $$

CREATE FUNCTION get_risk_factor_for_client(client_id INT)
RETURNS INTEGER
READS SQL DATA
BEGIN
DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
DECLARE invoiceS_total DECIMAL(9,2);
DECLARE invoices_count INT;
-- risk_factor = invoices_total / invoices_count * 5

SELECT COUNT(*), SUM(invoice_total)
INTO invoices_count, invoices_total
FROM invoices i
WHERE i.client_id = client_id;

SET risk_factor = invoices_total / invoices_count * 5;

RETURN IFNULL(risk_factor, 0);
END $$
DELIMITER ;


-- calling the function

SELECT client_id, name, get_risk_factor_for_client(client_id) AS risk_factor  from clients;