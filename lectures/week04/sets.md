# Sets

## bags in SQL
```sql
example
select age from students;
-- convert to a set of unique values
select distinct age from students;
```
## Operations
```sql
(1,2,3) UNION (2,3,4) yields (1,2,3,4);
(1,2,3) UNION ALL (2,3,4) yields (1,2,3,2,3,4);
INTERSECT
EXCEPT
```

## IN Operator
the IN Operator returns true or false, whether R.a is in the subquery

SELECT *
FROM R
WHERE R.a IN (SELECT x FROM S WHERE Cond)

## EXISTS Operator
EXISTS is true if the table is non-empty
it is also called correlated subquery
```sql
SELECT name, brewer
FROM Beers b1
WHERE NOT EXISTS (
		  SELECT *
		  FROM Beers b2
		  WHERE b2.brewer = b1.brewer
		  		AND b2.name <> b1.name
);
```

## Selection with Aggregation
SELECT COUNT(DISTINCT bar)
FROM Sells
Where...

however, if there is a comparison in where, we need to use
GROUP BY...
HAVING...
