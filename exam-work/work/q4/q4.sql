-- COMP3311 20T3 Final Exam
-- Q4: list of long and short songs by each group
-- A "short" song is defined to be one whose length is strictly less that 3 minutes (180 seconds).
-- A "long" song is defined to be one whose length is strictly greater than 6 minutes (360 seconds).

create or replace view songLengths
as
select g.id, g.name, s.length
from songs s
	join albums a on s.on_album=a.id
	join groups g on g.id=a.made_by
order by g.id
;

create or replace view ShortSongs(id, name, nshort)
as
select id, name, count(name)
from songLengths
where length < 180
group by id, name
;

create or replace view LongSongs(id, name, nlong)
as
select id, name, count(name)
from songLengths
where length > 360
group by id, name
;

drop function if exists q4();
drop type if exists SongCounts;
create type SongCounts as ( "group" text, nshort integer, nlong integer );

create or replace function
	q4() returns setof SongCounts
as $$
declare
	_groupid integer;
	_groupname text;
	_nshort integer;
	_nlong integer;
begin
	for _groupid in (
		select id from groups
	)
	loop
		select name into _groupname from groups where id=_groupid;

		select nshort into _nshort from ShortSongs where id=_groupid;
		
		if (not found) then
			_nshort = 0;
		end if;

		select nlong into _nlong from LongSongs where id=_groupid;
		if (not found) then
			_nlong = 0;
		end if;

		return next (_groupname, _nshort, _nlong);
	end loop;

end;
$$ language plpgsql
;

