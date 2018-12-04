#!/bin/bash

licz=0

OUT=/tmp/1.out
rm $OUT
touch $OUT

while true; do cat input-1.txt; done | 
  while read -r liczba; do
    licz=$(( licz+(liczba) ))
    if grep "^$licz$" $OUT; then
	echo "==== $licz ====="
	exit
    fi
    echo $licz
    echo $licz >>$OUT
  done
