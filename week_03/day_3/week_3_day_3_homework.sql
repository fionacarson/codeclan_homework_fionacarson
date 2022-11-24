SELECT *
FROM employees

S F W G H O L


--MVP
--Q1

SELECT 
	count(*) AS num_employees_salary_and_grade_null
FROM employees
WHERE grade IS NULL AND salary IS NULL;

--Q2

SELECT 
	concat(first_name, ' ', last_name) AS full_name,
	department
FROM employees AS e
ORDER BY department, last_name;

--Q3

SELECT *
FROM employees e 
WHERE last_name iLIKE('A%')
ORDER BY salary DESC NULLS LAST
LIMIT 10;

--Q4

SELECT 
	department,
	count(id)
FROM employees e 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;

--Q5

SELECT 
	department, 
	fte_hours,
	count(id)
FROM employees e 
GROUP BY department, fte_hours
ORDER BY department; 

--Q6
-- do we need to change the pension enrol column to be 'enrolled', 'not enrolled' etc

SELECT 
	pension_enrol, 	
	count(id)
	FROM employees e 
GROUP BY pension_enrol; 

--Q7

SELECT *
FROM employees e 
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1;

--Q8
-- would be good to round the average salary to integers
SELECT 
	country, 
	count(id) AS num_employees,
	avg(salary) AS avg_salary
FROM employees e 
GROUP BY country
HAVING count(id) > 30
ORDER BY avg_salary DESC;


--Q9

SELECT 
	first_name, 
	last_name, 
	fte_hours, 
	salary, 
	(fte_hours * salary) AS effective_yearly_salary
FROM employees
WHERE (fte_hours * salary) > 30000;

--Q10

SELECT *
FROM employees AS e 
LEFT JOIN teams AS t
ON e.team_id = t.id
WHERE t.name = 'Data Team 1' OR t.name = 'Data Team 2';


--Q11

SELECT 
	first_name,
	last_name
FROM employees AS e
LEFT JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id 
WHERE pd.local_tax_code is NULL;


--Q12

SELECT 
	e.id,
	e.first_name, 
	e.last_name,
	e.department, 
	t.name,
	(((48 * 35 * CAST(t.charge_cost as int4))- e.salary) * e.fte_hours) AS expected_profit
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
ORDER BY expected_profit;

--Q13

WITH least_common_fte_hours AS (
	SELECT 	
		fte_hours 
	FROM employees AS e 
	GROUP BY fte_hours 
	ORDER BY count(id) ASC 
	LIMIT 1
	)
SELECT 
	first_name,
	last_name,
	salary 
FROM employees AS e
WHERE country = 'Japan' 
	AND fte_hours = (SELECT fte_hours FROM least_common_fte_hours)
ORDER BY salary 
LIMIT 1;

--Q14

SELECT 
	department,
	count(id)
FROM employees
WHERE first_name IS NULL 
GROUP BY department
HAVING count(id) > 1
ORDER BY count(id), department;

--Q15

SELECT 
	first_name,	
	count(id)
FROM employees
WHERE first_name IS NOT null
GROUP BY first_name 
HAVING count(id) > 1
ORDER BY count(id) DESC, first_name;

--Q16

SELECT 
	count(id),
	grade
FROM employees
GROUP BY grade



SELECT 
	department,
	count(id) AS num_in_dept,
	sum(cast(grade AS int)) AS grade_1,
	(sum(cast(grade AS real)) / count(id)) AS proportion_grade_1
FROM employees
GROUP BY department;


--Extension
--Q1

--assume largest department is defined as highest number of employees


--WITH largest_dept(department, avg_salary, avg_fte, num_employees) AS (
--	SELECT
--		department,
--		avg(salary) AS avg_sal_by_dept,
--		avg(fte_hours) AS avg_fte_by_dept,
--		count(id) AS num_emp_by_dept
--	FROM employees
--	GROUP BY department
--	ORDER BY num_emp_by_dept desc
--	LIMIT 1
--)



SELECT 
	e.id,
	e.first_name,
	e.last_name, 
	e.department, 
	e.salary,
	e.fte_hours,
	salary / avg(salary) OVER (PARTITION BY department) AS salary_ratio,
	fte_hours / avg(fte_hours) OVER (PARTITION BY department) AS fte_hours_ratio
FROM employees AS e
WHERE department = (SELECT
						department
					FROM employees AS e
					GROUP BY e.department
					ORDER BY count(id) DESC 
					LIMIT 1
					);
						





--Q2

-- using coalesce
SELECT
	count(id),
	coalesce(CAST(pension_enrol as varchar), 'unknown') AS pension_enrol 
FROM employees
GROUP BY pension_enrol; 



--Q3

SELECT 
	first_name,
	last_name,
	email,
	start_date
FROM employees AS e
LEFT JOIN employees_committees AS ec 
ON e.id = ec.employee_id 
LEFT JOIN committees AS c 
ON c.id = ec.committee_id 
WHERE c.name = 'Equality and Diversity'
ORDER BY start_date 

--Q4

WITH sal_class(id, salary, salary_class) AS (
	SELECT 
		e.id,
		e.salary,
		CASE
     		WHEN salary < 40000 THEN 'low'
    		 WHEN salary > 40000 THEN 'high'
    		 WHEN salary IS NULL THEN 'none'
    	END salary_class
    FROM employees AS e
	LEFT JOIN employees_committees AS ec 
	ON e.id = ec.employee_id 
	WHERE ec.committee_id IS NOT NULL
)
SELECT 
	sc.salary_class, 
	count(sc.id)
FROM sal_class AS sc
GROUP BY sc.salary_class;


