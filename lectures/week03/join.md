#Join

## Join

	* natural join: matches tuples via equality on common attributes
	* equijoin: matches tuples via equality on specified attributes
	* theta-join: matches tuples via a boolean expression
	* outer join: like theta-join, but includes non-matching tuples

```sql
SELECT Attributes
FROM R1
	JOIN R2 ON (JoinCondition1)
	JOIN R3 ON (JoinCondition2)
WHERE Condition
```
## Inner vs Outer
inner join DOES NOT bring in tuples with null values
outer join brings in tuples with null value
order is not important for inner join, but very important for outer join


## Outer Join
Join only produces a result tuple from tR and tS where
	* there are appropriate values in both tuples
	* so that the join condition is satisfied

RIGHT JOIN = RIGHT OUTER JOIN
LEFT JOIN = LEFT OUTER JOIN

From R LEFT OUTER JOIN S ON(Condition), R is the left table
* all tuples in R have an entry in the result
* if a tuple from R matches tuple in S, we get the normal join result tuples
* if a tuple from R has no matches in S, the attributes supplied by S are NULL

FULL OUTER JOIN R joins with S