$1 means first variable, however, it is not recommended

-SQL VIEWS
```sql
CREATE VIEW
	TABLE(attr1, attr2,...)
AS
...
;
```
CREATE OR REPLACE FUNCTION() RETURNS RESULT
AS $$
DECLARE

BEGIN

END;
$$ language plpgsql


-PLpgSQL functions (only for postgresql)
a) write a SQL function in database
b) query database results from a different programming languga and use that langugae(python)

```sql
CREATE OR REPLACE 
	functionName(param1, param2,...)
	Returns result
AS $$
DECLARE
	variable declarations
BEING
    code for function
END;
$$ LANGUAGE plpgsql
```

:: type cast
:= is just equal
for i in 1..n loop

example 1
```sql
create or replace function
	factorial(n integer)
	returns integer
AS $$
DECLARE
	i integer;
	fac integer := 1;
BEGIN
	for i in 1..n loop
		fac := fac * i;
	end loop;
	return fac;
END;
$$ language plpgsql;

```
select factorial(number) -- invoke the function

example 2
```sql
CREATE OR REPLACE FUNCTION
	withdraw(acctNum text, amount integer) returns text
as $$
DECLARE
	bal integer;
BEGIN
	select balance into bal
	from Accounts
	where acctNo=acctNum;
	if bal < amount then
		return 'Insufficient Funds';
	else
		update Accounts
			set balance = balance - amount
			where acctNo = acctNum;
			select balance into bal
			from Accounts
			where acctNo = acctNum;
			return 'New Balance: ' || bal;
	end if;
END;
$$ language plpgsql;
```
# 1. Write a simple PLpgSQL function that returns the square of its argument value. It is used as follows:
PLpgsql functions
```sql
mydb=> select sqr(4);
 sqr 
-----
  16
(1 row)

mydb=> select sqr(1000);
   sqr 
---------
 1000000
(1 row)


CREATE OR REPLACE FUNCTION
	sqr(n numeric) returns numeric
AS $$
BEGIN
	return n*n;
END;
$$ language plpgsql;

select sqr(5.0);			--this won't work, input is float
select(5.0::integer);		--this works, type cast float to int
select sqr('5');			--this won't work, input is string

```

# 2. Write a PLpgSQL function that spreads the letters in some text. It is used as follows:
```sql
insert space
mydb=> select spread('My Text');
     spread
----------------
 M y   T e x t
(1 row)

CREATE OR REPLACE FUNCTION spread(str text) RETURNS text
AS $$
DECLARE
	result text := '';
	i integer := 1;
BEGIN
	for i in 1 .. length(str) loop
		result = result || substring(str, i, 1) || ' ';
	end loop;
	return result;
END;
$$ language plpgsql;

```
# 3. Write a PLpgSQL function to return a table of the first n positive integers.
```sql
create or replace function seq(n integer) returns setof integer
as $$
declare
	i integer;
begin
	for i in 1 .. n
	loop
		return next i;
	end loop;
end;
$$ language plpgsql;
```

# 4. Generalise the previous function so that it returns a table of integers, starting from lo up to at most hi, with an increment of inc. The function should also be able to count down from lo to hi if the value of inc is negative. An inc value of 0 should produce an empty table. Use the following function header:
```sql
create or replace function seq(lo int, hi int, inc int) returns setof integer
as $$
declare
	i integer;
begin
	for i in 0 .. (hi-lo)/inc loop
		return next (lo + i*inc);
	end loop;
end;
$$ language plpgsql;
```
# 5. Re-implement the seq(int) function from above as an SQL function, and making use of the generic seq(int,int,int) function defined above.
```SQL
CREATE OR REPLACE FUNCTION
	seq(integer) returns setof integer 
as $$
	SELECT * from seq(1, $1, 1);
$$ language sql;
```

# 6. Create a factorial function based on the above sequence returning functions.
```sql
CREATE OR REPLACE FUNCTION
	fac(n integer) returns integer
AS $$
	select product(seq) from seq(n);
$$ language sql;
```

```java
Beers(name:string, manufacturer:string)
Bars(name:string, address:string, license#:integer)
Drinkers(name:string, address:string, phone:string)
Likes(drinker:string, beer:string)
Sells(bar:string, beer:string, price:real)
Frequents(drinker:string, bar:string)
```

# 7. notes
	* when doing string concat, we need to concat string to something
	* be careful with this extended new line
	* if we want to get every record from the database, we can do 'rec record'.
	* notice the + and 1 row in the print format, it is because we have the \a aligned option on and the result is text
			beer=> select hotelsIn('The Rocks');
			    hotelsin     
			-----------------
			 Australia Hotel+
			 Lord Nelson    +
			(1 row)
```sql
create or replace function hotelsIn(_addr text) returns text
as $$
declare
	_hotel text;
	_result text := '';
begin
	for _hotel in (select name from bars where addr=_addr)
	loop
		_result = _result || _hotel || e'\n';
	end loop;
	return _result;
end;
$$ language plpgsql;
```

# 8. Write a new PLpgSQL function called hotelsIn() that takes a single argument giving the name of a suburb and returns the names of all hotels in that suburb. The hotel names should all appear on a single line, as in the following examples:

```sql
create or replace function
	hotelsIn(_addr text) returns text
as $$
declare
	_name text;
	_result text := '';
begin
	for _name in
		select name from Bars where addr=_addr loop
		_result := _result || _name || ' ';
	end loop;
	if (length(_result) = 0) then
		return 'There are no hotels in ' || _addr;
	else
		return 'Hotels in ' || _addr || ': ' || _result;
	end if;
end;
$$ language plpgsql;
```

# 9. Write a PLpgSQL procedure happyHourPrice that accepts the name of a hotel, the name of a beer and the number of dollars to deduct from the price, and returns a new price. The procedure should check for the following errors:

```sql
create or replace function
	happyHourPrice(_bar text, _beer text, discount float) returns text
as $$
declare
	_price float;
begin
	select price into _price from sells where bar=_bar and beer=_beer;
	if not exists (select name from bars where name = _bar) then --non-existent hotel (invalid hotel name)
		return 'There is no hotel called ' || _bar;
	elsif not exists (select name from beers where name = _beer) then
		return 'There is no beer called ' || _beer;
	elsif not exists (select price from sells where bar=_bar and beer=_beer) then
		return 'The ' || _bar || ' does not serve ' || _beer;
	elsif (_price - discount < 0) then
		return 'Price reduction is too large; ' || _beer || ' only costs ' || to_char(_price,'$9.99');
	else
		return 'Happy hour price for '|| _beer || ' at ' || _bar || ' is ' || to_char(_price - discount,'$9.99');
	end if;
end;
$$ language plpgsql;
```

# 10. The hotelsIn function above returns a formatted string giving details of the bars in a suburb. If we wanted to return a table of records for the bars in a suburb, we could use a view as follows:

```sql
create or replace function hotelsInS(text) returns setof Bars 
as $$
	select * from Bars where addr=$1;
$$ language sql;
```

# 11. plpgsql version

```sql
create or replace function hotelsIn(_addr text) returns setof Bars 
as $$
declare
	_rec record;
begin
	for _rec in select * from Bars where addr=_addr
	loop
		return next _rec;
	end loop;
end;
$$ language plpgsql;
```

Use the Bank Database in answering the following questions. A summary schema for this database:
```java
	Branches(location:text, address:text, assets:real)
	Accounts(holder:text, branch:text, balance:real)
	Customers(name:text, address:text)
	Employees(id:integer, name:text, salary:real)
```
12. For each of the following, write both an SQL and a PLpgSQL function to return the result:

=====================a. salary of a specified employee=====================
```sql
create or replace function employeeSalary(_id integer) returns text
as $$
declare
	_salary real;
	_name text;
begin
	select name, salary into _name, _salary from Employees where id=_id;
	return _name || '''s salary is $' || (_salary::text);
end;
$$ language plpgsql;
```

```sql
create or replace function employeeSalary(_id integer) returns real
as $$
	select salary from Employees where id=_id;
$$ language sql;
```
=====================b. all details of a particular branch=====================
```sql
create or replace function branchInfo(_location text) returns setof Branches
as $$
declare
	_rec record;
begin
	for _rec in select * from branches where location=_location
	loop
		return next _rec;
	end loop;
end;
$$ language plpgsql;
```

```sql
create or replace function branchInfo(_location text) returns setof Branches
as $$
	select * from branches where location=_location;
$$ language sql;
```
=====================c. names of all employees earning more than $sal=====================
```sql
create or replace function salaryEmployeeList(_sal real) returns setof text
as $$
declare
	_list text:='';
	_name text;
begin
	for _name in select name from Employees where salary > _sal order by salary desc
	loop
		return next _name;
	end loop;
	
end;
$$ language plpgsql;
```

```sql
create or replace function salaryEmployeeList(_sal real) returns setof text
as $$
	select name from Employees where salary > _sal;
$$ language sql;
```

# 13. Write a PLpgSQL function to produce a report giving details of branches:
name and address of branch
list of customers who hold accounts at that branch
total amount in accounts held at that branch

Use the following format for each branch:

Branch: Clovelly, Clovelly Rd.
Customers:  Chuck Ian James
Total deposits: $   8860.00

```sql
create or replace function details(_location text) returns text
as $$
declare
	_branchName text;
	_branchAddr text;
	_customerName text;
	_list text:= '';
	_total real;
begin
	select location, address into _branchName, _branchAddr from Branches where location=_location;
	for _customerName in
		select holder from Accounts where _location=branch
	loop
		_list:= _list || _customerName || ' ';
	end loop;

	select sum(balance) into _total from Accounts where _location=branch;
	return 'Branch: ' || _branchName || ', ' || _branchAddr || e'\n' 
		|| 'Customers: ' ||  _list || e'\n'
		|| 'Total deposits: ' || to_char(_total, '$999999D99');
end;
$$ language plpgsql;
```

# 14
```sql
create or replace function unitName(_ouid integer) returns text
as $$
declare
	_utype integer;
	_result text;
begin
	select utype into _utype from OrgUnit where id=_ouid;
	-- if (not found) then
	-- 	RAISE EXCEPTION 'No such unit: %', _ouid;
	-- end if;
	select longname into _result from OrgUnit where id=_ouid;
	case _utype
		when 0, 1 then
			return _result;
		when 2 then
			return 'School of ' || _result;
		when 4 then
			return 'Department of ' || _result;
		when 5 then
			return 'Centre of ' || _result;
		when 7 then
			return 'Institue of ' || _result;
		when 3, 6 then
			return null;
		else
			return 'ERROR:  No such unit: ' || _ouid::text;
	end case;
end;
$$ language plpgsql;
```

# 15. In the previous question, you needed to know the internal ID of an OrgUnit. This is unlikely, so write a function that takes part of an OrgUnit.longname and returns the ID or NULL if there is no such unit. If there is more than one matching unit, return the ID of the first matching unit. Implement this as an SQL function, which allows case-insensitive matching:

create or replace function unitID(partName text) returns integer
as $$
	select id from OrgUnit where longname ilike '%'||partname||'%';
$$ language sql;