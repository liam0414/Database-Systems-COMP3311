# 1. Relational Algebra

## 1.1 Relational algebra can be viewed as
	* mathematical system for manipulating relations, or
	* data manipulation language for the relational model

## 1.2 Relational algebra consists of:
	* operands: relations, or variables representing relations
	* operators that map relations to relations
	* rules for combining operands/operators into expressions
	* rules for evaluating such expressions

## 1.3 core relational algebra operations
	* rename
	* selection
	* projection
	* union, intersection, difference
	* product, join
	* aggregation, projection++, division

## 1.4 Operation		Standard Notation		Our Notation
		Selection		σexpr(Rel)				Sel[expr](Rel)
		Projection		πA,B,C(Rel)				Proj[A,B,C](Rel)
		Join			Rel1 ⨝expr Rel2			Rel1  Join[expr]  Rel2
		Rename			ρschemaRel				Rename[schema](Rel)

## 1.5 Rename
	R(A1, A2, ... An) -> Rename[S(B1, B2, ... Bn)](E)

## 1.6 Selection
	σexpr(Rel) = Sel[expr](Rel) = {t|t∈r∧C(t)} C is a boolean expression on attributes in R

	selection corresponds to the where clause and select clause is actually the projection operation!!!!!!
		* example:Proj[b](Sel[a > 5](R)) select b from R where a > 5
```sql
	select * from R where a > 5 is therefore (Sel[a > 5](R))


	select * from Beers where manf='Sierra Nevada'
	SNBeers = Sel[manf=Sierra Nevada](Beers)
	Result  = Rename[beer](Proj[name](SNBeers))
	select name as beer from Beers where manf='Sierra Nevada'
```

## 1.7 Projection
	πX(r = Proj[X](r) = {t[X]|t∈r}, where r(R)

	* Names of all beers
	Result = Proj[name](Beers)
	select name from Beers

	* Names of drinkers who live in Newtown
	Result = Proj[name](Sel[addr=Newtown](Drinkers))
	select name from drinkers where addr='Newtown'

	* What are all of the breweries?
	Result(brewer) = Proj[manf](Beers)
	select distinct manf from beers

# 2. RA Set Operations

## 2.1 Relational algebra defines three set operations
	* union   ...   R∪S   ...   (Query1) UNION (Query2)
		must have attributes in common
	* intersection   ...   R∩S   ...   (Query1) INTERSECT (Query2)
	* difference   ...   R-S   ...   (Query1) EXCEPT (Query2)

	!!! remember all these set operations don't generate duplicates

## 2.2 Union
	Union combines two compatible relations into a single relation via set union of sets of tuples.
	r1 ∪ r2 = {t|t∈r1 ∨ t∈r2}, where r1(R), r2(R)

## 2.3 Intersection
	Intersection combines two compatible relations into a single relation via set intersection of sets of tuples.
	r1 ∩ r2 = {t|t∈r1 ∧ t∈r2}, where r1(R), r2(R)
	example:
		JohnBars = Proj[bar](Sel[drinker=John](Frequents))
		GernotBars = Proj[bar](Sel[drinker=Gernot](Frequents))
		Result = JohnBars union GernotBars

## 2.4 Difference
	Difference finds the set of tuples that exist in one relation but do not occur in a second compatible relation.
	* r1 - r2: remove anything in r1 and r2 from r1
	* r2 - r1: remove anything in r2 and r1 from r2

# 3. RA Join Operations

## 3.1 Basics
	product   ...   R × S   ...   select * from R join S on (true)
	natural join   ...   R ⨝ S   ...   select * from R natural join S
	(inner) join   ...   R ⨝C S   ...   select * from R join S on (C)
	outer join   ...   R ⟕C S   ...   select * from R left outer join S on (C)
	division   ...   R / S   ...   see SQL slides for examples

## 3.2 Product
	 Product (Cartesian product) combines information from two relations pairwise on tuples.
	 example:
	 	R is a 3 cols x 3 rows table
	 	S is a 2 cols x 2 rows table
	 	the product RxS is a 5 cols x 6 rows table

## 3.3 Natural Join
	Natural join is a specialised product:
	* containing only pairs that match on common attributes
	* with one of each pair of common attributes eliminated
	result = {}
	for each tuple t1 in relation r
	   for each tuple t2 in relation s
	      if (matches(t1,t2))
	         result = result ∪ {combine(t1,t2)}

## 3.4 Theta Join
	The theta join is a specialised product containing only pairs that match on a supplied condition C.
	Querying with relational algebra (join) ...

	Who drinks in Newtown bars?
	NewtownBars(nbar) = Sel[addr=Newtown](Bars)
	Tmp = Frequents Join[bar=nbar] NewtownBars
	Result(drinker) = Proj[drinker](Tmp)
	Who drinks beers made by Carlton?
	CarltonBeers = Sel[manf=Carlton](Beers)
	Tmp = Likes Join[beer=name] CarltonBeers
	Result(drinker) = Proj[drinker] Tmp

## 3.5 Outer Join
	R ⨝C S does not include in its result

	values from any R tuples that do not match some S tuple under C
	values from any S tuples that do not match some R tuple under C
	R ⟕C S (left outer join) includes
	all tuples that would result from a theta join
	values from all R tuples, even with no matching S tuple
	For tuples with no match, assign NULL to "unmatched" attributes

	Variants are right outer join and full outer join

## 3.6 Division
	Consider two relation schemas R and S where S ⊂ R.
	The division operation is defined on instances r(R), s(S) as:
	r/s = r Div s = {t|t ∈ r[R-S] ∧ satisfy}
	where satisfy = ∀ ts ∈ S ( ∃ tr ∈ R (tr[S] = ts ∧ tr[R-S] = t ))

	
