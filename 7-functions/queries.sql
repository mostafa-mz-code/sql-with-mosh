
-- numeric functions

SELECT ROUNd(5.7);
SELECT ROUNd(5.72, 1);

SELECT TRUNCATE(5.732, 2);

SELECT CEILING(5.3);
SELECT FLOOR(5.3);
SELECT ABS(-5.3);
SELECT RAND();


-- String functions

SELECT LENGTH("sky");
SELECT UPPER("sky");
SELECT LOWER("Sky");
SELECT RTRIM("sky ");
SELECT LTRIM(" sky");
SELECT TRIM(" sky ");
SELECT LEFT("Sky is blue", 3);
SELECT RIGHT("Sky is blue", 4);
SELECT SUBSTRING("Sky is blue", 1, 6);
SELECT SUBSTRING("Sky is blue", 3, 6);
SELECT SUBSTRING("Sky is blue", 3);
SELECT LOCATE('S', "Sky is blue");
SELECT LOCATE('B', "Sky is blue");
SELECT LOCATE('garten', "kindergarten");
SELECT LOCATE('king', "kindergarten");
SELECT REPLACE("kindergarten", "garten", "garden");

SELECT CONCAT("Sky", " is", " blue");


-- Date function


SELECT NOW(), CURRENT_DATE, CURTIME();
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAY(NOW());
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());
SELECT DAYNAME(NOW());
SELECT MONTHNAME(NOW());

-- use EXTRACT function when you need to share you queries with other DBMS's
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(HOUR FROM NOW());
SELECT EXTRACT(MINUTE FROM NOW());
SELECT EXTRACT(SECOND FROM NOW());
SELECT EXTRACT(DAYNAME FROM NOW());
SELECT EXTRACT(MONTHNAME FROM NOW());

-- formatting dates and times


SELECT DATE_FORMAT(NOW(), "%Y %M %D %W");

SELECT TIME_FORMAT(NOW(), "%H:%i:%S %p")

-- calculating dates and times

SELECT DATEDIFF("2020-01-01", "2026-01-01");
SELECT DATEDIFF( "2026-01-01","2020-01-01");

SELECT ABS(TIMEDIFF("2020-01-01 12:00:00", "2026-01-01 12:00:00"))

SELECT DATE_ADD('2020-01-01', INTERVAL 4 YEAR);

SELECT DATE_SUB('2020-01-01', INTERVAL 4 YEAR);

SELECT TIMESTAMPDIFF(YEAR, "2020-01-01", "2026-01-01");


-- ifnull and coalesce functions

USE sql_store;

SELECT 
customer_id,
IFNULL(shipped_date, "not assigned")
FROM orders

-- the IF function

SELECT 
order_id,
order_date,
IF(YEAR(order_date) = YEAR(NOW()),
'ACTIVE', 
'ARCHIVED') AS status
FROM orders;

-- the CASE operator

use sql_store;
SELECT
order_id,
CASE 
WHEN YEAR(order_date) = YEAR(NOW()) THEN 'ACTIVE'
WHEN YEAR(order_date) = YEAR(NOW()) - 1 THEN 'LAST YEAR'
WHEN YEAR(order_date) < YEAR(NOW()) THEN 'ARCHIVED'
ELSE 'FUTURE '
END AS category
FROM orders