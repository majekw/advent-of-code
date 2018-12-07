#!/bin/bash

IN=input-6.txt

# get all points from file
mapfile -t points < "$IN"

# calculate field size
minx=999999
miny=999999
maxx=0
maxy=0
for i in "${!points[@]}"; do
  [[ ${points[$i]/,*/} -gt $maxx ]] && maxx=${points[$i]/,*/}
  [[ ${points[$i]/,*/} -lt $minx ]] && minx=${points[$i]/,*/}
  [[ ${points[$i]/*, /} -gt $maxy ]] && maxy=${points[$i]/*, /}
  [[ ${points[$i]/*, /} -lt $miny ]] && miny=${points[$i]/*, /}
done
echo "array min: $minx,$miny max: $maxx,$maxy"

# populate field
declare -A field
for i in "${!points[@]}"; do
  echo "point $i"
  px=${points[i]/,*/}
  py=${points[i]/*, /}
  for y in $(seq "$miny" "$maxy" ); do
    echo -n "."
    for x in $(seq "$minx" "$maxx" ); do
      dx=$((px-x))
      dy=$((py-y))
      dx=${dx#-}
      dy=${dy#-}
      distance=$((dx+dy))
      field[$x,$y]=$(( ${field[$x,$y]} +distance ))
    done
  done
  echo
done

echo "calculating area"
area=0
for y in $(seq "$miny" "$maxy"); do
  echo -n "."
  for x in $(seq "$minx" "$maxx"); do
    [[ ${field[$x,$y]} -lt 10000 ]] && area=$((area+1))
  done
done
echo

echo "Area: $area"
