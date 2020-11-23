# SQL

## Data modification

CREATE TABLE:	add new empty table to DB
DROP TABLE: 	remove table(all tuples) and meta-data
ALTER TABLE: 	change meta-data of table (e.g. add constraints)
INSERT: 		add a new tuples to table
DELETE: 		remove tuples from a table via condition
UPDATE: 		modify values in existing table via condition

every user tried to make a change, constraint checking is applied

### Insertion
add single tuple
	INSERT INTO RelationName VALUES (val1, val2, val3...);
	INSERT INTO RelationName VALUES (valForAttr1, valForAttr2, ...);
add multiple tuples
	INSERT INTO RelationName VALUES Tuple1, Tuple2, Tuple3, ...;

tuples may be inserted individually, but it is tedious if there is a lot of tuples

so, most DBMS provides compact representation for each tuple
for example
	COPY Stuff (x,y,z) FROM stdin;
	2	4	green
	4	8	\N


### Alter
ALTER TABLE Likes
	ALTER COLUMN beer SET DEFAULT 'New';
ALTER TABLE Likes
	ALTER COLUMN drinker SET DEFAULT 'Joe';

-- after insertion without all data available
('Fred', 'New');
('Joe', 'Old');

### Deletion
DELETE FROM Relation WHERE Condition: remove all tuples from relation that satisfy condition

Example: remove all expensive beers from sale
	DELETE FROM Sells WHERE price >= 5.00;

If the tuple is referenced from other tables, it won't be removed.

### Condition semantics

DELETE FROM R WHERE Cond:
Method A, con: this may modify the table while deleting, Method B is therefore preferred
```sql
For each tuple T in R do
	If T satisfies Cond Then
		remove T from relation R
	End
End
```
Method B:
```sql
For each tuple T in R Do
	If T satisfies Cond Then
		make a note of this T
	End
End
For each noted tuple T Do
	remove T from relation R
End
```

### Update
Update Table
Set List of assignments
Where Condition


## Queries

### Query Language

SELECT 		projectionList
```sql
Filtering: SELECT b,c from R(a,b,c,d) WHERE a > 5
Combining: FROM R(x,y,z) JOIN S(a,b,c) ON R.y = S.a
Summarising: SELECT avg(mark) FROM ...
Set operation: 
union
interaction
difference
```

FROM 		tables/joins
WHERE 		condition

GROUP BY 	groupingAttributes
```sql
GROUP BY R.a
Group filtering: selecting only groups satisfying a condition
... GROUP BY R.a HAVING max(R.a) < 75
```

HAVING		grouped condition

### Problem Solving

Starts with an information request:
	description of the information required from the database
Ends with:
	a list of tuples that meet the requirements in the request
look for keywords in request to identify required data


## Views




## Join