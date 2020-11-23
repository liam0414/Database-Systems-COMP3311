# SQL

## SQL Introduction

### branches

	* meta-data definition language:	create table
	* meta-data update language:		alter table, drop table
	* data update language: 			insert, update, delete
	* query language:					select ... from ... where

### characteristics
	* constant strings: char and string are the same
	* escape char: 'John' 's bag'
	* PostgresSQL map non-quoted identifiers to all lower-case
	* -- comments to end of line
	* small set of basic data types: integer, real, numeric(w,d), char(n), varchar(n), text
	* time datatype: date, time, timestamp, interval
	* new line: E'\n', extended string, so you can use backslash as escape char
	* type casting-> '10'::integer
	* compute age-> now()::timestamp - birthdate::timestamp
	* dollar quoting $$O'Brien$$, $tag$O'Brien$tag$(useful for php sql)
	* single = rather than double ==
	* <> is same as !=
	* string comparison str1 <str2

### create
	create domain name as type check (constraint)
	-- positive integers
	CREATE DOMAIN PosInt AS integer CHECK (value > 0);
	create a new domain called PosInt and every time a number is inserted, check whether it is positive or negative

	-- a UNSW course code
	CREATE DOMAIN CourseCode AS char(8) CHECK (value ~ '[A-Z]{4}[0-9]{4}');
	create a new domain called CourseCode and every time a tuple is inserted, it checks the value pattern

	-- a UNSW student/staff ID
	CREATE DOMAIN ZID AS integer CHECK (value between 1000000 and 9999999);
	check whether student ID is 7 digit pattern

	-- standard UNSW grades
	CREATE DOMAIN Grade AS char(2) CHECK (value in ('FL', 'PS', 'CR', 'DN', 'HD'));

	create type name as (AttrName AttrType, ...) --tuple types

	create type name as Enum ('Label1', ...) -- enumerated types
	CREATE TYPE GRADE AS ENUM('FL', 'PS', 'CR', 'DN', 'HD');

### tuple and set literals
	tuple vs set constants: tuple is like struct, set constants is like array

## SQL Expression

### Pattern matching
	name LIKE 'Ja%'			name begins with 'Ja'
	name LIKE '_i%'			name has 'i' as second letter
	name LIKE '%o%o%'		name has two 'o's
	name LIKE '%ith'		name ends with 'ith'
	name LIKE 'John'		name equals 'John'
	case sensitive pattern matching ILIKE

	regexp-based pattern matching via ~ and !~

	name ~ '^Ja'			name begins with 'Ja'
	name ~ '^.i'			name has 'i' as second letter
	name ~ '.*o.*o.*'		name has two 'o's
	name ~ 'ith$'			name ends with 'ith'
	name ~ 'John'			name contains 'John'
	case sensitive matching ~* and !~*

### SQL Operation
	str1 || str2 concatenation
	lower(str)
	substring(str, start, count)

### Arithmetic operations
	* abs
	* ceil
	* floor
	* power
	* sqrt
	* count(attr)
	* sum(attr)
	* avg(attr)
	* min/max(attr)
	* factorial

### NULL
	TRUE and NULL = NULL
	TURE OR NULL = TRUE
	FALSE and NULL = FALSE
	FALSE or NULL = NULL

	Testing: X IS NULL, X IS NOT NULL

	coalesce(val1, val2, valn):
		* returns first non-null value
		* useful for providing a displayable value for nulls
	example: select coalesce(mark, '??') from marks

	nullif(val1, val2)
		* returns NULL if equal
		* can be used to implement an inverse to coalesce
	example: nullif(mark, '??')

## Database Definition Language

### Students table
	example:
```sql
	CREATE TABLE Students(
		zid 	serial,
		family 	varchar(40),
		given 	varchar(40) NOT NULL,
		d_o_b 	date NOT NULL,
		gender  char(1) check (gender in ('M', 'F')),
		degree  integer,
		-- below is one way to represent keys
		PRIMARY KEY (zid),
		FOREIGN KEY (degree) REFERENCES Degrees(zid)

	);
```
	Primary key attribute is implicitly defined to be UNIQUE and NOT NULL

	variation:
```sql
	CREATE DOMAIN GenderType AS char(1) CHECK (VALUE in ('M', 'F'));

	CREATE TABLE Students(
		zid 	serial PRIMARY KEY,
		family 	text,
		given 	text NOT NULL,
		d_o_b 	date NOT NULL,
		gender  GenderType,
		degree  integer REFERENCES Degrees(zid)
	);
```

### Course table
```sql
	CREATE TABLE Courses(
		cid		serial PRIMARY KEY,
		code 	char(8) NOT NULL CHECK (code ~ '[A-Z]{4}[0-9]{4}'),
		term 	char(4) NOT NULL CHECK (term ~ '[0-9]{2}T[0-3]'),
		title 	text UNIQUE NOT NULL,
	);
```
### Enrolments
```sql
	CREATE TABLE Enrolments (
		student integer,
		course  integer,
		mark    integer CHECK (mark BETWEEN 0 AND 100),
		grade 	GradeType,
		PRIMARY KEY (student, course),
		FOREIGN KEY (student) REFERENCES Students(zid),
		FOREIGN KEY (course) REFERENCES Courses(cid)
	);
```

### Default values
	CREATE TABLE Accounts (
		acctNo 	char(5) PRIMARY KEY,
		branch 	varchar(30) REFERENCES Branches(name) DEFAULT 'Central',
		owner 	integer REFERENCES Customers(custID),
		balance float DEFAULT 0.0
	);

### Defining keys
	1. Primary Key
	* if PK is on attribute, can be deifned as attribute constraint
	* if PK is multiple attributes, must be defined in table constraints
	2. Foreign Key
	* if FK is one attribute, can be defined as attribute constraint
	* can omit FOREIGN KEY keywords in attribute constraint
	* if FK is multiple attributes, must be defined in table constraints


## ER--->SQL Mapping
	
### Mapping weak entities
```sql
	create table Employees(
		SSN 	text primary key,
		ename 	text,
		salary 	currency
	);

	create table Contacts (
		relativeTo 	text not null, 	-- total participation
		name 		text,			-- not null implied by PK
		phone 		text not null,
		primary key (relativeTo, name),
		foreign key (relativeTo) references Employees(SSN)
	);
```

### mapping N:M relationships
```sql
	create table Customers(
		custNo 	serial primary key,
		name 	text not null,
		address text
	);

	create table Accounts(
		acctNo 	char(5) check (acctNo ~'[A-Z]-[0-9]{3}'),
		title 	text not null,
		balance float default 0.0,
		primary key(acctNo)
	);

	create table Owns(
	    customer_id integer references Customers(custNo),
	    account_id  char(5) references Accounts(acctNo),
	    last_accessed timestamp,
	    primary key (customer_id, account_id)
	);
```

### mapping 1:N relationships
```sql
	create table Branches (
	    branchNo serial primary key,
	    address  text not null,
	    assets   currency
	);
	create table Customers (
	    custNo  serial primary key,
	    name    text not null,
	    address text,
	    hasHome integer not null, -- total participation
	    joined  date not null,
	    foreign key (hasHome) references Branches(branchNo)
	);
```

### mapping 1:1 relationships
```sql
	create table Branches (
	    branchNo serial primary key,
	    address  text not null,
	    assets   currency          -- a new branch
	);                             --    may have no accounts
	create table Managers (
	    empNo    serial primary key,
	    name     text not null,
	    salary   currency not null, -- when first employed, 
	                                --    must have a salary
	    manages  integer not null,  -- total participation
	    foreign key (manages) references Branches(branchNo)
	);
```