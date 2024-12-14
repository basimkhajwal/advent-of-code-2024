<?php
$lines = file("input/input14.txt");
$h = 103;
$w = 101;

$inputs = [];
foreach ($lines as $line) {
  if (preg_match('/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/', $line, $matches)) {
    list(, $px, $py, $vx, $vy) = $matches;
    $inputs[] = [$px, $py, $vx, $vy];
  }
}

function safety($steps) {
  global $inputs, $h, $w;
  $q = [0, 0, 0, 0];
  foreach ($inputs as $input) {
    list($px, $py, $vx, $vy) = $input;
    $x = (($px + $vx * $steps) % $w + $w) % $w;
    $y = (($py + $vy * $steps) % $h + $h) % $h;
    if (2*$x+1 != $w && 2*$y+1 != $h) {
      $quad = 2 * (2*$x < $w ? 0 : 1) + (2*$y < $h ? 0 : 1);
      $q[$quad] += 1;
    }
  }
  return $q[0]*$q[1]*$q[2]*$q[3];
}

function printAt($steps) {
  global $inputs, $h, $w;
  $r = [];
  foreach ($inputs as $input) {
    list($px, $py, $vx, $vy) = $input;
    $x = (($px + $vx * $steps) % $w + $w) % $w;
    $y = (($py + $vy * $steps) % $h + $h) % $h;
    $r[$y*$w+$x] = 1;
  }
  for ($y = 0; $y < $h; $y++) {
    for ($x = 0; $x < $w; $x++) {
      echo " #"[$r[$y*$w+$x] ?? 0];
    }
    echo "\n";
  }
}

function entropy($steps) {
  global $inputs, $h, $w;
  $r = [];
  foreach ($inputs as $input) {
    list($px, $py, $vx, $vy) = $input;
    $x = (($px + $vx * $steps) % $w + $w) % $w;
    $y = (($py + $vy * $steps) % $h + $h) % $h;
    $d = intdiv($y, 10) * intdiv($w, 10) + intdiv($x, 10);
    $r[$d] = ($r[$d] ?? 0) + 1;
  }
  $t = 0.0;
  foreach ($r as $v) { $t += log10(1.0 + $v); }
  return $t;
}

printf("Part One: %d\n", safety(100));

$min_i = 0;
$min_score = 1000;
for ($i = 0; $i < $w * $h; $i++) {
  $s = entropy($i);
  if ($s < $min_score) {
    $min_score = $s;
    $min_i = $i;
  }
}

printAt($min_i);
printf("Part Two: %d\n", $min_i);

?>
