#!/bin/bash

IN=input-6.txt
IDEQ=99999	#dummy id of point with equal distance

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
      dx=${dx/-/}
      dy=${dy/-/}
      distance=$((dx+dy))
      if [[ -z ${field[$x,$y]} ]]; then
        field[$x,$y]="$i,$distance"
      elif [[ ${field[$x,$y]/*,/} -eq $distance ]]; then
        field[$x,$y]="$IDEQ,$distance"
      elif [[ ${field[$x,$y]/*,/} -gt $distance ]]; then
        field[$x,$y]="$i,$distance"
      fi
    done
  done
  echo
done

echo "calculating area"
for y in $(seq "$miny" "$maxy"); do
  echo -n "."
  for x in $(seq "$minx" "$maxx"); do
    area[${field[$x,$y]/,*/}]=$((area[${field[$x,$y]/,*/}] + 1 ))
  done
done
echo

echo "remove edge points"
for x in $(seq "$minx" "$maxx" ); do
  unset "area[${field[$x,$miny]/,*/}]"
  unset "area[${field[$x,$maxy]/,*/}]"
done
for y in $(seq "$miny" "$maxy" ); do
  unset "area[${field[$minx,$y]/,*/}]"
  unset "area[${field[$maxx,$y]/,*/}]"
done

echo "remove equal distance points"
unset "area[$IDEQ]"

# find max and print what left
max=0
for i in "${!area[@]}"; do
  echo "point $i, area ${area[$i]}"
  [[ ${area[$i]} -gt $max ]] && max=${area[$i]}
done
echo "Max: $max"
