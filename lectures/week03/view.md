# Views

## View definition

CREATE VIEW ViewName AS Query
CREATE VIEW ViewName (AttributeNames) AS Query
DROP VIEW ViewName

-- when there may be already a view
CREATE OR REPLACE replaces the Query associated with a view

## Questions about updating view and altering base table
Views are defined only after their base tables are defined
1. If we alter a table in the base tables, is the data associated in the view table going to be updated as well?

2. if we alter a table and somehow the query associated with the view is no longer valid, what's the msg shown in postgresql? is it just telling you that your view is broken, or view is no longer accessible?


## Example
```sql
CREATE VIEW
CourseMarksAndAverages(course, term, student, mark, avg) AS
SELECT s.code, termName(t.id), e.student, e.mark, avg(mark) OVER (PARTITION BY course)
FROM CourseENrolments e
JOIN Courses c on c.id = e.course
JOIN Subjects s on s.id = c.subject
JOIN Terms t on t.id = c.term
;

SELECT course, term, student, mark
FROM CourseMarksAndAverages
WHERE mark < avg;
```

## Rename View Attributes
```sql
CREATE VIEW InnerCityHotels AS
	SELECT name AS bar, license AS lic
	FROM Bars
	Where addr IN ('The Rocks', 'Sydney');
```

## Using View
Attributes not in the view's SELECT will be set to NULL
e.g.
```sql
	INSERT INTO InnerCityHotels
	VALUES ('Jackson''s on George', '9876543');

-- creates a new tuple in the Bars relation:
(Jackson''s on George,  NULL,  9876543)
-- but this new tuple does not satisfy the view condition:
-- addr IN ('The Rocks', 'Sydney')
```
so it does not appear if we select from the view.

## Evaluating Views
Two alternative ways of implementing views:
re-writing rules (or macros)
	* when a view is used in a query, the query is re-written
	* after rewriting, becomes a query only on base relations
explicit stored relations (called materialized views)
	* the view is stored as a real table in the database
	* updated appropriately when base tables are modified