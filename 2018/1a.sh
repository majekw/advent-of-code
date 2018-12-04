#!/bin/bash

IN=input-1.txt

licz=0

while read -r liczba; do
    licz=$(( licz+(liczba) ))
    echo $licz
done <$IN
