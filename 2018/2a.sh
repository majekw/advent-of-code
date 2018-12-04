#!/bin/bash

IN=input-2.txt

aa=0
bbb=0
while read -r lin; do
  if echo "$lin"|grep -o .|sort|uniq -d -c|grep -q "2"; then
    aa=$((aa+1))
  fi

  if echo "$lin"|grep -o .|sort|uniq -d -c|grep -q "3"; then
    bbb=$((bbb+1))
  fi  
done <<EOT
$(cat $IN)
EOT

echo "$aa x $bbb = $((aa*bbb))"
