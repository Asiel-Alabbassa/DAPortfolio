
-- DELETE DUOBLICATE WITH INNER JOIN


SELECT  * FROM new_table t1
INNER JOIN new_table t2
ON t1.student = t2.student and t1.rollNum = t2.rollNum and t1.marksl = t2.marksl
WHERE t1.id > t2.id;

DELETE t1 FROM new_table t1
INNER JOIN new_table t2
ON t1.student = t2.student and t1.rollNum = t2.rollNum and t1.marksl = t2.marksl
WHERE t1.id > t2.id;

SELECT  * FROM new_table;

-- DELETE DUOBLICATE WITH OVER AND PARTATION FOR ALL THE DOUBLICATE FIELDS 
WITH doup_cte AS
(
SELECT *, ROW_NUMBER()  
OVER (
PARTITION BY student,rollNum,mark)  AS rownum
FROM  new_table_no_id 
)
SELECT * FROM doup_cte WHERE rownum >1 ; 

DELETE FROM new_table_no_id WHERE id IN (SELECT * FROM doup_cte WHERE rownum >1)

 