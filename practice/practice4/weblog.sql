-- COMP3311 Prac Exercise
--
-- Written by: z3278107


-- Q1: how many page accesses on March 2
create or replace view Q1(nacc) as
select count(*)
from Accesses
where acctime >= '2005-03-02' and acctime < '2005-03-03'
;


-- Q2: how many times was the MessageBoard search facility used?
create or replace view Q2(nsearches) as
select count(*)
from   Accesses
where  page like 'messageboard%' and params like '%state=search%'
;


-- Q3: on which Tuba lab machines were there incomplete sessions?
create or replace view Q3(hostname) as
select distinct h.hostname
from hosts h
	join sessions s on s.host=h.id
where s.complete='false' and h.hostname like 'tuba%'
;

-- Q4: min,avg,max bytes transferred in page accesses
create or replace view Q4(min,avg,max) as
... replace this line by your SQL query ...
;


-- Q5: number of sessions from CSE hosts

... replace this line by auxiliary views (or delete it) ...

create or replace view Q5(nhosts) as
... replace this line by your SQL query ...
;


-- Q6: number of sessions from non-CSE hosts

... replace this line by auxiliary views (or delete it) ...

create or replace view Q6(nhosts) as
... replace this line by your SQL query ...
;


-- Q7: session id and number of accesses for the longest session?

... replace this line by auxiliary views (or delete it) ...

create or replace view Q7(session,length) as 
... replace this line by your SQL query ...
;


-- Q8: frequency of page accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q8(page,freq) as
... replace this line by your SQL query ...
;


-- Q9: frequency of module accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q9(module,freq) as
... replace this line by your SQL query ...
;


-- Q10: "sessions" which have no page accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q10(session) as
... replace this line by your SQL query ...
;


-- Q11: hosts which are not the source of any sessions

... replace this line by auxiliary views (or delete it) ...

create or replace view Q11(unused) as
... replace this line by your SQL query ...
;
