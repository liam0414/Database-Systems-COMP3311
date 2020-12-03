1. natural join: when we want to join 2 tables togerther by their foreign key
it is just a shortcut really, means we don't have to do "on t1.x=t2.y"


2.

Case 1: Subquery returns a single, unary tuple

	SELECT * FROM R WHERE R.a = (SELECT S.x FROM S WHERE Cond1)

Case 2: Subquery returns multiple values

	SELECT * FROM R WHERE R.a IN (SELECT S.x FROM S WHERE Cond2)

---------------------------------------------------------------------------
When using grouping, every attribute in the SELECT list must:
have an aggregation operator applied to it OR appear in the GROUP-BY clause

Incorrect Example: Find the styles associated with each brewer
SELECT   brewer, style
FROM     Beers
GROUP BY brewer;
PostgreSQL's response to this query:

ERROR: column beers.style must appear in the GROUP BY 
         clause or be used in an aggregate function

---------------------------------------------------------------------------
Filtering groups

Example: Find bars that each sell all of the beers Justin likes.

SELECT DISTINCT S.bar
FROM   Sells S, Likes L on (S.beer = L.beer)
WHERE  L.drinker = 'Justin'
GROUP  BY S.bar
HAVING count(S.beer) =
           (SELECT count(beer) FROM Likes
            WHERE drinker = 'Justin');

----------------------------------------------------------------------------


3. 

SQL set operations  UNION,  INTERSECT,  EXCEPT  ...

R1 UNION R2			set of tuples in either R1 or R2 (or)
R1 INTERSECT R2		set of tuples in both R1 and R2 (and)
R1 EXCEPT R2		set of tuples in R1 but not R2 (each every)

4. plpgsql function and sql function

CREATE OR REPLACE FUNCTION () RETURNS Type
AS $$
DECLARE
	i integer := 0;
BEGIN
	return i;
END;
$$ language plpgsql;

```sql
var := expr
SELECT expr INTO var	

IF Cond1 THEN S1
ELSIF Cond2 THEN S2 ...
ELSE S END IF

LOOP S END LOOP
WHILE Cond LOOP S END LOOP
FOR rec_var IN Query LOOP ...
FOR int_var IN lo..hi LOOP ...

Assigning whole rows via SELECT...INTO:

declare
   emp    Employees%ROWTYPE;
   -- alternatively,  emp  RECORD;
   eName  text;
   pay    real;
begin
   select * into emp
   from Employees where id = 966543;
   eName := emp.name;
   ...
   select name,salary into eName,pay
   from Employees where id = 966543;
end;

```



CREATE OR REPLACE
   funcName(arg1type, arg2type, ....)
   RETURNS rettype
AS $$
   SQL statements
$$ LANGUAGE sql;


Debugging
```sql
create or replace function
   seq(_n int) returns setof int
as $$
declare i int;
begin
   for i in 1.._n loop
      raise notice 'i=%',i;
      return next i;
   end loop;
end;
$$ language plpgsql;
```

---------------------------------------------------------------------------------
exception handling:
```sql
-- table T contains one tuple ('Tom','Jones')
declare
   x integer := 3;
   y integer;
begin
   update T set firstname = 'Joe'
   where lastname = 'Jones';
   -- table T now contains ('Joe','Jones')
   x := x + 1;
   y := x / 0;
exception
   when division_by_zero then
      -- update on T is rolled back to ('Tom','Jones')
      raise notice 'caught division_by_zero';
      return x; -- value returned is 4
end;
```

Replacing  notice  by  exception  causes function to terminate in first iteration

5. sets vs bags (unique vs duplicates)

SQL query results are actually bags (multisets), allowing duplicates, e.g.
Can convert bag to set (eliminate duplicates) using DISTINCT

6. complex queries

---------------------------------------------------------------------------------
Over: window control

Example: get a list of low-scoring students in each course

CREATE VIEW
   CourseMarksWithAvg(course,student,mark,avg)
AS
SELECT course, student, mark,
       avg(mark) OVER (PARTITION BY course)
FROM   course_enrolments;

SELECT course, student, mark
FROM   CourseMarksWithAvg
WHERE  mark < avg;

---------------------------------------------------------------------------------
FROM 
SELECT course, student, mark
FROM   (SELECT course, student, mark,
               avg(mark) OVER (PARTITION BY course)
        FROM   Enrolments) AS CourseMarksWithAvg
WHERE  mark < avg;

```sql
in general
SELECT attributes
FROM   (Query1) AS Name1,
       (Query2) AS Name2
       ...
WHERE  conditions on attributes of Name1 and Name2
```

---------------------------------------------------------------------------------
WITH CourseMarksWithAvg AS
     (SELECT course, student, mark,
             avg(mark) OVER (PARTITION BY course)
      FROM   Enrolments)
SELECT course, student, mark, avg
FROM   CourseMarksWithAvg
WHERE  mark < avg;

```sql
in general
WITH   Name1(a,b,c) AS (Query1),
       Name2 AS (Query2), ...
SELECT attributes
FROM   Name1, Name2, ...
WHERE  conditions on attributes of Name1 and Name2
```

7. constraints/assertions/triggers

why do we need assertions and triggers:
Column and table constraints ensure validity of one table.
Ref. integrity constraints ensure connections between tables are valid.
However, specifying validity of entire database often requires constraints involving multiple tables.

```
create table Employee (
   id      integer primary key,
   name    varchar(40),
   salary  real,
   age     integer check (age > 15),
   worksIn integer
              references Department(id),
   constraint PayOk check (salary > age*1000)
);
```sql

---------------------------------------------------------------------------------
examples
create assertion ClassSizeConstraint check (
   not exists (
      select c.id
      from   Courses c
             join Enrolments e on (c.id = e.course)
      group  by c.id
      having count(e.student) > 9999
   )
);

create assertion AssetsCheck check (
   not exists (
      select branchName from Branches b
      where  b.assets <>
             (select sum(a.balance) from Accounts a
              where a.branch = b.location)
   )
);

issues with assertions: it is expensive
A database with many assertions would be way too slow.
So, most RDBMSs do not  implement general assertions.

---------------------------------------------------------------------------------

CREATE TRIGGER TriggerName
{AFTER|BEFORE}  Event1 [ OR Event2 ... ]
[ FOR EACH ROW ]
ON TableName
[ WHEN ( Condition ) ]
Block of Procedural/SQL Code ;

---------------------------------------------------------------------------------
```sql
Case 1: new employees arrive

create trigger TotalSalary1
after insert on Employees
for each row execute procedure totalSalary1();

create function totalSalary1() returns trigger
as $$
begin
    if (new.dept is not null) then
        update Department
        set    totSal = totSal + new.salary
        where  Department.id = new.dept;
    end if;
    return new;
end;
$$ language plpgsql;

Case 2: employees change departments/salaries

create trigger TotalSalary2
after update on Employee
for each row execute procedure totalSalary2();

create function totalSalary2() returns trigger
as $$
begin
    update Department
    set    totSal = totSal + new.salary
    where  Department.id = new.dept;
    update Department
    set    totSal = totSal - old.salary
    where  Department.id = old.dept;
    return new;
end;
$$ language plpgsql;

Case 3: employees leave

create trigger TotalSalary3
after delete on Employee
for each row execute procedure totalSalary3();

create function totalSalary3() returns trigger
as $$
begin
    if (old.dept is not null) then
        update Department
        set    totSal = totSal - old.salary
        where  Department.id = old.dept;
    end if;
    return old;
end;
$$ language plpgsql;
```

8. aggregates/UDA

```sql
CREATE AGGREGATE AggName(BaseType) (
    sfunc     = UpdateStateFunction,
    stype     = StateType,
    initcond  = InitialValue,
    finalfunc = MakeFinalFunction,
    sortop    = OrderingOperator
);
```