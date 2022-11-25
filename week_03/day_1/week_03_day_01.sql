/* SQL Day 1 Homework */
/* MVP */

/* Q1 */

SELECT *
FROM employees
WHERE department = 'Human Resources';


/* Q2 */

SELECT 
    first_name, 
    last_name, 
    country
FROM employees
WHERE department = 'Legal';


/* Q3 */

SELECT 
    COUNT(*)
FROM employees
WHERE country = 'Portugal';

/* Q4 */

SELECT 
    COUNT(*)
FROM employees
WHERE country IN ('Portugal', 'Spain');

/* Q5 */

SELECT 
    COUNT(*)
FROM pay_details
WHERE local_account_no IS NULL;

/* Q6 */

SELECT *
FROM pay_details
WHERE local_account_no IS NULL AND iban IS NULL;

/* Q7 */

SELECT
    first_name, 
    last_name 
FROM employees
ORDER BY last_name NULLS LAST;

/* Q8 */

SELECT
    first_name, 
    last_name, 
    country
FROM employees
ORDER BY country, last_name NULLS LAST;

/* Q9 */

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 10;

/* Q10 */

SELECT
    first_name, 
    last_name, 
    salary
FROM employees
WHERE country = 'Hungary'
ORDER BY salary DESC NULLS LAST
LIMIT 1;

/* Q11 */

SELECT *
FROM employees
WHERE first_name LIKE 'F%';

/* Q12 */

SELECT *
FROM employees
WHERE email LIKE '%yahoo%';

/* Q13 */

SELECT *
FROM employees
WHERE pension_enrol = TRUE AND country NOT IN ('France', 'Germany');

/* Q14 */

SELECT *
FROM employees
WHERE department = 'Engineering' AND fte_hours = 1
ORDER BY salary DESC 
LIMIT 1;

SELECT  
    MAX(salary) AS max_salary
FROM employees
WHERE department = 'Engineering' AND fte_hours = 1;


/* Q15 */

SELECT 
    first_name,
    last_name, 
    fte_hours, 
    salary, 
    fte_hours * salary AS effective_yearly_salary
FROM employees;

/* Q16 */

SELECT
    CONCAT(first_name, ' ', last_name, ' - ', department)
FROM employees
WHERE first_name NOTNULL AND last_name NOTNULL AND department NOTNULL;


/* Q17 */

SELECT
    CONCAT(first_name, ' ', last_name, ' - ', department, ' (joined ', 
    to_char(start_date, 'Mon'), ' ', EXTRACT(YEAR FROM start_date), ')')
FROM employees
WHERE first_name NOTNULL AND last_name NOTNULL AND department NOTNULL 
AND start_date NOTNULL; 



/* Q18 */

SELECT 
    first_name, 
    last_name, 
    salary,
    CASE
     WHEN salary < 40000 THEN 'low'
     WHEN salary > 40000 THEN 'high'
     WHEN salary IS NULL THEN 'unknown'
    END salary_class
FROM employees;







