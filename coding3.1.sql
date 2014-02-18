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
select E.employee_name, salary, E.street || ', ' || E.city as address 
from works as W
inner join employee as E on E.employee_name = W.employee_name 
where W.job_title = 'CFO';

--3. Names of employees who earn more than the average salary. (1)
select employee_name 
from works as W1, (select avg(salary) as avg_salary from works) as W2
where W1.salary > W2.avg_salary;

--4. Names of employees who live in cities other than their department’s headquarter city. (2)
select E.employee_name
from employee as E
inner join works as W on E.employee_name = W.employee_name
inner join department as D on W.department_name = D.department_name
where E.city != D.city;


--5. Names of employees who live in the same cities and on the same streets as their managers. (3)
select E1.employee_name
from employee as E1, employee as E2, manages as M
where E1.employee_name = M.employee_name and
      E2.employee_name = M.manager_name and
      E1.street = E2.street and
      E1.city = E2.city;

--6. Names of employees who earn more than the average salary of their department. (2)
select employee_name
from works as W1, (select avg(salary) as avg_salary, department_name from works group by department_name) as W2
where W1.department_name = W2.department_name and
      W1.salary > W2.avg_salary;

--7. Department with largest payroll (largest sum of all employee salaries). (3)
select W.department_name
from 
     (select sum(salary) as total_salary, department_name
      from works 
      group by department_name
      order by total_salary desc
     limit 1) as W;


--8. Department with largest payroll per head. (2)
select W.department_name
from 
     (select avg(salary) as avg_salary, department_name
      from works 
      group by department_name
      order by avg_salary desc
     limit 1) as W;
