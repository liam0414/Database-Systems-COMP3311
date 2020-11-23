--a. name
given name varchar(40),
family name varchar(40),

--b. address
street  varchar(30),
town    varchar(30),
state   varchar(30),
country varchar(30),

--c. gender
gender 	char(1) check (gender in ('M', 'F'))
gender  char(1) check (gender in ('m','f'))
gender  integer check (gender in (1,2)) -- 1=male, 2=female

--d. age
age  integer check (age > 0 and age < 150)

--e. currency
value  money

--f. masses of material
quantity  float check (quantity >= 0.0)  -- kilos