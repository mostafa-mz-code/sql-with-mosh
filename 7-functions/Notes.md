# Functions

n SQL, functions are reusable blocks of code that perform a specific calculation or operation and return a single value. They help you clean data, perform math, or manipulate text without writing complex logic every time.

## Numeric Functions

SQL provides a variety of built-in numeric functions to perform mathematical operations, from simple rounding to complex calculations. 
Core Mathematical Functions
These are the most common functions for adjusting or evaluating numbers:

- ROUND(number, decimals): Rounds a value to a specified number of decimal places. If the next digit is 5 or greater, it rounds up; otherwise, it rounds down.
- Example: ROUND(15.678, 2) $\rightarrow$ 15.68
- TRUNCATE(number, decimals): Removes decimal places without any rounding. It simply "cuts off" the digits after the specified position.
- Example: TRUNCATE(15.678, 2) $\rightarrow$ 15.67
- CEILING(number) (or CEIL): Rounds a number up to the nearest whole integer, regardless of the decimal value.
- Example: CEILING(12.34) $\rightarrow$ 13
- FLOOR(number): Rounds a number down to the nearest whole integer.
- Example: FLOOR(12.98) $\rightarrow$ 12
- ABS(number): Returns the absolute value, effectively removing the negative sign from any number.
- Example: ABS(-25) $\rightarrow$ 25
- RAND(): Generates a random floating-point number between 0 (inclusive) and 1 (exclusive). Some systems use RANDOM(). 

---

Other Useful Numeric Functions
Beyond the basics, these functions are helpful for more specific logic:

| Function [7, 9, 15, 16, 17, 18, 19, 20, 21] | Purpose                                                        | Example                       |
| ------------------------------------------- | -------------------------------------------------------------- | ----------------------------- |
| MOD(n, m)                                   | Returns the remainder of $n$ divided by $m$.                   | MOD(10, 3) $\rightarrow$ 1    |
| POWER(base, exp)                            | Raises the base to the specified power.                        | POWER(2, 3) $\rightarrow$ 8   |
| SQRT(number)                                | Calculates the square root of a positive number.               | SQRT(16) $\rightarrow$ 4      |
| SIGN(number)                                | Returns 1 for positive, -1 for negative, and 0 for zero.       | SIGN(-50) $\rightarrow$ -1    |
| EXP(number)                                 | Returns $e$ (approx. 2.718) raised to the power of the number. | EXP(1) $\rightarrow$ 2.718... |
| LOG(number)                                 | Returns the natural logarithm (base $e$) of a number.          | LOG(10) $\rightarrow$ 2.30... |

Key Differences to Remember

- ROUND vs. TRUNCATE: Rounding changes the final digit based on the following number; truncation never changes the digits it keeps.
- CEILING vs. FLOOR: On negative numbers, CEILING(-1.5) is -1 (closer to zero), while FLOOR(-1.5) is -2 (further from zero). [8, 10, 22, 23]

## String Functions

These string functions allow you to measure, clean, and manipulate text data within your queries. Here is the breakdown of how each one works:
1. Basic Transformation & Measurement

* LENGTH("sky"): Returns the number of characters in a string.
* Result: 3
* UPPER("sky"): Converts all characters to uppercase.
* Result: "SKY"
* LOWER("Sky"): Converts all characters to lowercase.
* Result: "sky"

2. Trimming (Removing White Space)

* RTRIM("sky "): Removes spaces from the right side only.
* LTRIM(" sky"): Removes spaces from the left side only.
* TRIM(" sky "): Removes spaces from both ends.

3. Extracting Portions of a String

* LEFT("Sky is blue", 3): Pulls the first $X$ characters from the left.
* Result: "Sky"
* RIGHT("Sky is blue", 4): Pulls the last $X$ characters from the right.
* Result: "blue"
* SUBSTRING(string, start, [length]): Extracts a section starting at a specific position.
* Example (1, 6): Starts at position 1, takes 6 characters $\rightarrow$ "Sky is"
   * Example (3, 6): Starts at position 3, takes 6 characters $\rightarrow$ "y is b"
   * Example (3): Starts at position 3 and takes everything else $\rightarrow$ "y is blue"

4. Searching & Replacing

* LOCATE(substring, string): Returns the position (index) of the first occurrence of a substring. It returns 0 if the text isn't found.
* Example ('S'): Returns 1
   * Example ('garten'): Returns 7
   * Example ('king'): Returns 0 (not found)
* REPLACE(string, old, new): Swaps all instances of a specific word or character with a new one.
* Result: "kindergarden"

5. Combining Strings

* CONCAT(str1, str2, ...): Glues two or more strings together into one.
* Result: "Sky is blue"

Pro Tip: In SQL, string indexing usually starts at 1, not 0 (unlike Python or JavaScript).
Would you like to see how to combine these, such as capitalizing only the first letter of a word?


## Date Functions

Date functions allow you to pull specific time components out of a "timestamp" (which contains both date and time). Here is how each of these functions behaves:
1. The "Right Now" Functions
These are used to grab the current system time from the server:

* NOW(): Returns the current date and time (e.g., 2024-05-20 14:30:05).
* CURRENT_DATE(): Returns only the date portion (2024-05-20).
* CURTIME(): Returns only the time portion (14:30:05).

2. Component Extraction (MySQL/Common Style)
These functions "pluck" a specific integer or name out of a date:

* YEAR(), MONTH(), DAY(): Return the numeric year (2024), month (5), or day (20).
* HOUR(), MINUTE(), SECOND(): Return the numeric time components.
* DAYNAME(): Returns the full name of the day (e.g., 'Monday').
* MONTHNAME(): Returns the full name of the month (e.g., 'May').

3. The EXTRACT() Function (Standard SQL)
As you noted, EXTRACT is the industry standard. While YEAR(NOW()) works in MySQL, it might fail in Oracle or PostgreSQL. EXTRACT is more "portable" across different database systems.

* Syntax: EXTRACT(UNIT FROM date_source)
* Units: You can extract YEAR, MONTH, DAY, HOUR, MINUTE, or SECOND.
* Note on Names: Most systems (like MySQL) do not support EXTRACT(DAYNAME ...) or EXTRACT(MONTHNAME ...). For those, you usually have to stick to the specific functions like DAYNAME() or use a FORMAT function.

Quick Comparison Table

| Goal | Short Function (MySQL) | Portable Function (Standard) |
|---|---|---|
| Get Year | YEAR(NOW()) | EXTRACT(YEAR FROM NOW()) |
| Get Month | MONTH(NOW()) | EXTRACT(MONTH FROM NOW()) |
| Get Day | DAY(NOW()) | EXTRACT(DAY FROM NOW()) |

A Common Use Case:
You’ll often use these in a WHERE clause to filter data, like:
SELECT * FROM orders WHERE YEAR(order_date) = 2023;
Would you like to see how to format these dates (e.g., changing 2024-05-20 to May 20th, 2024)?

## Formatting Dates and Times

In many SQL dialects, formatting isn't done with a single function called FORMAT_DATE(). Instead, different database systems use their own specific functions to turn date and time values into readable strings. [1] 
1. MySQL: DATE_FORMAT() and TIME_FORMAT() [1, 2] 
MySQL uses these two primary functions for customization: [1, 3] 

* DATE_FORMAT(date, format): Formats a date or datetime according to a string pattern.
* Example: SELECT DATE_FORMAT(NOW(), '%W, %M %d, %Y'); $\rightarrow$ "Monday, March 10, 2025".
* TIME_FORMAT(time, format): Works exactly like DATE_FORMAT but is used strictly for time values (hours, minutes, seconds).
* Example: SELECT TIME_FORMAT(CURTIME(), '%h:%i %p'); $\rightarrow$ "02:30 PM". [4, 5, 6, 7, 8] 

Common MySQL Format Specifiers:

* %Y: 4-digit year
* %m: Month as a number (01-12)
* %M: Full month name
* %d: Day of the month (01-31)
* %W: Full weekday name
* %H: Hour (00-23) [4, 8, 9] 


## Calculating Dates and Times

In MySQL, you don’t typically use standard math operators (like + or -) to add days or hours because dates are complex. Instead, you use dedicated functions that handle leap years and varying month lengths for you.
1. Adding and Subtracting Time
The most common way to move a date forward or backward is using DATE_ADD and DATE_SUB.

* DATE_ADD(date, INTERVAL value unit)
* Example: SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); (Tomorrow)
   * Example: SELECT DATE_ADD('2024-01-01', INTERVAL 3 MONTH); $\rightarrow$ 2024-04-01
* DATE_SUB(date, INTERVAL value unit)
* Example: SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR); (Last year)

Common Units: SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR.
------------------------------
2. Calculating the Difference Between Two Dates
If you want to know "How long has it been?", use these:

* DATEDIFF(end, start): Returns the difference in days only.
* Example: SELECT DATEDIFF('2024-01-10', '2024-01-01'); $\rightarrow$ 9
* TIMEDIFF(time1, time2): Returns the difference as a time value (HH:MM:SS).
* Example: SELECT TIMEDIFF('12:00:00', '10:30:00'); $\rightarrow$ 01:30:00
* TIMESTAMPDIFF(unit, start, end): The most flexible function. You choose the unit of the result (Year, Month, Day, etc.).
* Example (Age calculation): SELECT TIMESTAMPDIFF(YEAR, '1990-05-15', CURDATE());

------------------------------
3. Converting to Seconds (For Granular Math)
Sometimes it's easier to turn a time into a raw number of seconds to do math, then convert it back.

* TIME_TO_SEC(time): Converts a time to total seconds from the start of the day.
* Example: SELECT TIME_TO_SEC('00:02:00'); $\rightarrow$ 120
* SEC_TO_TIME(seconds): Converts a raw number of seconds back into a HH:MM:SS format.
* Example: SELECT SEC_TO_TIME(3600); $\rightarrow$ 01:00:00

------------------------------
4. Shorthand "Math" Syntax
In MySQL, you can actually use a shorthand version of DATE_ADD using the + or - operators combined with the INTERVAL keyword:

* SELECT NOW() + INTERVAL 1 DAY;
* SELECT '2024-12-31' - INTERVAL 1 WEEK;

Summary Cheat Sheet

| Task | Function to Use |
|---|---|
| Add time | DATE_ADD(date, INTERVAL 5 DAY) |
| Subtract time | DATE_SUB(date, INTERVAL 2 HOUR) |
| Difference in Days | DATEDIFF(date1, date2) |
| Difference in Years/Months | TIMESTAMPDIFF(MONTH, start, end) |

Would you like to see how to use these in a WHERE clause (e.g., finding all orders from the last 30 days)?

 
 
## The IFNULL and COALESCE functions

Both functions are used to handle NULL values, ensuring your query returns a meaningful result instead of an empty or "null" cell.
1. IFNULL(expression, replacement)
This is a MySQL-specific function. It checks the first value: if it is NULL, it returns the second value. If it is not NULL, it returns the first value.

* Syntax: IFNULL(column_name, 'Value if Null')
* Example: Imagine a table where some users haven't provided a phone number.
* SELECT IFNULL(phone, 'No Phone Provided') FROM users;
   * Result: If the phone is NULL, you see "No Phone Provided".

------------------------------
2. COALESCE(value1, value2, ..., valueN)
This is a Standard SQL function (it works in MySQL, PostgreSQL, SQL Server, etc.). It is more powerful because it can take multiple arguments. It returns the first non-NULL value in the list.

* Syntax: COALESCE(val1, val2, val3, ...)
* Example: Suppose you have a table with home_phone, work_phone, and mobile_phone. You want to contact them using whatever number is available.
* SELECT COALESCE(mobile_phone, home_phone, work_phone, 'N/A') FROM contacts;
   * Logic: It checks mobile. If that's NULL, it checks home. If that's NULL, it checks work. If all are NULL, it returns 'N/A'.

------------------------------
Key Differences

| Feature | IFNULL | COALESCE |
|---|---|---|
| Arguments | Only accepts two. | Accepts two or more. |
| Portability | Only works in MySQL. | Works in almost all databases. |
| Logic | "If A is null, give me B." | "Give me the first thing that isn't null." |

Pro Tip: Even in MySQL, many developers prefer COALESCE because it makes the code easier to move to other database systems later.
Would you like to see how to use these functions inside a calculation (like handling NULL prices in a total sum)?


## The IF function

 The IF() function in MySQL is a flow-control function that allows you to build simple "if-then-else" logic directly into your queries. It works very similarly to the IF function in Excel.
1. The Syntax

IF(condition, value_if_true, value_if_false)


* Condition: An expression that evaluates to TRUE or FALSE (e.g., price > 100).
* Value if True: What to return if the condition is met.
* Value if False: What to return if the condition is not met.

------------------------------
2. Basic Example
Imagine you have a products table and you want to label items as "Expensive" or "Cheap" based on their price:

SELECT 
    product_name, 
    price,
    IF(price > 50, 'Expensive', 'Cheap') AS price_categoryFROM products;

3. Nesting IF Functions
You can put an IF inside another IF to handle more than two outcomes (though for many levels, a CASE statement is usually cleaner):

SELECT 
    product_name,
    IF(price > 100, 'Premium', 
       IF(price > 50, 'Mid-range', 'Budget')) AS categoryFROM products;

------------------------------

4. Practical Use: Handling Division by Zero
A common "safety" use for IF is preventing errors when dividing numbers:

SELECT 
    item_name,
    IF(units_sold > 0, total_revenue / units_sold, 0) AS avg_priceFROM sales;

Note: IF() is specific to MySQL. If you need your code to work in other databases (like SQL Server or PostgreSQL), you should use the CASE statement instead.

