#!/bin/bash

IN=input-5.txt

# create pairs
for char in {a..z}; do
  compchar=${char^}
  pairs="$char$compchar $compchar$char $pairs"
done

shortest=99999999
for letter in {a..z}; do
  polymer=$(cat $IN|tr -d "${letter}${letter^}")
  polylen=${#polymer}
  # reduce polymer
  while true; do
    for pair in $pairs; do
      polymer=${polymer//$pair/}
    done
    if [[ $polylen -eq ${#polymer} ]]; then
      break
    fi
    polylen=${#polymer}
    echo -n "."
  done
  echo " $letter: ${#polymer}"
  if [[ ${#polymer} -le $shortest ]]; then
    shortest=${#polymer}
  fi
done

echo $shortest
