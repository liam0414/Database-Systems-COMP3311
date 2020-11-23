create table Suppliers(
	name text primary key,
	city varchar(30)
);

create table supply(
	supplier text,
	part integer,
	quantity integer check (quantity >= 0),
	primary key (supplier, part),
	foreign key (supplier) references Suppliers(name),
	foreign key (part) references Parts(partNumber)
)

create table Parts(
	partNumber integer primary key,
	colour varchar(30)
);