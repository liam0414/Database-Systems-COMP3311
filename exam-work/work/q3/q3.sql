-- COMP3311 20T3 Final Exam
-- Q3:  performer(s) who play many instruments

-- novocal
create or replace view novocal
as
select performer, instrument
from PlaysOn
where instrument != 'vocals'
;

-- distinct instruments
create or replace view dist
as
select distinct performer, instrument
from novocal
;

-- number of guitars played -1 for 'guitar' category
create or replace view guitars(name, ninst)
as
select p.id, (count(d.instrument) - 1)
from Performers p, dist d
where instrument ~ 'guitar' and p.id = d.performer
group by p.id
;

-- number of instrumnets played
create or replace view nPlayed(name, ninst)
as
select p.id, count(d.instrument)
from Performers p, dist d
where p.id = d.performer
group by p.id
;

create or replace view q3a(name, ninst)
as
select p.name, (n.ninst - g.ninst)
from guitars g
    join nPlayed n on n.name=g.name
    join performers p on n.name=p.id
order by (n.ninst - g.ninst) desc
;

create or replace view q3(performer,ninstruments)
as
select * 
from q3a
where ninst > 
    (
    select
        (select count(distinct instrument) from novocal) + 1
        - 
        (select count(distinct instrument) from PlaysOn where instrument ~ 'guitar')
    ) / 2 -- more than half
;


