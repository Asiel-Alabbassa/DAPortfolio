-- we want to return all the employees that are in dept = 1 

SELECT * FROM employee_demographics emp  where employee_id 
 IN 
 (Select  employee_id from employee_salary where dept_id= 1 );


-- we want to compare everyone salary with the avarge salary of everyone
SELECT first_name,
       last_name,
       salary,
       ( Select avg(salary) FROM employee_salary) AS 'Average Salary'
 FROM employee_salary;

-- 1- we want the results grouped by gender 
SELECT gender,
 AVG(age) as avg_age,
 Max(age) as max_age,
 Min(age) as min_age, 
 COUNT(age) as count_age
 FROM employee_demographics GROUP BY gender;
 
-- 2- we want to find the avg for all the agregate functions for both genders we have the group by on gender now we can considert the results as age table so we can find the avg
SELECT avg(max_age), avg( avg_age), avg(min_age), avg(count_age) FROM 
(SELECT gender,
 AVG(age) as avg_age,
 Max(age) as max_age,
 Min(age) as min_age, 
 COUNT(age) as count_age
 FROM employee_demographics GROUP BY gender) AS Age_table ;
