#!/bin/bash

IN=input-4.txt

declare -A patterns
declare -a sleeps

# populate patterns table
guard=0
while read -r lin; do
  echo -n "."
  minute=${lin:15:2}
  if [[ ${minute:0:1} = '0' ]]; then
    minute=${minute:1:1}
  fi
  if echo "$lin"|grep -q "Guard .* begins shift"; then
    guard=$(echo "$lin"|cut -f 2 -d '#'|cut -f 1 -d ' ')
  elif echo "$lin"|grep -q "falls asleep"; then
    startminute="$minute"
  elif echo "$lin"|grep -q "wakes up"; then
    for i in $(seq "$startminute" $((minute-1)) ); do
      patterns[$guard,$i]=$((patterns[$guard,$i]+1))
    done
    sleeps[$guard]=$((sleeps[guard]+minute-startminute))
  fi
done <<EOF
$(sort $IN)
EOF
echo

# find guard which sleeps most
bestguard=0
for guard in "${!sleeps[@]}"; do
  if [[ $(( sleeps[bestguard] )) -le ${sleeps[$guard]} ]]; then
    bestguard=$guard
  fi
done

echo "Guard $bestguard slept ${sleeps[$bestguard]} minutes"

# find best minute
bestminute=60
for minute in $(seq 0 59); do
  if [[ $(( patterns[$bestguard,$bestminute] )) -lt $(( patterns[$bestguard,$minute] )) ]]; then
    bestminute=$minute
  fi
done

echo "Best minute: $bestminute"

echo "Result=$((bestguard*bestminute))"

