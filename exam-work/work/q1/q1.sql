-- COMP3311 20T3 Final Exam
-- Q1: longest album(s)

create or replace view AlbumLengths(id, title, made_by, year, albumlength)
as
select a.id, a.title, a.made_by, a.year, sum(s.length)
from Albums a, Songs s
where s.on_album=a.id
group by a.id, a.title
;

create or replace view q1("group",album,year)
as
select g.name, title, year
from AlbumLength
    join groups g on made_by=g.id
where albumlength = (select max(albumlength) from AlbumLengths)
;

