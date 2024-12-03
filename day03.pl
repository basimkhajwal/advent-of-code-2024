use strict;
use warnings;

my $input = do { local $/; <STDIN> };

my $part_one = 0;
while ($input =~ /mul\((\d+),(\d+)\)/g) { $part_one += $1 * $2; }

my $part_two = 0;
my $enabled = 1;
while ($input =~ /mul\((\d+),(\d+)\)|do\(\)|don't\(\)/g) {
  my $a = $1, $b = $2;
  if ($& =~ /^mul/ && $enabled) { $part_two += $a * $b; } 
  elsif ($& =~ /^don/) { $enabled = 0; }
  elsif ($& =~ /^do/) { $enabled = 1; }
}


printf("%d %d\n", $part_one, $part_two);
