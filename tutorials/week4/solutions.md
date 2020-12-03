# 1. Does the order of table declarations above matter?

yes it matters because eid is referenced by other tables and departments is referenced by worksin relationship, therefore, they have to be declared in the order given in the schema

The order matters. We can not insert a Department tuple until there is an Employee tuple available to be the manager of the department. We cannot also insert any WorksIn tuple until you have both the Employee tuple and the Department tuple where the employee works.

# 2. A new government initiative to get more young people into work cuts the salary levels of all workers under 25 by 20%. Write an SQL statement to implement this policy change.
```sql
update Employees 
set salary=salary*0.8
where age < 25;
```
# 3.
```sql
update Employees e
set e.salary=e.salary*1.1
where eid in
	(select eid
	from Departments d, Worksin w
	where d.dname='Sales' and d.did=w.did
	);
```

# 4. manager NOT NULL integer references Employees(eid)

# 5. salary real check (salary >= 15000),

# 6. 
```sql
constraint MaxFullTimeCheck
	check (1.00 >= (select sum(w.percent)
					from Worksin
					where w.eid = eid)
);
```

# 7. 
```sql
constraint ManagerFullTimeCheck
	check (1.00 = (select w.percent
					from worksin w
					where w.eid = manager
					)
);
```

# 8. 
```sql
create table WorksIn (
   eid         integer,
   did         integer,
   percent    real,
   primary key (eid,did),
   foreign key (eid) references Employees(eid) on delete cascade,
   foreign key (did) references Departments(did)
);
```

# 9. remove not null from question 4

# 10.
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

```sql
create table Suppliers (
      sid     integer primary key,
      sname   text,
      address text
);
create table Parts (
      pid     integer primary key,
      pname   text,
      colour  text
);
create table Catalog (
      sid     integer references Suppliers(sid),
      pid     integer references Parts(pid),
      cost    real,
      primary key (sid,pid)
);

-- 12.Find the names of suppliers who supply some red part.
select distinct s.sname
from suppliers s
	join catalog c on c.sid=s.sid
	join parts p on p.pid=c.pid
where p.colour='red';

select distinct sname
from   Suppliers natural join Catalog natural join Parts
where  Parts.colour='red';

-- 13.Find the sids of suppliers who supply some red or green part.
select distinct s.sname, s.sid
from suppliers s
	join catalog c on c.sid=s.sid
	join parts p on p.pid=c.pid
where p.colour='red' or p.colour='green'
order by s.sid;

select distinct C.sid
from   Parts P, Catalog C
where  (P.colour='red' or P.colour='green') and C.pid=P.pid;

--14.Find the sids of suppliers who supply some red part or whose address is 221 Packer Street.
select distinct s.sid
from suppliers s
	join catalog c on c.sid=s.sid
	join parts p on p.pid=c.pid
where p.colour='red'
union
select distinct s.sid
from suppliers s
where s.address='221 Packer Street';

select S.sid
from   Suppliers S
where  S.address='221 Packer Street'
       or S.sid in (select C.sid
                    from   Parts P, Catalog C
                    where  P.colour='red' and P.pid=C.pid
                   );
--15.Find the sids of suppliers who supply some red part and some green part.
select distinct s.sname, s.sid
from suppliers s
	join catalog c on c.sid=s.sid
	join parts p on p.pid=c.pid
where p.colour='red'
intersect
select distinct s.sname, s.sid
from suppliers s
	join catalog c on c.sid=s.sid
	join parts p on p.pid=c.pid
where p.colour='green';


select C.sid
from   Parts P, Catalog C
where  P.colour='red' and P.pid=C.pid
       and exists (select P2.pid
                   from   Parts P2, Catalog C2
                   where  P2.colour='green' and C2.sid=C.sid and P2.pid=C2.pid
                  );

-- 16. Find the sids of suppliers who supply every part.

select sid
from suppliers
where not exists(
	(select pid from parts)
	except
	(select pid from catalog where suppliers.sid=catalog.sid)
);

-- every time you ask question ask each/every
-- similar pattern
-- select [ ] from [ ] where not exists[All - specific]

-- 17. Find the sids of suppliers who supply every red part.
select sid
from suppliers
where not exists(
	(select pid from parts where colour='red')
	except
	(select pid from catalog where suppliers.sid=catalog.sid)
);

-- 18. Find the sids of suppliers who supply every red or green part.
select sid
from suppliers
where not exists(
	(select pid from parts where colour='red' or colour='green')
	except
	(select pid from catalog where suppliers.sid=catalog.sid)
);

-- 19. Find the sids of suppliers who supply every red part or supply every green part.
select sid
from suppliers
where not exists(
	(select pid from parts where colour='red')
	except
	(select pid from catalog where suppliers.sid=catalog.sid)
)
union
select sid
from suppliers
where not exists(
	(select pid from parts where colour='green')
	except
	(select pid from catalog where suppliers.sid=catalog.sid)
);

--20. Find pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.
select c1.sid, c2.sid
from catalog c1, catalog c2
where c1.pid=c2.pid and c1.sid != c2.sid and c1.cost > c2.cost;


--21.Find the pids of parts that are supplied by at least two different suppliers.
select distinct pid
from catalog
group by pid
having count(sid) >=2
order by pid;

select distinct C.pid
from   Catalog C
where  exists(select C1.sid
              from   Catalog C1
              where  C1.pid = C.pid and C1.sid != C.sid
             )

-- 23. Find the pids of parts supplied by every supplier at a price less than 200 dollars
select C.pid
from   Catalog C
where  C.price < 200.00
group by C.pid
having count(*) = (select count(*) from Suppliers);