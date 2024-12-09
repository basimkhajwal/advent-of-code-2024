def check_sum(nums); nums.each_with_index.sum{|v,i| v<0 ? 0 : v*i}; end

def part_one(nums)
  l = 0
  r = nums.size-1
  while l <= r do
    if nums[l] >= 0 then l += 1
    elsif nums[r] < 0 then r -= 1
    else
      nums[l], nums[r] = nums[r], -1
      l += 1; r -= 1
    end
  end
  check_sum(nums)
end

def part_two(nums)
  r = nums.size-1
  while r >= 0 do
    if nums[r] < 0 then r -= 1
    else
      r0 = r
      r0 -= 1 while nums[r0] == nums[r]
      r0 += 1
      k = r + 1 - r0
      l0 = l1 = 0
      while l1 <= r0 && l1 - l0 < k
        if nums[l0] >= 0 then l0 = l1 = (l0 + 1)
        elsif nums[l1] >= 0 then l0 = l1 = (l1 + 1)
        else l1 += 1 end
      end
      if l1 <= r0 then
        k.times { |i|
          nums[l0+i] = nums[r0+i]
          nums[r0+i] = -1
        }
      end
      r = r0 - 1
    end
  end
  check_sum(nums)
end

input = File.read("input/input09.txt").chars.map(&:to_i)
nums = input.each_slice(2).each_with_index.flat_map{|(a,b),i|[i]*a+[-1]*b}

puts part_one(nums.dup)
puts part_two(nums.dup)
