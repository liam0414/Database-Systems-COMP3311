# Group by

## Select from where group by
	* partition result relation into groups
	* aggregate some aspects of each group
	* output one tuple per group, with grouping attribute and aggregates

## semantic
```sql
	SELECT   attributes/aggregations
	FROM     relations
	WHERE    condition
	GROUP BY attributes
```

## Filtering groups
```sql
	SELECT   attributes/aggregations
	FROM     relations
	WHERE    condition1   (on tuples)
	GROUP BY attributes
	HAVING   condition2;  (on group)
```

## Partitions
to be updated from tutorial watch this space