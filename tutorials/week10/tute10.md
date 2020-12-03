# 1.Relational algebra operators can be composed. What precisely does this mean? And why is it important?

Composition means that the result of one operator can be used as an argument for some other operator. Since most relational algebra operators take relations as inputs and produce relations as results, they can be composed. It is important because it allows us to build arbitrarily complex relational algebra expressions to answer arbitrarily complex queries (i.e. we can build answers to complex queries from answers to simple queries).

# 2.The natural join ( R Join S ) joins two tables on their common attributes. Consider a theta-join ( R Join[C] S ) where the join condition C is a conjunction of R.A = S.A for each attribute A appearing in the schemas of both R and S (i.e. it joins on the common attributes). What is the difference between the above natural join and theta join?

The relation that results from the natural join has only one attribute from each pair of matching attributes. The theta-join has attributes for both, and their columns are identical. Both joins result in a relation with the same number of tuples.

# 3. The definition of relational algebra in lectures was based on sets of tuples. In practice, commercial relational database management systems deal with bags (or multisets) of tuples. Consider a projection of this relation on the processor speed attribute, i.e. Proj[speed](PCs).

-- note: proj = column, set doesn't have duplicates, bag has duplicates

a. What is the value of the projection as a set?
{700, 1500, 1000}
b. What is the value of the projection as a bag?
{700, 1500, 1000, 1000, 700}
c. Is the minimum/maximum speed different between the bag and set representation?
no, they are same

# 4. Give the relation that results from each of the following relational algebra expressions on these relations:

-- note: from right to left

a. R Div S

A
a1

b. R Div (Sel[B != b1](S))

A
a1


c. R Div (Sel[B != b2](S))

A
a1
a2

d. (R × S) - (Sel[R.C=S.C](R Join[B=B] S)

R Join[B=B] S
R.A	R.B	R.C	S.B	S.C
a1	b1	c1	b1	c1
a1	b2	c2	b2	c2
a2	b1	c1	b1	c1

Sel[R.C=S.C](R Join[B=B] S)

R.A	R.B	R.C	S.B	S.C
a1	b1	c1	b1	c1
a1	b2	c2	b2	c2
a2	b1	c1	b1	c1

R × S

R.A	R.B	R.C	S.B	S.C
a1	b1	c1	b1	c1
a1	b2	c2	b1	c1
a2	b1	c1	b1	c1
a1	b1	c1  b2  c2
a1	b2	c2	b2	c2
a2	b1	c1	b2  c2  

result

R.A	R.B	R.C	S.B	S.C
a1	b2	c2	b1	c1
a1	b1	c1  b2  c2
a2	b1	c1	b2  c2  

# 7.
```sql
-- a.

select s.sname
from Suppliers s
	join Catalog c on s.sid=c.supplier
	join Parts p on p.pid=c.part
where p.colour='red';

select pid from Parts where colour = 'red'
select supplier from Catalog where part=RedPartIds

RedPartIds = proj[pid](sel[colour='red'](Parts)
RedPartSupplier = rename[sid](proj[supplier](RedPartIds join Catalog))
Answer = project[sname](RedPartSupplier join Suppliers)

-- b.
select Suppliers.sid
from Suppliers
	join catalog on Suppliers.sid=catalog.supplier
where catalog.colour = 'red' or catalog.colour = 'green'

RedGreenPartIds = proj[pid](sel[colour='red' or colour = 'green'](Parts)
RedGreenSupplier = proj[sid](RedGreenPartIds join Catalog)

-- c.
select s.sid
from Suppliers s
	join Catalog c on s.sid=c.supplier
	join Parts p on p.pid=c.part
where p.colour='red' and s.address='221 Packer Street';


--d. Find the sids of suppliers who supply some red part and some green part.
RedPartIds = proj[pid](sel[colour='red'](Parts)
RedPartSupplier = (proj[sid](RedPartIds join Catalog))
GreenPartIds = proj[pid](sel[colour='green'](Parts)
GreenPartSupplier = (proj[sid](GreenPartIds join Catalog))
answer = GreenPartSupplier intersect RedPartSupplier


--e. Find the sids of suppliers who supply every part.
select sid
from suppliers
where not exists (
	(select pid from parts where colour = 'red') --all the red parts
	except
	(select part from catalog join parts on part = pid where supplier=sid and colour = 'red')
)


answer = proj[supplier, part](Catalog) Div Rename[part](proj[pid](Parts))


-- f.Find the sids of suppliers who supply every red part.

answer = proj[supplier, part](Catalog) Div Rename[part](proj[pid](sel[colour='red'](Parts)))

-- g. Find the sids of suppliers who supply every red or green part.

answer = proj[supplier, part](Catalog) Div Rename[part](proj[pid](sel[colour='red' or colour='green'](Parts)))

-- h. Find the sids of suppliers who supply every red part or supply every green part.
everyred=proj[supplier, part](Catalog) Div Rename[part](proj[pid](sel[colour='red'](Parts)))
everygreen=proj[supplier, part](Catalog) Div Rename[part](proj[pid](sel[colour='green'](Parts)))
answer = everyred union everygreen

--i. Find the pids of parts that are supplied by at least two different suppliers.
C1 = Catalog
C2 = Catalog
SupplierPartPairs = Sel[C1.sid!=C2.sid](C1 Join[pid] C2)

```

# 8.

a. find the names of all suppliers who supply red parts that cost less than $100

b.

# 9.
```sql
--a. Find the ids of pilots certified for 'Boeing 747' aircraft.
answer = Proj[employee](Sel[aname='Boeing 747'](Aircraft join Certified))

--b. Find the names of pilots certified for 'Boeing 747' aircraft.

BoeingPilotIds = Proj[eid](Sel[aname='Boeing 747'](Aircraft join Certified join Employees))

--c. Find the ids of all aircraft that can be used on non-stop flights from New York to Los Angeles.
distancebetween = select distance from Flights where departs = 'New York' and arrives = 'Los Angeles'
select aid from aircraft where cruisingrange> distancebetween

Aircraft
Join[cruisingrange> distancebetween]
Sel[from='New York' AND to='Los Angeles'](Flights)



# 10.
Give a brief definition for each of the following terms:

transaction: An execution of a user program that performs some action that is treated as atomic according to the semantics of some database application. The DBMS sees the transaction as a sequence of actions that can include read and write operations on the database, as well as computations.

serializable schedule: A schedule over a set of transactions that produces a result that is the same as some serial execution of the transactions.

conflict-serializable schedule: A schedule is conflict-serializable if it is conflict-equivalent to some serial schedule. Two schedules are conflict-equivalent if they involve the same set of actions and they order every pair of conflicting actions in the same way.

view-serializable schedule: A schedule is view-serializable if it is view-equivalent to some serial schedule. Two schedules are view-equivalent if they satisfy:
	* 	the initial value of any object is read by the same transaction in both schedules, and
	* 	the final value of any object is written by the same transaction in both schedules, and
	* 	any shared object is written-then-read by the same pair of transactions in both schedules.

## 11.
T2 --> T3 --> T1

## 12.

T1: R(X) R(Y) W(X)           W(X)
T2:                R(Y)           R(Y)
T3:                     W(Y)

a. Determine (by using a precedence graph) whether the schedule is conflict-serializable
The precedence graph has an edge, from T1 to T3, because of the conflict between T1:R(Y) and T3:W(Y).
It also has an edge, from T2 to T3, because of the conflict between the first T2:R(Y) and T3:W(Y).
It also has an edge, from T3 to T2, because of the conflict between T3:W(Y) and the second T2:R(Y). 
There is a cycle, so it is not conflict-serializable.

b. Modify S to create a complete schedule that is conflict-serializable
Trick question. It is not possible. Since the precedence graph is cyclic, we know that it's not conflict-serializable.

## 13.

a. 
T1: R(X) 	  W(X)           
T2:      R(X)      W(X)

conflict-serializable: No
view-serializable: No

b.
T1: W(X) 	  R(Y)           
T2:      R(Y)      R(X)

conflict-serializable: Yes
view-serializable: Yes

c.
T1: R(X) 	            R(Y)
T2:      R(Y)      R(X)
T3:           W(X) 

conflict-serializable: Yes
view-serializable: Yes



e.

T1: R(X) 	  W(X)
T2:      W(X)
T3:                W(X) 