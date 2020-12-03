-- COMP3311 20T3 Final Exam
-- Q2: group(s) with no albums
-- Write an SQL view that report which group(s) have no albums (at least not in the database).

create or replace view GroupsWithAlbums("group")
as
select g.name
from Groups g, Albums a where a.made_by=g.id
;

create or replace view AllGroups("group")
as
select name
from Groups
;

create or replace view GroupsWithoutAlbums ("group")
as 
(select * from AllGroups) 
except
(select * from GroupsWithAlbums)
;

create or replace view q2("group")
as
select *
from GroupsWithoutAlbums
;
