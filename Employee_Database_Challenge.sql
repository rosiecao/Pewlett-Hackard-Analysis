CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees ( 
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_Emp (
    emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
    emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, title, from_date)
);

SELECT employees.emp_no,
       employees.first_name,
	   employees.last_name,
	   titles.title,
	   titles.from_date,
	   titles.to_date
INTO retirement_titles
FROM employees 
LEFT JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY titles.emp_no;

--Export the retirement_title.csv

SELECT DISTINCT ON (emp_no)emp_no,
first_name, 
last_name, 
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, title DESC;

--export unique_titles.csv

-- create a Retiring Titles table to hold total count and title
-- Group the table by title, then sort the count column in descending order.

SELECT COUNT (unique_titles.title), 
           title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

--Export retiring_titles.csv

--Deliverable 2

SELECT employees.emp_no,
       employees.first_name,
	   employees.last_name,
	   employees.birth_date,
	   dept_emp.from_date,
	   dept_emp.to_date
INTO mentorship
FROM employees 
LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (to_date = '9999-01-01')
ORDER BY dept_emp.to_date;

SELECT mentorship.emp_no,
       mentorship.first_name,
	   mentorship.last_name,
	   mentorship.birth_date,
	   mentorship.from_date,
	   mentorship.to_date,
       titles.title
INTO mentorship_eligibility
FROM mentorship 
LEFT JOIN titles
ON mentorship.emp_no = titles.emp_no;

SELECT DISTINCT ON (emp_no)emp_no,
first_name, 
last_name,
birth_date,
from_date,
to_date,
title
INTO unique_mentorship_eligibility
FROM mentorship_eligibility
ORDER BY emp_no;

