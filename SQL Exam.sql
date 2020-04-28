-- SQL Exam
-- 1. Employees all over the world. Can you tell me the top three cities that we have employees? 
select country, city, count(distinct employeenumber) as total_emp
from employees e, offices o 
where e.officecode=o.officecode
group by country, city
order by total_emp desc
limit 3;
-- 2. For company products, each product has inventory and buy price, msrp. Assume that every product is sold on msrp price. Can you write a query to tell company executives: profit margin on each productlines
select productline, (sum(prod_revenue)-sum(prod_cost))/sum(prod_revenue) as profit_margin
from
(select productline, productcode, sum(msrp*quantityinstock) as prod_revenue, sum(buyprice*quantityinstock) as prod_cost
from products
group by productline, productcode)t
group by productline;
-- 3. company wants to award the top 3 sales rep They look at who produces the most sales revenue. 
	-- A. can you write a query to help find the employees.   
select salesrepemployeenumber, concat(firstname, ' ', lastname) as full_name, sum(priceeach*quantityordered) as sales 
from customers c, orders o, orderdetails d, employees e
where c.customernumber=o.customernumber
and o.ordernumber=d.ordernumber
and c.salesrepemployeenumber=e.employeenumber
group by salesrepemployeenumber
order by sales desc
limit 3;
	-- B. if we want to promote the employee to a manager, what do you think are the tables to be updated.        
update employees
set jobtitle='Sales Manager' 
where employeenumber='0000';
    -- C. An employee  is leaving the company, write a stored procedure to handle the case. 1). Make the current employee inactive, 2). Replaced with its manager employeenumber in order table.  
DELIMITER 
create procedure employee_inactive(in emp_id int)
begin
	delete from employees
    where employeenumber=emp_id;
    
    update customers
    set salesrepemployeenumber=(select reportsto from employees where employeenumber=emp_id);
end
DELIMITER  
call employee_inactive(0000);
-- 4. Employee Salary Change Times  Ask to provide a table to show for each employee in a certain department how many times their Salary changes  
select department_id, es.employee_id, count(distinct es.employee_id, es.salary)-1 as changes from employee_salary es, employees emp
where es.employee_id=emp.employee_id
group by es.employee_id
order by department_id;
-- 5. Top 3 salary Ask to provide a table to show for each department the top 3 salary with employee name  and employee has not left the company. 
select * from
(
select department_id, employee_name, cur_salary, dense_rank(cur_salary) over (partition by department_id order by cur_salary desc) as ranking
from employee
where (term_date is null or term_date>curdate())
and start_date<=curdate()
)t
where ranking<=3
order by department_id