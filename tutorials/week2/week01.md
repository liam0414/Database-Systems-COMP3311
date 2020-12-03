# Solutions

## 2. In the context of database application development (aka database engineering), what are the aims of data modeling?
	It is a design process which takes design requirements and convert them into a data model
	* describe what information is contained
	* describe what relationships between data items
	* describe constraints on data

## 3. relationship vs relations
	Relationship
		* describes an association between n specific entities
		* a collection of relationships forms a relationship set
		* a relationship can have associated attributes

	In the relational model, the term relation is used to refer a table, while the term tuple is used to refer a row.
		* describes an association between a collection of attributes
		* an instance of a relation is a set of tuples of attribute values
		* a relation can be used to model a set of entities
		* a relation can also be used to model relationship sets (n-ary relationships with associated attributes)
		* every relation has a primary key

## 4. What kind of data, relationships and constraints exist in this scenario? (ask questions)

    * for each person, we need to record their tax file number (TFN), their real name, and their address
    	TFN: unique integer numbers, the number of digits has to cover the number of population as well as people who come to Australia to work
    	Real name: string, family name, given name, middle name
    	Address: Australian address, a valid address with unit number, building number, street name, street type, suburb, city, state, postcode

    * everyone who earns money in Australia has a distinct tax file number
    	total participation, every tax file number is associated with a person who earns money, 
    	partial participation, a person can have 0 or 1 tax file number

    * authors write books, and may publish books using a ``pen-name'' (a name which appears as the author of the book and is different to their real name)
    	book has 
    * editors ensure that books are written in a manner that is suitable for publication
    * every editor works for just one publisher
    * editors and authors have quite different skills; someone who is an editor cannot be an author, and vice versa
    * a book may have several authors, just one author, or no authors (published anonymously)
    * every book has one editor assigned to it, who liaises with the author(s) in getting the book ready for publication
    * each book has a title, and an edition number (e.g. 1st, 2nd, 3rd)
    * each published book is assigned a unique 13-digit number (its ISBN); different editions of the same book will have different ISBNs
    * publishers are companies that publish (market/distribute) books
    * each publisher is required to have a unique Australian business number (ABN)
    	publisher is identified by a unique ABN, they must have one, it is one to one relationship
    * a publisher also has a name and address that need to be recorded
    	data, publisher is the entity with attributes name and address
    * a particular edition of a book is published by exactly one publisher
    	one to one relationship

## 5. Consider some typical operations in the myUNSW system (ask question about c)

	a student enrolls in a lab class
	b student enrolls in a course
	c system prints a student transcript
	For each of these operations:

	* identify what data items are required
	* consider relationships between these data items
	* consider constraints on the data and relationships

	a. 
		1. student (zid, name) && lab (weeks, time, location, tutor, id, course)
		2. lab class is enrolled by one or many student, a student enrolls in a lab class, they can't enroll in multiple lab in the same course
		3. domain constraint, key constraints (zid, id)
	b.
		1. student (zid, name) && course(name, school, term, id etc)
		2. a course is enrolled by one or more students, a student can enroll in one or more courses
		3. domain constraint, key constraints (zid, id)
	c.
		????

## 6. Researchers work on different research projects, and the connection between them can be modeled by a WorksOn relationship. Consider the following two different ER diagrams to represent this situation. Describe the different semantics suggested by each of these diagrams.
	
	if the attribute is attached to the relationship, it belongs to the initiator

	for diagram (a)
		the time each researcher spends on each project that they are involved with
	for diagram (b)
		because time is an attribute of project, it refers to the total time allocated to the project by all researchers


## 8. The following two ER diagrams give alternative design choices for associating a person with their favourite types of food. Explain when you might choose to use the second rather than the first:
	
	When searching a multivalued attribute, a DBMS must search each value in the attribute, most likely scanning the contents of the attribute sequentially. A sequential search is the slowest type of search available. So it is better to create a new entity to represent the multivalue attribute


domain vs type

create domain is basically existing_type + constraint (i.e. a restricted version of the existing type)

create type is more flexible: you can create enumerated types, tuple types, range types and new base types.
Enumerated types require you specify a list of values, and define an ordering.

Tuple types define a list of attribute_name+attribute_type

Range and base types are more advanced and define genuinely new types.

The one place where create domain and create type might look similar is

create domain Colour as text check value in ('red','green','blue');
create type Colour as enum ('red','green','blue');