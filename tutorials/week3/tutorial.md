```sql
create domain TFN as char(11) check (tfn ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$')
tfn TFN,
check (tfn ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$') --matching exactly ^ $




```


mapping relationships
multiple table mappings
	disjointness: not enforceable
	total participation: not enforceable
single table mappings
	disjointness: enforceable
	total participation: enforceable

	subclass char(1) check(subclass in ('a', 'e', 'b'))

attribute in original table (total participation enforceable)
	1:1
		attribute in original table 
		total participation enforceable, but not both sides
	1:N

	Entity 1 === relationship ---> Entity 2
		enforceable
		attribute goes in entity 1

	Entity 1 --- relationship ===> Entity 2
		not enforceable

		valid explanation: because we must store

entirely new table (total participation not enforceable)
	N:M
	total participation never enforceable