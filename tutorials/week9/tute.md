# Relational Design Theory

## 1. Functional dependencies.

a. What functional dependencies are implied if we know that a set of attributes X is a candidate key for a relation R?
	if something is a candidate key, that means it is going to uniquely determine all the other attributes
b. What functional dependencies can we infer do not hold by inspection of the following relation?
	A->C
	B->C
	C->B
	C->A
	B->A
	AB->C
C. Suppose that we have a relation schema R(A,B,C) representing a relationship between two entity sets E and F with keys A and B respectively, and suppose that R has (at least) the functional dependencies A → B and B → A. Explain what this tells us about the relationship between E and F.


## 2. Consider the relation R(A,B,C,D,E,F,G) and the set of functional dependencies F = { A → B, BC → F, BD → EG, AD → C, D → F, BEG → FA } compute the following:

a. A+
	AB
b. ACEG+
	ABCEFG
c. BD+
	ABCDEFG

How to get candidate keys from FDs: if a closure has all the attributes


## 3. Consider the relation R(A,B,C,D,E) and the set set of functional dependencies F = { A → B, BC → E, ED → A }


3NF:
BCNF+
single attribute RHS needs to be part of any candidate key

BCNF:
2 attribute table is in BCNF
LHS must contain a candidate key

a. List all of the candidate keys for R.
	ACD
	BCD
	CDE
b. Is R in third normal form (3NF)?
	Yes
c. Is R in Boyce-Codd normal form (BCNF)?
	No

For each of the followings:
--list candidate keys
--show if in BCNF
--show if in 3NF

 C->D, C->A, B->C
a. List all of the candidate keys for R.
	B
b. Is R in third normal form (3NF)?
	No
c. Is R in Boyce-Codd normal form (BCNF)?
	No

ABC->D, D->A
a. List all of the candidate keys for R.
	ABC BCD
b. Is R in third normal form (3NF)?
	No
c. Is R in Boyce-Codd normal form (BCNF)?
	Yes

## 4.


## 5.
	teamname-> (captain, teamcolour) playername->teamplayedfor
	fanname->(address, fancolour, playername, teamname)
	teamname->