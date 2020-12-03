# 1. Relational Design Theory

## 1.1 basics

* a good relational database design should capture all necessary attributes and their associations
* minimal amount of stored information

in database design, redundancy is generally a bad thing as it causes problems when maintaining consistency of the DB

## 1.2 normalisation basics

	insertion anomaly
	update anomaly
	deletion anomaly

	we want 

	a schema with minimal overlap between tables
	each table contains a coherent collection of data values

# 2. Functional Dependency

## 2.1 if two tuples in R agree in their values for the set of attributes X, then they must also agree in their values for the set of attributes Y.
	if a col has all the same values, every other column can determine it
	A->E, B->E, C->E, D->E

## 2.2 rules of inference (Armstrong's rules)
	* reflexivity 			X->X
	* Augmentation 			X->Y 			=> XZ->YZ
	* Transitivity 			X->Y, Y->Z 		=> X->Z
	* Additivity 			X->Y, X->Z 		=> X->YZ
	* Projectivity 			X->YZ 			=> X->Y, Y->Z
	* Pseudotransitivity	X->Y, YZ->W 	=> XZ->W

# 3. Closures and Covers

# 3.1 Closures
	* is a particular dependency X-> derivable from F
	* are two sets of dependencies equivalent


# 3.2 Determining Keys


# 3.3 Minimal keys