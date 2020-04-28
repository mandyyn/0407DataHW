-- Single entity
-- 1. Prepare a list of offices sorted by country, state, city.
select officecode, country, state, city from offices
order by country, state, city
-- 2. How many employees are there in the company?
select count(distinct employeenumber) as total_empployee from employees
-- 3. What is the total of payments received?
select sum(amount) as total_payment from payments
-- 4. List the product lines that contain 'Cars'.
select productline from productlines
where productline like '%Cars%'
-- 5. Report total payments for October 28, 2004.
select sum(amount) as total_payment from payments
where paymentdate='2004-10-28'
-- 6. Report those payments greater than $100,000.
select * from payments
where amount>100000
-- 7. List the products in each product line.
select productname, productline from products
order by productline
-- 8. How many products in each product line?
select count(distinct productcode) as total_products, productline from products
group by productline
-- 9. What is the minimum payment received?
select min(amount) as min_amount from payments
-- 10. List all payments greater than twice the average payment.
select * from payments
where amount>(select 2*avg(amount) from payments)
-- 11. What is the average percentage markup of the MSRP on buyPrice?
select avg(1.0*(msrp-buyprice)/msrp) from products
-- 12. How many distinct products does ClassicModels sell?
select count(distinct productcode) as total_distinct_products from products
-- 13. Report the name and city of customers who don't have sales representatives?
select customername, city from customers
where salesrepemployeenumber is null
order by city
-- 14. What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select concat(firstname,' ',lastname) as full_name, jobtitle from employees
where jobtitle like '%VP%' or jobtitle like '%Manager%'
-- 15. Which orders have a value greater than $5,000?
select ordernumber, sum(priceeach*quantityordered) as total_value from orderdetails
group by ordernumber
having total_value>5000

-- One to many relationship
-- 1. Report the account representative for each customer.
select customername, concat(firstname,' ',lastname) as salesRep_name from customers c, employees e
where c.salesrepemployeenumber=e.employeenumber
-- 2. Report total payments for Atelier graphique.
select customername, sum(amount) as total_payment from payments p, customers c
where c.customernumber=p.customernumber
and customername='Atelier graphique'
-- 3. Report the total payments by date
select sum(amount) as total_payment, paymentdate from payments
group by paymentdate
-- 4. Report the products that have not been sold.
select productname from products p
where p.productcode not in (select distinct productcode from orderdetails)
-- 5. List the amount paid by each customer.
select customername, sum(amount) as total_amount from customers c, payments p
where p.customernumber=c.customernumber
group by customername
-- 6. How many orders have been placed by Herkku Gifts?
select customername, count(ordernumber) as total_orders from customers c, orders o
where o.customernumber=c.customernumber
and customername='Herkku Gifts'
-- 7. Who are the employees in Boston?
select employeenumber, concat(firstname,' ',lastname) as emp_name, city from offices o, employees e
where e.officecode=o.officecode
and city='Boston'
-- 8. Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
select customername, amount from payments p, customers c
where p.customernumber=c.customernumber
and amount>100000
order by amount desc
-- 9. List the value of 'On Hold' orders.
select o.ordernumber, o.status, sum(priceeach*quantityordered) as total_value from orders o, orderdetails d
where o.ordernumber=d.ordernumber
and o.status='On Hold'
group by o.ordernumber
-- 10. Report the number of orders 'On Hold' for each customer.
select customername, count(ordernumber) as total_onHold_orders from customers c, orders o
where c.customernumber=o.customernumber
and o.status='On Hold'
group by c.customernumber

-- Many to many relationship
-- 1. List products sold by order date.
select productname, orderdate from orders o, orderdetails d, products p
where p.productcode=d.productcode
and o.ordernumber=d.ordernumber
order by orderdate
-- 2. List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
select orderdate from orders o, orderdetails d, products p
where p.productcode=d.productcode
and o.ordernumber=d.ordernumber
and productname='1940 Ford Pickup Truck'
order by orderdate desc
-- 3. List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
select customername, o.ordernumber, sum(priceeach*quantityordered) as total_value from customers c, orders o, orderdetails d
where c.customernumber=o.customernumber
and o.ordernumber=d.ordernumber
group by o.ordernumber
having total_value>25000
-- 4. Are there any products that appear on all orders?
select distinct productname from products p, orderdetails o
where p.productcode=o.productcode
group by o.ordernumber
having count(distinct o.ordernumber) =count(distinct o.ordernumber,o.productcode)
-- 5. List the names of products sold at less than 80% of the MSRP.
select distinct productname from orderdetails o, products p
where o.productcode=p.productcode
and 1.0*priceeach/msrp<0.8
-- 6. Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
select distinct productname from orderdetails o, products p
where o.productcode=p.productcode
and priceeach>buyprice*2
-- 7. List the products ordered on a Monday.
select productname, orderdate from orders o, orderdetails d, products p
where p.productcode=d.productcode
and o.ordernumber=d.ordernumber
and weekday(orderdate)=0
order by orderdate
-- 8. What is the quantity on hand for products listed on 'On Hold' orders?
select productname, quantityinstock from orders o, orderdetails d, products p
where p.productcode=d.productcode
and o.ordernumber=d.ordernumber
and o.status='On Hold'

-- Regular expressions
-- 1. Find products containing the name 'Ford'.
-- 2. List products ending in 'ship'.
-- 3. Report the number of customers in Denmark, Norway, and Sweden.
-- 4. What are the products with a product code in the range S700_1000 to S700_1499?
-- 5. Which customers have a digit in their name?
-- 6. List the names of employees called Dianne or Diane.
-- 7. List the products containing ship or boat in their product name.
-- 8. List the products with a product code beginning with S700.
-- 9. List the names of employees called Larry or Barry.
-- 10. List the names of employees with non-alphabetic characters in their names.
-- 11. List the vendors whose name ends in Diecast