```sql
create table R(
    id text,
    s  text,
    primary key(id)
);

create table S(
    id text,
    r  text,
    primary key(id),
    foreign key(r) references R(id)
);

alter table R add foreign key (s) references S(id);

solution 1: alter table R add foreign key (s) references S(id);
solution 2: r text references R(id) deferrable