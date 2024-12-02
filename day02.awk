function check(skip_idx) {
  prev=skip_idx==1 ? $2 : $1
  min_diff=10
  max_diff=-10
  for (i=(skip_idx==1?3:2); i<=NF; i++) {
    if (i==skip_idx) continue
    diff=$i-prev
    prev=$i
    min_diff= min_diff < diff ? min_diff : diff
    max_diff= max_diff > diff ? max_diff : diff
  }
  return (min_diff >= 1 && max_diff <= 3 || min_diff >= -3 && max_diff <= -1)
}

{ 
  if (check(NF+1)) {
    part_one++
    part_two++
  } else {
    for (skip_idx=1; skip_idx<=NF; skip_idx++) {
      if (check(skip_idx)) {
        part_two++
        break
      }
    }
  }
}

END { print part_one, part_two }
