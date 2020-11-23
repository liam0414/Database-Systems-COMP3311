```sql
CREATE OR REPLACE FUNCTION public.dbpop()
RETURNS SETOF poprecord
LANGUAGE plpgsql
AS $function$
declare
	r record;
	nr integer;
	countQuery text;
	res PopRecord;
begin
	for r in select tablename
			 from pg_tables
			 where schemaname = 'public'
			 order by tablename
	loop
		countQuery = 'select count(*) from '||quote_ident(r.tablename) --for example, table capitalisation;
		execute countQuery into nr;
		res.tab_name := r.tablename; res.n_records: = nr;
		return next res;
	end loop;
	return;
end;
$function$

```

dbpop() returns set of pop record
database population

quote_ident: building query dynamicly, reference to any of the name in the query
quote_literal vs quote_ident
integer vs string


\ds