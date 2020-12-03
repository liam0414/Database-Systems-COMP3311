-- COMP3311 20T3 Final Exam
-- Q5: find genres that groups worked in

-- ... helper views and/or functions go here ...

create or replace view gstyles
as
select distinct g.id, g.name, a.genre
from groups g
    join albums a on a.made_by=g.id
order by a.genre
;

drop function if exists q5();
drop type if exists GroupGenres;

create type GroupGenres as ("group" text, genres text);

create or replace function
    q5() returns setof GroupGenres
as $$
declare
    _groupid integer;
    _groupName text;
    _genre text;
    _genres text;
begin
    for _groupid in (
        select id
        from groups
    )
    loop
        _genres:= '';
        select name into _groupName from groups where id=_groupid;
        for _genre in (select genre from gstyles where id=_groupid)
            loop
                _genres := _genres || _genre || ',';
            end loop;
            if length(_genres) > 0 then
                _genres := substr(_genres, 0, length(_genres));
            end if;
        return next (_groupName, _genres);
    end loop;
end;
$$ language plpgsql
;

