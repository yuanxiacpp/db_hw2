/*
employee(employee_name, street, city) 
works(employee_name, department_name, job_title, salary) 
department(department_name, city)
manages(employee_name, manager_name)
*/


--1. Names of employees who work in the ‘Income Tax Restructuring’ department. (1)
select employee_name 
from works 
where department_name = 'Income Tax Restructuring';

--2. Name, salary and address (street, city) of META’s CFO. The IRS is extremely interested in the results of this query. (1)
select employee_name, salary, employee.street+', '+employee.city as address 
from works, employee 
where works.employee_name = employee.employee_name and works.job_title = 'CFO'

--3. Names of employees who earn more than the average salary. (1)
select employee_name 
from works w1, (select avg(salary) as avg_salary from works)w2
where w1.salary > w2.avg_salary 

--4. Names of employees who live in cities other than their department’s headquarter city. (2)
select employee_name
from employee, department
where employee.city != department.city


--5. Names of employees who live in the same cities and on the same streets as their managers. (3)
select e1.employee_name
from employee e1, employee e2, manages
where e1.employee_name = manages.employee_name and
      e2.employee_name = manages.manager_name and
      e1.street = e2.street and
      e1.city = e2.city

--6. Names of employees who earn more than the average salary of their department. (2)
select employee_name
from works w1, (select avg(salary) as avg_salary, department_name from works group by department_name)w2
where w1.department_name = w2.department_name and
      w1.salary > w2.avg_salary

--7. Department with largest payroll (largest sum of all employee salaries). (3)
select department_name
from works w1, 
     (select sum(salary) as total_salary, department_name 
      from works 
      group by department_name
      order by total_salary desc
      limit 1)w2
where w1.department_name = w2.department_name 


--8. Department with largest payroll per head. (2)
select department_name
from works w1,
     (select sum(salary)/count(salary) as payroll_per_head, department_name
      from works
      group by department_name
      order by payroll_per_head desc
      limit 1)w2
where w1.department_name = w2.department_name
