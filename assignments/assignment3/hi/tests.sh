#!/bin/bash
if [ -d "./tests" ]; then
	echo "Directory /comp3311/ass3/tests exists."
else
	echo "Directory /comp3311/asst3/tests doesn't exists. please create 'tests' folder in your ass3 or assignment3 folder and have 02 03 04 checks in the folder"
	exit 1
fi

rm tests/*.observed
for t in 10 1 1.1 0 -1 -100 20 xyz
do
	echo === Testing Best with $t ===
	echo === Test $t === >> tests/best.observed
	./best $t >> tests/best.observed
	printf "\n" >> tests/best.observed
done

while read line
do
	echo === Testing Rels with $line ===
	echo === Test $line === >> tests/rels.observed
	echo ./rels $line | sh >> tests/rels.observed
	printf "\n" >> tests/rels.observed
done < tests/02

while read line
do
	echo === Testing minfo with $line ===
	echo === Test $line === >> tests/minfo.observed
	echo ./minfo $line | sh >> tests/minfo.observed
	printf "\n" >> tests/minfo.observed
done < tests/03

while read line
do
	echo === Testing bio with $line ===
	echo === Test $line === >> tests/bio.observed
	echo ./bio $line | sh >> tests/bio.observed
	printf "\n" >> tests/bio.observed
done < tests/04

	echo "You have finished all the tests without any syntax error(maybe)"
	echo "now you can run command 'diff *.observed *.expected' in your tests folder"