#!/bin/bash

IN=input-7.txt

declare -A steps

# read/populate dependency array
while read -r lin; do
  #Step H must be finished before step N can begin.
  step=${lin:5:1}
  nextstep=${lin:36:1}
  #create step in array'
  steps[$step]=${steps[$step]}
  #update dependency
  steps[$nextstep]="${steps[$nextstep]}$step"
done <<EOF
$(sort $IN)
EOF

while [[ ${#steps[@]} -gt 0 ]]; do
  #find first without dependency
  for i in "${!steps[@]}"; do
    #echo $i
    if [[ -z ${steps[$i]} ]]; then
      echo -n "$i"
      unset "steps[$i]"
      #remove from dependency
      for j in "${!steps[@]}"; do
        steps[$j]=${steps[$j]//$i/}
      done
      break
    fi
  done  
done
echo
