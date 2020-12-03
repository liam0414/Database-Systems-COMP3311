Typical Question
1. Which elements of the ER design do not appear in the relational version
	* multi-value
	* total participation
	* disjoint
	* 1:n relationships

At a syntactic level, the 1:n relationships (Includes, Uses, Destination) do not appear as tables in the relational model. They are implemented by foreign keys in the table which has only one associated entity.

Multivalue 
At a syntactic level, the multi-valued attributes from the ER design do not appear directly in the relational model, but are replaced by tuples in the TeamColours and FavColours tables.

At a semantic level, it does not capture the total participation of the Team entity in the PlaysFor relationship. While all players have to play for a team, the diagram does not enforce that each team must have at least one player who plays for it (except indirectly via the fact that it has to have a captain

2. mutual interdependence
The above SQL schema is simple, but doesn't actually load because of the mutual interdependence of Player and Team. To fix this, you would need something like the following:
```sql
-- create Team without the foreign key and then add it once Player exists
CREATE TABLE Teams
(
	name      varchar(50) PRIMARY KEY,
	captain   varchar(40) NOT NULL
);
CREATE TABLE Players
(
	name      varchar(40) PRIMARY KEY,
	team      varchar(50) NOT NULL REFERENCES Teams(name)
);
ALTER TABLE Teams ADD FOREIGN KEY (captain) REFERENCES Players(name);

-- alternatively, move the captain foreign key to the Player table
--   which is allowed because it's a 1:1 mapping

CREATE TABLE Team
(
	name      varchar(50) PRIMARY KEY
);
CREATE TABLE Player
(
	name      varchar(40) PRIMARY KEY,
	team      varchar(50) NOT NULL REFERENCES Teams(name)
	captain   varchar(50) REFERENCES Teams(name)
);
```