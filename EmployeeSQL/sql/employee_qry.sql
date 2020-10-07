-- output the default tables created and data imported
select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employees;
select * from salaries;
select * from titles;

-- for the primary keys check to see if the column is unique, count not greater than one
select count(emp_no) from employees group by emp_no order by count(emp_no) desc;
select count(dept_no) from departments group by dept_no order by count(dept_no) desc;
select count(title_id) from titles group by title_id order by count(title_id) desc;

-- 1. list the following details of each employee: employee number, last name, first name, sex, and salary.
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary from employees as e
join salaries as s on e.emp_no = s.emp_no;

-- 2. list first name, last name, and hire date for employees who were hired in 1986.
select first_name, last_name, hire_date from employees where hire_date >= '1986-01-01' and hire_date < '1987-01-01'; 

-- 3. list the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name.
select m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name from dept_manager as m
join departments as d on m.dept_no = d.dept_no
join employees as e on m.emp_no = e.emp_no;

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
select staff.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as staff
join departments as d on staff.dept_no = d.dept_no
join employees as e on staff.emp_no = e.emp_no;

-- 5. list first name, last name, and sex for employees whose 
-- first name is "Hercules" and last names begin with "B."
select first_name, last_name, sex from employees where first_name = 'Hercules' and last_name like 'B%';

-- 6. List all employees in the Sales department, including their 
-- employee number, last name, first name, and department name.
select staff.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as staff
join departments as d on staff.dept_no = d.dept_no
join employees as e on staff.emp_no = e.emp_no
where d.dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.
select staff.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as staff
join departments as d on staff.dept_no = d.dept_no
join employees as e on staff.emp_no = e.emp_no
where d.dept_name = 'Sales' or d.dept_name = 'Development';

-- 8. In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.
select last_name, count(last_name) from employees group by last_name order by count(last_name) desc;

-- BONUS 1a. list the most common salary for all employees.
select s.salary, count(s.salary) from salaries as s
join employees as e on e.emp_no = s.emp_no
group by s.salary order by count(s.salary) desc;

-- BONUS 1b. list the most common salary for employees only (not including managers).
select s.salary, count(s.salary) from salaries as s
join employees as e on e.emp_no = s.emp_no
join dept_emp as staff on staff.emp_no = s.emp_no
group by s.salary order by count(s.salary) desc;

-- BONUS 1c. list the most common salary for managers only.
select s.salary, count(s.salary) from salaries as s
join employees as e on e.emp_no = s.emp_no
join dept_manager as m on m.emp_no = s.emp_no
group by s.salary order by count(s.salary) desc;

-- BONUS 2. list the average salary by title
select t.title, round(avg(s.salary)) as "avg salary" from salaries as s
join employees as e on e.emp_no = s.emp_no
join titles as t on t.title_id = e.emp_title_id
group by t.title order by avg(s.salary) desc;

-- EPILOGUE. Search your employee id number is '499942'
select * from employees where emp_no = 499942;

-- EPILOGUE 1. list detail employee information for '499942'
select e.first_name, e.last_name, d.dept_name, t.title, s.salary, e.hire_date from employees as e
join salaries as s on s.emp_no = e.emp_no
join titles as t on t.title_id = e.emp_title_id
join dept_emp as staff on staff.emp_no = e.emp_no
join departments as d on d.dept_no = staff.dept_no
where e.emp_no = 499942;

-- EPILOGUE 2. list all the managers by first name and last name for employee '499942'
select e.first_name, e.last_name from dept_manager as m
join departments as d on d.dept_no = m.dept_no
join employees as e on e.emp_no = m.emp_no
where d.dept_name = (
	select d.dept_name from departments as d
	join dept_emp as staff on staff.dept_no = d.dept_no
	join employees as e on e.emp_no = staff.emp_no
	where e.emp_no = 499942
);

-- EPILOGUE 3. list detail employee and all of its manager detail and for employee '499942'
select e.first_name, e.last_name, d.dept_name, t.title, s.salary, e.hire_date from employees as e
join salaries as s on s.emp_no = e.emp_no
join titles as t on t.title_id = e.emp_title_id
join dept_emp as staff on staff.emp_no = e.emp_no
join departments as d on d.dept_no = staff.dept_no
where e.emp_no = 499942 or e.emp_no in (
	select e.emp_no from dept_manager as m
	join departments as d on d.dept_no = m.dept_no
	join employees as e on e.emp_no = m.emp_no
	where d.dept_name = (
		select d.dept_name from departments as d
		join dept_emp as staff on staff.dept_no = d.dept_no
		join employees as e on e.emp_no = staff.emp_no
		where e.emp_no = 499942
	)
)
order by t.title, s.salary desc;