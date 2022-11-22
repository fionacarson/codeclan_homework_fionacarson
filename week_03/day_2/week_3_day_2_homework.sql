--MVP
--Q1a

SELECT
	e.first_name,
	e.last_name, 
	t."name" 
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id;

--Q1b

SELECT
	e.first_name,
	e.last_name, 
	t."name" 
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE e.pension_enrol = TRUE;

--Q1c

SELECT
	e.first_name,
	e.last_name, 
	t."name" 
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS int4) > 80;


--Q2a

SELECT 
	e.*,
	pd.local_account_no,
	pd.local_sort_code 
FROM employees AS e
LEFT JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id;


--Q2b

SELECT 
	e.*,
	pd.local_account_no,
	pd.local_sort_code,
	t."name" 
FROM employees AS e
LEFT JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id 
LEFT JOIN teams AS t 
ON e.team_id = t.id; 


--Q3a

SELECT 
	e.id,
	t."name" 
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id;


--Q3b

SELECT 
	t.name AS team_name,
	count(t.name) AS number_of_employees
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id;


--Q3c

SELECT 
	t.name AS team_name,
	count(t.name) AS number_of_employees
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id
ORDER BY number_of_employees;

--Q4a

SELECT 
	t.id,
	t.name AS team_name,
	count(t.name) AS number_of_employees
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id
ORDER BY number_of_employees;


--Q4b

SELECT 
	t.id,
	t.name AS team_name,
	count(t.name) AS number_of_employees,
	t.charge_cost,
	(count(t.name) * CAST(t.charge_cost AS int4)) AS total_day_charge
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id
ORDER BY number_of_employees;

--Q4c

SELECT 
	t.id,
	t.name AS team_name,
	count(t.name) AS number_of_employees,
	t.charge_cost,
	(count(t.name) * CAST(t.charge_cost AS int4)) AS total_day_charge
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id
HAVING (count(t.name) * CAST(t.charge_cost AS int4)) > 5000;



--Extension
--Q5

SELECT 
	COUNT(id) - COUNT(DISTINCT(ec.employee_id)) AS emp_on_more_than_one_committee
FROM employees_committees AS ec


--Q6 

SELECT *
FROM employees AS e
LEFT JOIN employees_committees AS ec 
ON e.id = ec.employee_id 
WHERE ec.employee_id IS NULL


















