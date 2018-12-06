#!/bin/bash

IN=input-4.txt

declare -A patterns

# populate patterns table
guards=
guard=0
while read -r lin; do
  echo -n "."
  minute=${lin:15:2}
  if [[ ${minute:0:1} = '0' ]]; then
    minute=${minute:1:1}
  fi
  if echo "$lin"|grep -q "Guard .* begins shift"; then
    guard=$(echo "$lin"|cut -f 2 -d '#'|cut -f 1 -d ' ')
    guards="$guard $guards"
  elif echo "$lin"|grep -q "falls asleep"; then
    startminute="$minute"
  elif echo "$lin"|grep -q "wakes up"; then
    for i in $(seq "$startminute" $((minute-1)) ); do
      patterns[$guard,$i]=$((patterns[$guard,$i]+1))
    done
  fi
done <<EOF
$(sort $IN)
EOF
echo

# find best minute and guard
maxsleep=0
for guard in $guards; do
  for minute in $(seq 0 59); do
    if [[ $(( patterns[$guard,$minute] )) -gt $maxsleep ]]; then
      maxsleep=${patterns[$guard,$minute]}
      bestguard=$guard
      bestminute=$minute
      echo "$guard, $minute, $maxsleep"
    fi
  done
done

echo "Result ( $bestguard x $bestminute ) = $((bestguard*bestminute))"
