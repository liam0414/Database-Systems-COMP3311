-- assumption, rego number in Australia
create table Cars(
	regoNo 			char(10) primary key,
	model 			varchar(50),
	year 			integer
);

create table Owns(
	person          integer references Persons(licenceNo),
	car             char(10) references Cars(regoNo),
	primary key     (person,car)
);

create table Persons(
	licenceNo 		integer  primary key,
	name            varchar(40),
	address         varchar(60),
);

create table Involved(
	reportNo		char(20) references Accidents(reportNo),
	licenceNo		integer references Persons(licenceNo),
	regoNo			char(10) references Cars(regoNo),
	damage			money,
	primary key 	(reportNo, licenceNo, regoNo)
);

create table Accidents(
	reportNo		char(20) primary key,
	location		text,
	accidentDate	date
);

