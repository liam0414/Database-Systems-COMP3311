-- option 1
create table R(
	id integer primary key,
	name text not null, 
	address text not null,
	d_o_b date not null
);

create table S(
	name text primary key, 
	address text primary key,
	d_o_b date not null
);

-- option 2
create table R(
	id integer,
	name text not null, 
	address text not null,
	d_o_b date not null,
	primary key (id)
);

create table S(
	name text, 
	address text,
	d_o_b date not null,
	primary key (name, address)
);