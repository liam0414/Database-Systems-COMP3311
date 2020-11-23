# Abstraction

## Complext Queries
	* views
	* WHERE
	* FROM
	* WITH

## Example, get a list of low-scoring students in each course


### View

if we access the query multiple times, then view is better

```sql
	SELECT course, student, mark, 
		avg(mark) OVER (PARTITION BY Course) -- average mark of that course
	FROM Enrolments;


CREATE VIEW
	CourseMarksWithAvg(course, student, mark, avg)
AS
	SELECT course, student, mark, 
		avg(mark) OVER (PARTITION BY Course) -- average mark of that course
	FROM Enrolments;


SELECT course, student, mark
FROM CourseMarksWithAvg
WHERE mark < avg;
```

CREATE VIEW View1(a,b,c,d) AS Query1;
CREATE VIEW View2(e,f,g) AS Query2;
...
SELECT attributes
FROM   View1, View2
WHERE  conditions on attributes of View1 and View2

* look like tables   ("virtual" tables)
* exist as objects in the database   (stored queries)
* useful if specific query is required frequently

### FROM subqueries

```sql
SELECT course, student, mark
FROM   (SELECT course, student, mark,
               avg(mark) OVER (PARTITION BY course)
        FROM   Enrolments) AS CourseMarksWithAvg	-- avoid define view
WHERE  mark < avg;
```

SELECT attributes
FROM   (Query1) AS Name1,
       (Query2) AS Name2
       ...
WHERE  conditions on attributes of Name1 and Name2

* must provide name for each subquery, even if never used
* subquery table inherits attribute names from query

### WTIH subqueries

```sql
WITH CourseMarksWithAvg AS
     (SELECT course, student, mark,
             avg(mark) OVER (PARTITION BY course)
      FROM   Enrolments)
SELECT course, student, mark, avg
FROM   CourseMarksWithAvg
WHERE  mark < avg;
```

WITH   Name1(a,b,c) AS (Query1),
       Name2 AS (Query2), ...
SELECT attributes
FROM   Name1, Name2, ...
WHERE  conditions on attributes of Name1 and Name2

### Recursive Query (hard contents TBD)

-- table with a foreign key that references itself
-- to get records, or hierarchy of the table, we need to use recursion

```sql
WITH RECURSIVE R(attributes) AS (
     SELECT ... not involving R
   UNION
     SELECT ... FROM R, ...
)
SELECT attributes
FROM   R, ...
WHERE  condition involving R's attributes
```

Common Table Expression

