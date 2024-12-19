s = read("input/input19.txt", String)
lines = collect(filter(!isempty, collect(eachsplit(s, "\n"))))
xs = collect(eachsplit(lines[1], ", "))
part_one = 0
part_two = 0
for l = lines[2:end]
  n = length(l)
  ways = zeros(Int, n+1)
  ways[n+1] = 1
  for i = n:-1:1
    for x = xs 
      m = length(x)
      if i+m-1 <= n && x == l[i:i+m-1] 
        ways[i] += ways[i+m]
      end
    end
  end
  if ways[1] > 0
    global part_one += 1
  end
  global part_two += ways[1]
end

println(part_one)
println(part_two)