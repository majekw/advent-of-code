#!/bin/bash

IN=input-5.txt

# create pairs
for char in {a..z}; do
  compchar=${char^}
  pairs="$char$compchar $compchar$char $pairs"
done

# reduce polymer
polymer=$(cat $IN)
polylen=${#polymer}

while true; do
  for pair in $pairs; do
    polymer=${polymer/$pair/}
  done
  if [[ $polylen -eq ${#polymer} ]]; then
    break
  fi
  polylen=${#polymer}
  echo -n "."
done

echo
echo ${#polymer}
