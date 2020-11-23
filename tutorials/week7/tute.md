1. Consider a schema for an organisation
	Employee(id:integer, name:text, works_in:integer, salary:integer, ...)
	Department(id:integer, name:text, manager:integer, ...)
Solution:
	the constraint can't be checked by standard SQL table constraints because it involves two tables
	cross table constraint can be achieved by using assertion or trigger
```sql
create assertion manager_works_in_department
check  not exists (
	SELECT *
	FROM Employee e JOIN Department d on e.id = d.manager
	WHERE e.works_in <> d.id
);
```

2. write an assertion to ensure that no employee in a department earns more than the manager of their department.
```sql
create assertion employee_manager_salary
check not exists (
	SELECT *
	FROM Employee emp
		JOIN Department d on (dept.id=emp.works_in)
		JOIN Employee mgr on mgr.id=d.manager
	WHERE emp.salary > mgr.salary
	)
);
```
3. 
Trigger functions are defined using the SQL CREATE FUNCTION command. A trigger function should be defined as accepting no arguments, and returns a value of the special TRIGGER data type. The syntax for defining a PLpgSQL function is:
```SQL
CREATE FUNCTION func_name() RETURNS trigger
AS $$
	DECLARE
		variables;
	BEGIN
		statements;
	ENDS;
$$ Language plpgsql;

A trigger is defined with the SQL CREATE TRIGGER command with syntax as:

CREATE TRIGGER trigger_name
               BEFORE operation
               ON table_name FOR EACH ROW
               EXECUTE PROCEDURE function_name();
or
CREATE TRIGGER trigger_name
               AFTER operation
               ON table_name FOR EACH ROW
               EXECUTE PROCEDURE function_name();
```
4.
Changes are made to the database as follows:
fire all BEFORE triggers, possibly modifying any new tuple
do all standard SQL constraint checking (e.g. FKs, domains)
file all AFTER triggers, possibly updating other tables
Note that trigger functions can raise exceptions, which would would cause the change to be aborted and rolled back.

6.
primary key constraint on relation R
```sql
create trigger R_pk_check before insert or update on R
for each row execute PROCEDURE R_pk_check();

create function cR_pk_check() returns trigger
as $$
begin
	if (new.a is null or new.b is null) then
		raise exception 'Partially specified primary key for R';
	end if;
	if (TG_OP='UPDATE' and old.a=new.a and old.b=new.b) then
		return;
	end if;
	select * from R where a=new.a and b=new.b;
	if found then
		raise exception 'Duplicate primary key for R';
	end if;
end;
$$ language plpgsql;
```

foreign key constraint between T.j and S.x
```sql
create trigger T_fk_check before insert or update on T
for each row execute PROCEDURE T_fk_check();

create function T_fk_check() returns trigger
as $$
begin
	
	insert

	update

	delete

end;
$$ language plpgsql;
```

7. Explain the difference between these triggers when executed with the following statements. Assume that S contains primary keys (1,2,3,4,5,6,7,8,9).
	create trigger updateS1 after update on S
	for each row execute procedure updateS();

	create trigger updateS2 after update on S
	for each statement execute procedure updateS();

a) update S set y = y + 1 where x = 5;
	they are exactly the same, both statements execute once when x=5
b) update S set y = y + 1 where x > 5;
	the first statement execute on x=6,7,8,9, 4 times
	the second statement execute once, after all affected tuples have been modified, but before the updates have been committed


8. What problems might be caused by the following pair of triggers?
```sql
create trigger T1 after insert on Table1
for each row execute procedure T1trigger();

create trigger T2 after update on Table2
for each row execute procedure T2trigger();

create function T1trigger() returns trigger
as $$
begin
update Table 2 set Attr1 = ...;
end; $$ language plpgsql;

create function T2trigger() returns trigger
as $$
begin
insert into Table1 values (...);
end; $$ language plpgsql;
```
infinite sequence of trigger activations.

9.
```sql
create trigger q9 before insert or update on Emp
	for each row execute procedure q9();

create or replace function q9() returns trigger
as $$
begin
	if new.empname is null then
		raise exception 'Name can\'t be empty';
	end if;

	if new.salary < 0 or new.salary is null then
		riase exception '% Salary has to be positive value', empname;
	end if;

	new.last_date=now();
	new.last_user=user();
	return new;
end;
$$ language plpgsql;
```

10.
```sql
create trigger q10 before insert or update on Course
for each row execute procedure q10();

create or replace function ins_stu() returns trigger as $$
begin
	update course set numStudes=numStudes+1 where code=new.course
	return new;
end;
$$ language plpgsql;


create or replace function del_stu() returns trigger as $$
begin
	update course set numStudes=numStudes-1 where code=old.course;
	return old;
end;
$$ language plpgsql;


create or replace function upd_stu() returns trigger as $$
begin
	update course set numStudes=numStudes+1 where code=new.course;
	update course set numStudes=numStudes-1 
end;
$$ language plpgsql;


create or replace function chk_quo() returns trigger as $$
declare
	
begin 

end;
$$ language plpgsql;

```