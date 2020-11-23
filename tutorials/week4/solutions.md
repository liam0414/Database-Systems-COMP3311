1. yes it matters because eid is referenced by other tables and departments is referenced by worksin relationship, therefore, they have to be declared in the order given in the schema
2. 
```sql
UPDATE 	Employees
SET 	salary = salary * (1 - 0.2)
WHERE 	age < 25;
```
3.
```sql
update Employees
set e.salary = e.salary * 1.1
where e.eid in (
	select e.eid from Employees e join Worksin w on (w.eid=e.eid)
		join Departments d on (w.did=d.did)
	where d.dname='Sales'
)
```

4. manager NOT NULL integer references Employees(eid)

5. check (salary >= 15000);

6. 
```sql
constraint MaxFullTimeCheck
	check (1.00 >= (select sum(w.percent)
					from Worksin
					where w.eid = eid)
);
```

7. 
```sql
constraint ManagerFullTimeCheck
	check (1.00 = (select w.percent
					from worksin w
					where w.eid = manager
					)
);
```

8. ON DELETE CLAUSES
default(throw error)
on delete cascade (for that item, delete, and propagate the event)
on delete set null
on delete set default
```sql
create table WorksIn (
      eid     integer references Employees(eid) on delete cascade,
      did     integer references Departments(did),
      percent real,
      primary key (eid,did)
);
```

9. remove not null from question 4

10.

a. Disallow the deletion of a Departments tuple if any Works tuple refers to it. This is the default behaviour, which would result from the CREATE TABLE definition in the previous question.

b. When a Departments tuple is deleted, also delete all WorksIn tuples that refer to it. This requires adding an ON DELETE CASCADE clause to the definition of WorksIn.
```sql
create table WorksIn (
   eid     integer,
   did     integer,
   percent real,
   primary key (eid,did),
   foreign key (eid) references Employees(eid) on delete cascade,
   foreign key (did) references Departments(did) on delete cascade
);
```
In this solution, we've added the same functionality to the eid field as well (see previous question).

c. For every WorksIn tuple that refers to the deleted department, set the did field to the department id of some existing 'default' department. Unfortunately, Oracle doesn't appear to implement this functionality. If it did, the definition of WorksIn would change to:
```sql
create table WorksIn (
   eid     integer,
   did     integer default 1,
   percent real,
   primary key (eid,did),
   foreign key (eid) references Employees(eid) on delete cascade,
   foreign key (did) references Departments(did) on delete set default
);
```

11.
For each of the possible cases in the previous question, show how deletion of the Engineering department would affect the following database:
a. it wouldn't allow the deletion to happen, error message
b. anyone who works in engineering department will be removed, did = 2
	ON DELETE CASCADE ... All of the tuples in the WorksIn relation that have did = 2 are removed, giving:

```sql
	 DID DNAME               BUDGET  MANAGER
	----- --------------- ---------- --------
	    1 Sales               500000        2
	    3 Service             200000        4

	  EID   DID  PCT_TIME
	----- ----- ---------
	    2     1      1.00
	    3     1      0.50
	    3     3      0.50
	    4     3      0.50
```

c. anyone who works in engineering department will be set to null.

```sql
  DID DNAME               BUDGET  MANAGER
----- --------------- ---------- --------
    1 Sales               500000        2
    3 Service             200000        4

  EID   DID  PCT_TIME
----- ----- ---------
    1  NULL      1.00
    2     1      1.00
    3     1      0.50
    3     3      0.50
    4  NULL      0.50
    4     3      0.50
    5  NULL      0.75
```
d. ON DELETE SET DEFAULT ... All of the tuples in the WorksIn relation that have did = 2 have that attribute modified to the default department (1), giving:
```sql
  DID DNAME               BUDGET  MANAGER
----- --------------- ---------- --------
    1 Sales               500000        2
    3 Service             200000        4

  EID   DID  PCT_TIME
----- ----- ---------
    1     1      1.00
    2     1      1.00
    3     1      0.50
    3     3      0.50
    4     1      0.50
    4     3      0.50
    5     1      0.75
```

12.
```sql
-- A natural join is a join that creates an implicit join based on the same column names in the joined tables.
-- essentially it is like joining tables to form a bigger table
select distinct(s.sname)
from   Suppliers s natural join Catalog c natural join Parts p
where  p.colour='red';
```

13. 
```sql

select distinct(c.sid)
from   Catalog c natural join Parts p
where  p.colour='red' or p.colour='green';
```

14.
```sql
select s.sid
from   Suppliers s natural join Catalog c natural join Parts p
where  p.colour='red' and s.address like '%221 Packer Street%';
```

15.
```sql
-- this is a very tricky questions, note that the supplier has to supply both red and green part
select distinct(c.sid)
from   Catalog c natural join Parts p
where  p.colour='red'
intersect
select distinct(c.sid)
from   Catalog c natural join Parts p
where  p.colour='green'

```

***** 16 (hard question).
```sql
-- my-solution
SELECT s.sid
FROM Suppliers s JOIN Catalog c on s.sid=c.sid
GROUP BY s.sid
HAVING count(c.pid)=(select count(p.pid) from Parts p);
-- not exists = empty set
-- sample solution
select s.sid
from   Suppliers s
where  not exists (
	select p.pid from Parts p
    except
    select c.pid from Catalog c where c.sid = s.sid
);

-- every time you ask question ask each/every
-- similar pattern
-- select [ ] from [ ] where not exists[All - specific]

```

17.
```sql
-- my-solution
select s.sid
from   Suppliers s
where not exists (
	select p.pid from Parts p where p.colour='red'
	except
	select c.pid from Catalog c where c.sid = s.sid
);

--sample solution
SELECT distinct c.sid
from Catalog c
where not exists(
				select p.pid	--all the red parts and 
				from Parts p
				where p.colour='red' and not exists(
						select c1.pid
						from Catalog c1
						where c1.sid=c.sid and c1.pid=p.pid)
);
```

*** 18.
```sql
-- my-solution
select s.sid
from   Suppliers s
where not exists (
	select p.pid from Parts p where p.colour='red' or p.colour = 'green' -- sells every red part
	except
	select c.pid from Catalog c where c.sid = s.sid
);

-- The EXISTS operator is a boolean operator that tests for existence of rows in a subquery.
-- The NOT operator negates the result of the EXISTS operator. The NOT EXISTS is opposite to EXISTS. It means that if the subquery returns no row, the NOT EXISTS returns true. If the subquery returns one or more rows, the NOT EXISTS returns false.
SELECT distinct c.sid
from Catalog c
where not exists(
				select p.pid	--all the red parts
				from Parts p
				where (p.colour='red' or p.colour='green') and not exists(
						select c1.pid
						from Catalog c1
						where c1.sid=c.sid and c1.pid=p.pid)
);
```
19.
Find the sids of suppliers who supply every red part or supply every green part.
```sql
-- my-solution
select s.sid
from   Suppliers s
where not exists (
	select p.pid from Parts p where p.colour='red' -- sells every red part
	except
	select c.pid from Catalog c where c.sid = s.sid
)
union -- or
select s.sid
from   Suppliers s
where not exists (
	select p.pid from Parts p where p.colour='green' -- sells every green part
	except
	select c.pid from Catalog c where c.sid = s.sid
);

```

20. Find pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.

```sql
select c1.sid, c2.sid, c1.pid, c1.cost, c2.cost
from Catalog c1, Catalog c2
where c1.sid <> c2.sid and c1.pid=c2.pid and c1.cost > c2.cost;

21. Find the pids of parts that are supplied by at least two different suppliers.
select c.pid
from Catalog c
group by c.pid
having count(c.pid) >= 2;
```
22. Find the pids of the most expensive part(s) supplied by suppliers named "Yosemite Sham".

```sql
select c.pid
from Catalog c
join suppliers s on s.sid=c.sid
where c.cost >= ALL(select cost from Catalog) and s.sname='Yosemite Sham';

select c.pid
from Catalog c
join suppliers s on s.sid=c.sid
where c.cost >= ANY(select cost from Catalog) and s.sname='Yosemite Sham';
```
ANY and ALL behave as existential and universal quantifiers respectively

23.Find the pids of parts supplied by every supplier at a price less than 200 dollars (if any supplier either does not supply the part or charges more than 200 dollars for it, the part should not be selected).
```sql
select c.pid
from   catalog c
where  c.cost < 200.00
group by c.pid
having count(*) = (select count(*) from Suppliers);
