# 1. Overview

## 1.1. Database application development

	DAD is a variation on standard software engineering process:
	1. analyse application requirements
	2. develop a data model to meet these requirements
	3. check data model for redundancy
	4. implement the data model as relational schema
	5. define operations on this model
	6. implement operations via SQL and procedural PLs
	7. construct a program interface to these operations
	8. monitor performance and tune the schema

## 1.2. Database System Architecture
	PSQL 	<-> Query engine <-> Data stored on disk
	Clients <-> Server 		 <-> Database

# 2. Data modeling
	Aims of data modeling:
		* describe what information is contained
		* describe what relationships between data items
		* describe constraints on data

## 2.1. logical data model and physical data model
	* logical: abstract, ER (what we are looking at)
	* physical record-based for implementation, relational, SQL (collection of tuples)

	Requirements -> ER Model -> Relational Model (relations, tuples, domains) -> SQL schema (tables, data type, constraints)

## 2.2. relationship vs relations
	A row in a table represents a relationship among a set of values, relations are used to model both entities and relationship
	In the relational model, the term relation is used to refer a table, while the term tuple is used to refer a row.
	A relationship among two or more entities represents an association among the entities

## 3. Entity-relationship Model
	attribute: An attribute represents some property of interest that further describes an entity.
	entity: An entity represents a real-world object or concept.
	relationship: A relationship among two or more entities represents an association among the entities

	composite attribute: name->(family name) + (given name)
	derived attribute: age->(current date) - (birthday)
	multivalued attribute-> double ovals

	candidate key = minimal super key
	primary key = candidate key chosen by DBD

## 3.1. relationship sets
	relationship set: collection of relationships of the same type
	degree: number of entities involved in the relationship
	cardinality: associated entities on each side of the relationship
	participation: must every entity be in the relationship

## 3.2. participation
	total participation 1 or more
	total participation with arrow exact 1
	partial participation 0 or more
	partial participation with arrow 0 or 1

## 3.3. subclass and inheritance
	overlapping or disjoint
	total or partial

	person 		-> o -> Doctor + Patient: a person may be a doctor and/or maybe a patient or maybe neither
	employee	=> d -> permanent + contract: an employee has to be either permanent or contract

## 3.4. tuples
	tuple has inherit order, tuples (2,3) != (3,2)

## 3.5. NULL value
	A distinguished value NULL belongs to all domains

## 3.6. relation(table)
	account relation: Attributes (Columns: account number, balance branch name), Tuples(Rows: records)

## 4. relational model
	pink arrows, there is a relationship, for example, a branch in account must appear in branch

	database instance example:
	account: branch name, account number, balance
	branch:branch name, address, assets
	heldby: account, customer
	customer: name, address, customer number, home branch

## 4.1 Constraints
	integrity constraints
	* what values are/are not allowed
	* what combinations of values are/are not allowed

	domain constraints: limits the set of values that attributes can take (type, format, range, etc)
	
	key constraints: identify attributes that uniquely identify tuples (which attribute uniquely identify tuples)
	
	entity integrity constraints: require keys to be fully-defined (all keys to have values, for example, a customer must have some accounts, and the accounts must be known, they can't be NULL values)
	
	referential integrity constraints: require references to other tables to be valid (links between tables must exist)

	Null satisfies all domain constraints unless Null is not allowed

## foreign key
	foreign key is always related to a primary key in another table
	* they provide links to individual relations
	* they assemble query answers from multiple tables
	* the relational representation of ER relationships

## relational database
	A relational database schema is a set of relation schema and a set of integrity constraints
	A relational database instance is a set of relation instances where all of the integrity constraints are satisfied