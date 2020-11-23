# week 3 online session 1

## 1. loop sql table, two tables referencing to each other's primary key

### option 1: insert foreign keys as null values, then update foreign keys to the correct values

	updtae R set s = 'a' where id = 1;
	update S set r = 2 where id = 'a';
	update R set s = 'b' where id = 2;
	update S set r = 1 where id = 'b';


### option 2: transaction
```sql
	alter table R add foreign key (s) references S(id) deferrable;
	create table S (
		id char(1) primary key,
		r integer references R(id) deferrable
	);
	begin;
	set contraints all deferred;
	insert into R values (1, 'a');
	insert into S values ('a', 2);
	commit;
```

### option 3: alter table
```
alter table TABLE1
	add constraint fk_attr foreign key(attr) references TABLE2(attr);

alter table TABLE2
	add constraint fk_attr foreign key(attr) references TABLE1(attr);
```