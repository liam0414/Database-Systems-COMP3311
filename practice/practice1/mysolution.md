```sql
-- How many movies are in the database?

select count(*) from movies;

-- What are the titles of all movies in the database?

select title from movies;

-- What is the earliest year that film was made (in this database)? (Hint: there is a min() summary function)

select min(year) from movies;

-- How many actors are there (in this database)?

select count(*) from actors;

-- Are there any actors whose family name is Zeta-Jones? (case-sensitive)

select * from actors where familyname ~ 'Zeta-Jones';

-- What genres are there?

select distinct genre from belongsto;

-- What movies did Spielberg direct? (title+year)

select title
from movies
	join directs on movies.id=directs.movie
	join directors on directs.director=directors.id
where directors.familyname ~ 'Spielberg';

Which actor has acted in all movies (in this database)?

select a.familyname, a.givennames
from actors a
	join appearsin ap on a.id=ap.actor
group by a.id
having count(ap.movie) = (select count(*) from movies);

-- Are there any directors in the database who do not direct any movies?

select familyname, givennames
from directors
	join directs on directors.id=directs.director
group by directors.id
having count(directs.movie) = 0;