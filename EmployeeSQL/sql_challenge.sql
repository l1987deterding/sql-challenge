--Use the information you have to create a table schema for each of the six 
--CSV files
--Remember to specify data types, primary keys, foreign keys, and other constraints.
DROP TABLE IF EXISTS departments, 
	department_manager, 
	salaries, 
	department_employees, 
	employees, titles;

CREATE TABLE employees (
    employee_number INT NOT NULL,
	employee_title_id VARCHAR(6) NOT NULL,
    birthdate DATE NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    sex VARCHAR(2) NOT NULL,
    hire_date DATE NOT NULL,
	PRIMARY KEY(employee_number));
	
CREATE TABLE departments (
    department_number VARCHAR(30) NOT NULL,
    department_name VARCHAR(30) NOT NULL,
	PRIMARY KEY(department_number));

CREATE TABLE department_employees (
    employee_number INT NOT NULL,
    department_number VARCHAR(30) NOT NULL,
	CONSTRAINT fk_department_number
      FOREIGN KEY(department_number) 
	  REFERENCES departments(department_number));

CREATE TABLE department_manager (
    department_number VARCHAR(30) NOT NULL,
    employee_number INT NOT NULL,
	CONSTRAINT fk_employee_number
      FOREIGN KEY(employee_number) 
	  REFERENCES employees(employee_number));

CREATE TABLE salaries (
    employee_number INT NOT NULL,
    salary INT NOT NULL,
	CONSTRAINT fk_employee_number
      FOREIGN KEY(employee_number) 
	  REFERENCES employees(employee_number));

CREATE TABLE titles (
    title_id VARCHAR(6) NOT NULL,
    title VARCHAR(30) NOT NULL);

--All CSV files imported!

--List the following details of each employee: employee number, last name, 
--first name, 
--sex, and salary.

SELECT employees.employee_number, employees.last_name, employees.first_name, 
employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.employee_number = salaries.employee_number;

--2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1987-01-01';

--3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, 
--first name.
SELECT d.department_number, d.department_name 
FROM departments AS d
JOIN department_manager AS dm
ON d.department_number = dm.department_number
JOIN employees as e
ON dm.employee_number = e.employee_number

--4. List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT de.employee_number, e.last_name, e.first_name, d.department_name
FROM department_employees AS de
JOIN employees AS e
ON de.employee_number = e.employee_number
JOIN departments AS d
ON de.department_number = d.department_number;

--5. List first name, last name, and sex for employees whose first name is 
--"Hercules" and last names begin with "B."
SELECT e.first_name, e.last_name, e.sex
FROM employees AS e
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--6. List all employees in the Sales department, including their employee number, 
--last name, first name, and department name.
SELECT e.employee_number, e.last_name, e.first_name, d.department_name
FROM employees AS e
JOIN department_employees AS de
ON e.employee_number = de.employee_number
JOIN departments AS d 
ON d.department_number = de.department_number
WHERE d.department_name = 'Sales';

--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT e.employee_number, e.last_name, e.first_name, d.department_name
FROM employees AS e
JOIN department_employees AS de
ON e.employee_number = de.employee_number
JOIN departments AS d 
ON d.department_number = de.department_number
WHERE d.department_name = 'Sales'
OR d.department_name = 'Development';

--8. In descending order, list the frequency count of employee last names.
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;