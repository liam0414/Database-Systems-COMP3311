# 1.Transactions

## 1.1 shared-concurrent access by multiple users
unstable-potential for hardware/software failure

	1. Transaction processing(we only look at this)
	2. Concurrency control
	3. Recovery mechanisms

## 1.2 Transactions must be ACID(atomic, consistent, isolated, durable)

* atomic: fully completed or completed rolled back(either total completed or total failed)
* consistent: map DB between consistent states (still satisfy all constraints)

isolated: transactions do not interfere with each other (transactions are independent)
durable: persistent, restorable

## 1.3 Bank funs transfer

* move N dollars from account x to account Y
* accounts(id, name, balance, heldat, ...)
* branches(id, name, address, assets, ...)
* maintain branches.assets as sum of balances via triggers
* other conditions
	has three parameters: amount,source acct, dest acct
	check validity of suppied accounts
	check sufficient available funds
	returns a unique transaction ID on success

```sql
create or replace function
	transfer(N integer, src text, dest text)
	returns integer
declare
	sid integer;
	did integer;
	avail integer;
begin
	-- check accounts
	select id, balance into sid, avail
	from accounts where name=src;
	if (sid is null) then
		raise exception 'invalid source account %', src;
	end if;

	select id into did
	from accounts where name=dest;
	if (sid is null) then
		raise exception 'invalid dest account %', dest;
	end if;	

	if (avail < N) then
		raise exception 'insufficient funds account %', src;
	end if;

	update accounts set balance = balance-N
	where id=sid;

	update accounts set balance = balance+N
	where id=did;
	return nextval('tx_id_seq');

```
if something fails in the middle, we want to roll back to its original accounts, therefore we use trigger to do this

## 1.4 transaction consistency

transactions typically have intermediate states that are invalid, however, states before and after transactions must be valid
valid=consistent=satisfying all stated constraints on the data


# 2.Schedules

## 2.1 
* Read - transfer data item from database to memory
* Write - transfer data item from memory to database

Begin - start a transction
Commit - successfully complete a transaction
Abort - fully rewinded

## 2.2
relating SQL to read/write

	1. select produces read
	2. insert produces write
	3. update, delete produce both read and write operations

## 2.3 translate SQL to schedule

```
get balance from source account
get balance from destination account
if (sufficient balance)
	update source
	update destination
```

-- no concurrency
T1: R(X) W(X) R(Y) W(Y)
T2:                     R(X) W(X) R(Y) W(Y)

-- with concurrent execution
T1: R(X)      W(X)      R(Y)      W(Y)
T2:      R(X)      W(X)      R(Y)      W(Y)


## 3. Serializability

* conflict serializibility

R(A)R(B) = R(B)R(A)
W1(X)W2(X) != W2(X)W1(X)
W(A)W(B) = W(B)W(A)
W(B)R(A) = R(A)W(B)

IF THERE IS CYCLE, IT IS NOT SERIALIZABLE

* view serializibility

one of the possibilities