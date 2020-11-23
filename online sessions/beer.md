```sql
create table R(
    id text,
    s  text,
    primary key(id),
    foreign key(id) references S(r)
);

create table S(
    id text,
    r  text,
    primary key(id),
    foreign key(id) references R(s)
);

```