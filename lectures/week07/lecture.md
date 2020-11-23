# 1. Programming with Databases

## 1.1 build user interfaces
	handle the user interface (GUI na dweb)
	interact with other systems (other DBs)
	perform comput-intensive work (data-intensive)

## 1.2 analogy

JAVA/JDBC, PHP/PDO, Perl/DBI, Python/Psycopg2

```
	db = connect_to_dbms
	query = build_SQL
	results = execute_query(db,query)
	while (more_tuples_in(results))
	{
		tuple = fetch_row_from(results);
	}
```

## 1.3 cost of operation
	establishing a DBMS connect -- very high
	initiating SQL query -- high
	accessing individual tuple --small

## 1.4 examples
```
	db = dbAccess("DB");
	query = "select a,b from R,S where ...";
	results = dbQuery(db, query);
	while (tuple = dbNext(results){
		process(tuple['a'], tuple['b']);
	}
```
	estimate costs: *connect = 500ms*, dbquery= 200ms, dbnext=10ms

find mature-age students
	query = "select * from students";
	results = dbquery(db, query);
	while (tuple = dbNext(results)) {
		if (tuple['age'] >= 40) {
			code
		}
	}
	assume there are 50 students who are mature age students
	because the results = entire student database, we are looping through all the results
	cost= 1 * 200 + 10000 * 10 = 100200ms = 100s

find mature-age students ver2
	query="select * from students wehre age>= 40";
	results = dbquery(db, query);
	while (tuple = dbNext(results)) {
		code
	}
	cost = 1 * 200 + 50 * 10 = 700ms = 7s

## 1.5 example 2

find info about all marks for all students
	query1 = "select id,name from Student";
	res1 = dbQuery(db, query1);
	while (tuple1 = dbNext(res1)) {
	    query2 = "select course,mark from Marks"
	             + " where student = " + tuple1['id'];
	    res2 = dbQuery(db,query2);
	    while (tuple2 = dbNext(res2)) {
	        --  process student/course/mark info
	    }
	}
	cost = 10001 * 200 + 80000 * 10 = 2800s = 46min

find info about all marks for all students ver 2
	query = "select id,name,course,mark"
	        + " from Student s join Marks m "
	        + " on (s.id=m.student)"
	results = dbQuery(db, query);
	while (tuple = dbNext(results)) {
	    --  process student/course/mark info
	}
	Cost = 1 * 200 + 80000 * 10 = 800s = 13min

# 2. Python (i)
```python
if condition:
	statement1
else:
	statement2
next statement

comments # vs --
list[1,4,5,6,7,25]
tuple(3,5)
dictionaries{'a':5, 'b':98}

print(f"{name},{age},{height}")
print(type(variable))

n = 16 // 3
print(f"3 ** 3 == {3 ** 3}")
print(f"16 / 3 == {16 / 3}")
print(f"16 // 3 == {n}")

import sys
for arg in sys.argv[1:] :
   print(arg, end=" ")   # don't put '\n' after print
print("")
```

# 3.Psycopg2

## 3.1 basics
```python
import psycopg2
try:
   conn = psycopg2.connect("dbname=mydb") # this only works on grieg
   conn = psycopg2.connect("dbname=postgres user=postgres password=123456")
   print(conn)  # state of connection after opening
   conn.close()
   print(conn)  # state of connection after closing
except Exception as e:
   print("Unable to connect to the database")
```
## 3.2 cursor
cur = conn.cursor()
set up a handle for performing queries/updates on database
must create a cursor before performing any DB operations

what you can do with cursor
### 3.2.1 run a fixed query
cur.execute("select * from R where x=1");

### 3.2.2 run a query with values inserted
cur.execute("select * from R where x = %s", (1,))
cur.execute("select * from R where x = %s", [1])

### 3.2.3 run a query stored in a variable
query = "select * from Students where name ilike %s"
pattern = "%mith%"
cur.execute(query, [pattern])

## 3.3 mogrify
if we want to see what they look like but

query = "select * from R where x = %s"
print(cur.mogrify(query, [1]))
Produces: b'select * from R where x = 1'

query = "select * from R where x = %s and y = %s"
print(cur.mogrify(query, [1,5]))
Produces: b'select * from R where x = 1 and y = 5'

query = "select * from Students where name ilike %s"
pattern = "%mith%"
print(cur.mogrify(query, [pattern]))
Produces: b"select * from Students where name ilike '%mith%'"

query = "select * from Students where family = %s"
fname = "O'Reilly"
print(cur.mogrify(query, [fname]))
Produces: b"select * from Students where family = 'O''Reilly'"

## 3.4 fetch

list = cur.fetchall()
tup = cur.fetchone()
tup = cur.fetchmany(nTuples)

## 4. Python (ii)
Standard usage:
```py
import psycopg2   # include the module definitions
try:
   connnection = psycopg2.connect("dbname=Datatase")
   cursor = connnection.cursor()
   cursor.excute("SQL Query")
   for tuple in cursor.fetchall():
      # do something with next tuple
   cursor.close()
   connection.close()
except:
   print("Database error")
```