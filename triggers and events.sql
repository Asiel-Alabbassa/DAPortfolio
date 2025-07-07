-- Triggers and evets 
-- when an update happen to the SALARY table we wnat the EMPLOYEE table is updated too 
SELECT *
FROM employee_demographics;

SELECT * 
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER 	employee_insert 
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES(NEW.employee_id , NEW.first_name, NEW.last_name);  -- add only the new records added to the salary tabble
END $$
DELIMITER  ;

-- TEST THE TRIGGER
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(13,'Jonh' , "Saper" , 'data anylast', 80000, NULL);

-- EVENTS 
-- Retire all he people over the age of 50 and give them life time pay


