```sql
create domain TFN as char(11) check (tfn ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$')
tfn TFN,
check (tfn ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$') --matching exactly ^ $




```


mapping relationships
multiple table mappings
    disjointness: not enforceable
    total participation: not enforceable
single table mappings
    disjointness: enforceable
    total participation: enforceable

    subclass char(1) check(subclass in ('a', 'e', 'b'))

attribute in original table (total participation enforceable)
    1:1
        attribute in original table 
        total participation enforceable, but not both sides
    1:N

    Entity 1 === relationship ---> Entity 2
        enforceable
        attribute goes in entity 1

    Entity 1 --- relationship ===> Entity 2
        not enforceable

        valid explanation: because we must store

entirely new table (total participation not enforceable)
    N:M
    total participation never enforceable


## 5. Consider the following two relation definitions:
For each, show the possible ways of defining the primary key in the corresponding SQL create table statement.
a. 
create table R (
    id      integer,
    name    text,
    address text,
    d_o_b   date,
    primary key(id)
);

or 

create table R (
    id      integer primary key,
    name    text,
    address text,
    d_o_b   date
);

b.
create table S(
    name    text,
    address text,
    d_o_b   date,
    primary key(name, address)
);

## 7. Convert the following entity into an SQL CREATE TABLE definition:

create table companyListing(
    name        varchar(5) PRIMARY KEY,
    sharePrice  numeric(6,2),
    netWorth    numeric(20,2)
);

## 8. Convert the following entity into an SQL CREATE TABLE definition:

create table Person(
    familyName      varchar(30),
    givenName       varchar(30),
    initial         char(1),

    streetNo    integer,
    streetName      varchar(40),
    suburb          varchar(40),

    birthday        date,

    PRIMARY KEY     (familyName,givenName,initial)

);

## 10. Convert the following ER design into an SQL schema:

create table Supplier(
    name        text,
    city        text,
    primary key(name)
);

create table Part(
    number      integer,
    colour      text,
    primary key(number)
);

create table Supply(
    quantity    integer,
    supplier    text,
    part        integer,
    primary key(supplier, part),
    foreign key(supplier) references Supplier(name),
    foreign key(part) references Part(number)
);

## 11. Convert the following ER design into a sequence of statements in the SQL data definition language:
```sql
create table Cars(
    regoID  char(6),
    model   text,
    year    integer check (integer > 1900),
    primary key (regoID)
);

create table owns(
    licence integer,
    rego    char(6),
    primary key(licence, rego),
    foreign key(licence) references People(licenceID),
    foreign key(rego) references Cars(regoID)
);

create table People(
    licenceID integer,
    name    text,
    address text,
    primary key(licenceID)
);

create table involved(
    damage  money,
    rego    char(6),
    licence integer,
    report  integer,
    primary key(rego, licence, report),
    foreign key(rego) references Cars(regoID)
    foreign key(licence) references People(licenceID),
    foreign key(report) references Accidents(reportID)
);

create table Accidents(
    reportID integer,
    location text,
    date     date,
    primary key(report)
);

ER design
Relational data model
SQL schema


12. 
-- total participation means not null

CREATE TABLE Teams(
    name    varchar(50) PRIMARY KEY,
    captain varchar(50) NOT NULL REFERENCES Players(name)
);

CREATE TABLE Player(
    name    varchar(50) PRIMARY KEY,
    playfor varchar(50) NOT NULL REFERENCES Teams(name)
);

CREATE TABLE Fans(
    name    varchar(50) PRIMARY KEY
);

CREATE TABLE TeamColours(
    team    varchar(50) NOT NULL REFERENCES Teams(name),
    colours text,
    PRIMARY KEY(team, colours)
);

CREATE TABLE FavouritesTeam(
    teamName varchar(50) REFERENCES Teams(name),
    fanName varchar(50) REFERENCES Fans(name),
    PRIMARY KEY(teamName, fanName)
);

CREATE TABLE FavouritesPlayer(
    playerName varchar(50) REFERENCES Players(name),
    fanName varchar(50) REFERENCES Fans(name),
    PRIMARY KEY(playerName, fanName)
);

CREATE TABLE FavColours(
    fan     varchar(50) REFERENCES Fans(name),
    colours text,
    PRIMARY KEY(fan, colours)
);
```

13. 
```sql
create table Trips(
    tripNo      integer PRIMARY KEY,
    tripDate    date,
    uses        integer REFERENCES Trucks(truckNo)
);

create table Warehouses(
    location    text PRIMARY KEY
);

create table Source(
    trip        integer REFERENCES Trips(tripNo),
    location    text REFERENCES Warehouses(location),
    PRIMARY KEY(trip, location)
);

create table Trucks(
    truckNo     integer PRIMARY KEY,
    maxweight   float,
    maxvolume   float
);

create table Shipments(
    shipmentNo  integer PRIMARY KEY,
    volume      float,
    weight      float,
    trip        integer REFERENCES Trip(tripNo),
    store       varchar(60) REFERENCES Store(address)
);

create table Store(
    storeName   varchar(50),
    address     varchar(60) PRIMARY KEY
);

14. Convert the following ER design to relational form:

create table Employees(
    SSN         integer,
    birthday    date,
    name        text,
    worksfor    text not null, --foreign key is added later
    primary key(SSN)
);

create table Departments(
    name        text,
    phone       integer,
    location    text,
    manager     integer,
    mdate       date,
    primary key(name),
    foreign key(manager) references employees(SSN),
);

create table Dependent(
    name        text,
    relation    text, 
    birthday    date,
    employee    integer,
    foreign key(employee) references employees(SSN),
);

create table Projects(
    pnum
    title
);

create table Participation(
    employee
    project
    time
);
```
15. Using this version of the Person class hierarchy, convert the ER design to relational form as an SQL schema:
Give mappings using both the ER style and single-table-with-nulls style.
```sql
create table Persons(
    SSN         integer,
    name        varchar(50),
    address     text,
    primary key(SSN)
);

create table Doctors(
    yearsExp    integer,
    SSN         integer,
    primary key(SSN),
    foreign key(SSN) references Persons(SSN)
);

create table Specialities(
    Specialty   text check (specialty in ('Feet','Ears','Throat')),,
    doctor      integer,
    primary key(doctor),
    foreign key(doctor) references Doctors(SSN)   
);

create table Patients(
    d_o_b       date,
    SSN         integer,
    primary key(SSN),
    foreign key(SSN) references Persons(SSN)
);

Create table Pharmacists(
    qualifica   text,
    SSN         integer,
    primary key(SSN),
    foreign key(SSN) references Persons(SSN)
);
```
17. Convert this ER design for the medical scenario into relational form:
```SQL
CREATE DOMAIN TaxFileNum as char(9) check (value ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$');
CREATE DOMAIN ISBNCheck as char(13) check (value ~ '^[A-Z][0-9]{3}-[0-9]{4}-[0-9]{5}$');
CREATE DOMAIN ABNCheck as integer check (value > 100000);

--publisher and person needs to be at the begining because of dependency
CREATE TABLE Publishers(
    abn         ABNCheck,
    name        text,
    address     text,
    primary key(abn)
);

CREATE TABLE Persons(
    tfn         TaxFileNum,
    name        varchar(50),
    address     varchar(100),
    primary key(tfn)
);

-- the disjoint constraint can't be represented in the ER model

CREATE TABLE Authors(
    tfn         TaxFileNum,
    penName     varchar(50),
    primary key(tfn),
    foreign key(tfn) references Persons(tfn)
);

CREATE TABLE Editors(
    tfn         TaxFileNum,
    worksfor    ABNCheck,
    primary key(tfn),
    foreign key(tfn) references Persons(tfn),
    foreign key(worksfor) references Publishers(ABN)
);

CREATE TABLE Books(
    isbn        ISBNCheck,
    title       varchar(100),
    edition     integer check (edition > 0),
    editor      TaxFileNum NOT NULL,
    publisher   ABNCheck NOT NULL,
    primary key(isbn),
    foreign key(editor) references Editors(tfn),
    foreign key(publisher) references Publishers(ABN)
);

CREATE TABLE Writes(
    person      TaxFileNum,
    book        ISBNCheck,
    primary key(person, book),
    foreign key(person) references Persons(tfn),
    foreign key(book) references Books(isbn)
);

---------------------------------------------
--single-table-with-nulls
CREATE TABLE Publishers(
    abn         ABNCheck,
    name        text,
    address     text,
    primary key(abn)
);

CREATE TABLE Persons(
    tfn         TaxFileNum,
    name        varchar(50),
    address     varchar(100),
    isAuthor    boolean,
    isEditor    boolean,
    penName     varchar(50),
    worksfor    ABNCheck not null,,
    primary key(tfn)
    foreign key(worksfor) references Publishers(ABN)
);

CREATE TABLE Books(
    isbn        ISBNCheck,
    title       varchar(100),
    edition     integer check (edition > 0),
    editor      TaxFileNum NOT NULL,
    publisher   ABNCheck NOT NULL,
    primary key(isbn),
    foreign key(editor) references Editors(tfn),
    foreign key(publisher) references Publishers(ABN)
);

CREATE TABLE Writes(
    person      TaxFileNum,
    book        ISBNCheck,
    primary key(person, book),
    foreign key(person) references Persons(tfn),
    foreign key(book) references Books(isbn)
);