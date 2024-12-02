#!/bin/bash

set -euo pipefail

input=./input/input01.txt

# Part one
tmp_a=$(mktemp -q /tmp/a.XXX)
tmp_b=$(mktemp -q /tmp/b.XXX)
total=0

cat $input | awk -F' ' '{print $1}' | sort -n > $tmp_a
cat $input | awk -F' ' '{print $2}' | sort -n > $tmp_b

while read a b; do
  [[ $a -gt $b ]] && (( total += a-b )) || (( total += b-a ))
done < <(paste $tmp_a $tmp_b)

echo "Part one: $total"

# Part two
declare -a counts
while read b; do
  (( counts[$b]++ ))
done < $tmp_b

sim=0
while read a; do
  (( sim += $a * counts[$a] ))
done <$tmp_a

echo "Part two: $sim"
