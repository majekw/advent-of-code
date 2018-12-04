#!/bin/bash

IN=input-2.txt

for i in $(seq 1 $(( $(head -n1 $IN|wc -c) +1)) ); do
  echo "position: $i"
  if [[ $i -eq 1 ]]; then
    param="2-"
  else
    param="1-$((i-1)),$((i+1))-"
  fi
  cat $IN | cut -c "$param"|sort|uniq -d
done