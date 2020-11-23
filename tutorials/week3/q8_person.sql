--version 1
create table Persons(
	name text primary key,	
	birthdate text,
	address text,
);
--verion 2
create table Persons(
	familyName 		varchar(40),
	givenName 		varchar(40),
	initial 		char(2),
	birthdate		date,
	streetNumber 	integer,
	streetName		varchar(40),
	suburb			varchar(40),
	primary key (familyName,givenName,initial)
);