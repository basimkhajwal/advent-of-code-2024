import math
import std/sequtils
import std/strutils

var part_one = 0
var part_two = 0

for line in lines("input/input07.txt"):
  let line = line.split(':')
  let target = parseInt(line[0])
  let nums = map(line[1].strip().split(), parseInt)

  var valid_one = false
  for i in 0 ..< (2^(nums.len-1)):
    var acc = nums[0]
    var k = i
    for j in 1 .. nums.len-1:
      if k mod 2 == 0: acc*=nums[j]
      else: acc+=nums[j]
      k = k div 2
    if acc==target:
      valid_one = true
      break
  if valid_one:
    part_one += target
    part_two += target
    continue

  var valid_two = false
  for i in 0 ..< (3^(nums.len-1)):
    var acc = nums[0]
    var k = i
    for j in 1 .. nums.len-1:
      if k mod 3 == 0: acc*=nums[j]
      elif k mod 3 == 1: acc+=nums[j]
      else: acc = parseInt(intToStr(acc) & intToStr(nums[j]))
      if acc > target: break
      k = k div 3
    if acc == target:
      valid_two = true
      break
  if valid_two: part_two += target

echo part_one
echo part_two
