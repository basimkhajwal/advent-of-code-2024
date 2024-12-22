def mix_and_prune(x, t)
  (x ^ t) % 16777216
end

def next_seed(x)
  x = mix_and_prune(x, x * 64)
  x = mix_and_prune(x, x // 32)
  mix_and_prune(x, x * 2048)
end

n = 2000
lines = File.read_lines("input/input22.txt")
change_value = {} of Array(Int64) => Int64

part_one = lines.sum{|line| 
  seeds = [line.to_i64]
  n.times{|i| seeds << next_seed(seeds[i]) }
  line_values = {} of Array(Int64) => Int64
  (n-3).times{|i|
    cs = 4.times.map{|j|(seeds[i+j+1]%10)-(seeds[i+j]%10)}.to_a
    line_values[cs] = seeds[i+4] % 10 if !line_values.has_key?(cs)
  }
  line_values.each{|k,v| change_value[k] = change_value.fetch(k, 0_i64) + v }
  seeds[n]
}

printf "Part one: %d\n", part_one
printf "Part two: %d\n", change_value.values.max