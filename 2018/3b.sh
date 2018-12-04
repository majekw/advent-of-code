#!/bin/bash

IN=input-3.txt

echo "Creating empty field"
for i in $(seq 0 999); do
  area[$i]=$(printf "%.1000d" 0)
done


echo "Filling field with data"
#1366 @ 251,558: 27x28
while read -r lin; do
  echo "$lin"
  x=$(echo "$lin"|cut -f 3 -d ' '|cut -f 1 -d ',')
  y=$(echo "$lin"|cut -f 2 -d ','|cut -f 1 -d ':')
  dx=$(echo "$lin"|cut -f 4 -d ' '|cut -f 1 -d 'x')
  dy=$(echo "$lin"|cut -f 2 -d 'x')
  #echo "$x $y $dx $dy"
  # iterate over square boxes
  for iy in $(seq "$y" $((y+dy-1)) ); do
    for ix in $(seq "$x" $((x+dx-1)) ); do
      #echo "$ix $iy"
      if [[ ${area[$iy]:$ix:1} = "0" ]]; then
        area[$iy]="${area[$iy]:0:$ix}1${area[$iy]:$ix+1}"
      elif [[ ${area[$iy]:$ix:1} = "1" ]]; then
        area[$iy]="${area[$iy]:0:$ix}X${area[$iy]:$ix+1}"
      fi
    done
  done 
done <<EOT
$(cat $IN)
EOT

echo "Checking for overlapping"
#1366 @ 251,558: 27x28
while read -r lin; do
  echo "$lin"
  x=$(echo "$lin"|cut -f 3 -d ' '|cut -f 1 -d ',')
  y=$(echo "$lin"|cut -f 2 -d ','|cut -f 1 -d ':')
  dx=$(echo "$lin"|cut -f 4 -d ' '|cut -f 1 -d 'x')
  dy=$(echo "$lin"|cut -f 2 -d 'x')
  # iterate over square boxes
  overlap=0
  for iy in $(seq "$y" $((y+dy-1)) ); do
    for ix in $(seq "$x" $((x+dx-1)) ); do
      if [[ ${area[$iy]:$ix:1} == "X" ]]; then
        overlap=1
      fi
    done
  done
  if [[ $overlap -eq 0 ]]; then
    echo "=found= $lin"
  fi
done <<EOT
$(cat $IN)
EOT

