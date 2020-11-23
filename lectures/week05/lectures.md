# Lectures

## 1. PLpgSQL (II): Miscellaneous

CREATE OR REPLACE FUNCTION(param 1, param 2)
	RETURNS return type
AS $$
DECLARE
	variable declarations
BEGIN
	code for the function
END;
$$ language plpgsql;

### 1.1 Debugging
	raise notice
	displayed in psql window during the function's execution
	usage: raise notice 'Format String', val1, val2
	example:
	raise notice 'x+1=%, y=%, z=%', x+1,y,z

example:
```sql
create or replace function
	seq(_n int) returns setof int
as $$
declare i int;
begin
	for i in 1.._n loop
		raise notice 'i=%', i;
		return next i;
	end loop;
end;
$$ language plpgsql;
```
raise exception will terminate the function

### 1.2 insert returning
	insert into table(...) values
	(val1, val2, val3, val4, valn)
	returning projectionList into Varlist

### 1.3 rcvrpyion
	begin
		statements....
	exception
		when exception1 then
			statement for handler1
		when exception2 then
			statement for handler2
division by zero
no data found
too many rows
floating point exceptions
... and more https://www.postgresql.org/docs/current/errcodes-appendix.html

## 2.COMP3311 20T3: PLpgSQL (iii): Queries in Functions

### 2.1 for loop return next
declare
	tup type; -- be mindful about record type
begin
	for tup in query
	loop
		statements;
	end loop;
end;

### 2.2 dynamically generated queries
	execute 'select * from Employees';
	execute 'select * from '||'Employees';
	execute 'delete from Accounts' || ' where holder=' || quote_literal($1);

	* quote_literal put quoting around constant values
	* quote_ident put quoting around the table name

### 2.3 functions vs views
	a view produces a virtual table definition
	setof functions require an existing tuple type
	functions have parameters, views don't

## 3. Constraint/Assertions
	column and table constraints ensure validity of one table, however,
	we sometimes need constraint across tables

### 3.1 Syntax
	create assertion name check (condition)

### 3.2 example
	create assertion classsizeconstraint check
		not exists (
			select c.id
			from Courses c
				join Enrolments e on (c.id=e.course)
			group by c.id
			having count(e.student) > 9999
		)
	);

### 3.3 Problems with assertion
	it is expensive to implement it

## 4. Triggers

Triggers
	* procedures stored in the database
	* activated in response to database events
Examples of user for triggers
	* maintaining summary data
	* checking schema-level constraints on update
	* performing multi-table updates

variations within trigger:
	before, after, or instead of (how view is operating) the triggering event
	can refer to both old and new values of updated tuples
	can limit updates to a particular set of attributes
	perform action: for each modified tuple, once for all modified tuples

create trigger hello after delete
for each row on people
	block of code
;

NOTE: old doesn't exist for insertion, new doesn't exist for deletion

			before triggers 		constraint checking			after triggers
insert			new						new'						new'
delete			old						old							old
updates 	new + old 				new'+old 					new' + old