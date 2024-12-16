io.input("input/input15.txt")

local grid_lines = {}
while true do
  local line = io.read()
  if line == "" then break end
  table.insert(grid_lines, line)
end

moves = ""
while true do
  local line = io.read()
  if line == nil then break end
  moves = moves .. line
end

function part_one_parse()
  local start_y = 0
  local start_x = 0
  local grid = {}
  local blocks = {}

  for y, line in ipairs(grid_lines) do
    grid[y] = {}
    for x=1,#line do
      c = string.sub(line, x, x)
      if c == '#' then
        grid[y][x] = 1
      elseif c == 'O' then
        table.insert(blocks, { y, x })
      elseif c == '@' then
        start_y = y
        start_x = x
      end
    end
  end

  return grid, blocks, start_y, start_x
end

function part_one_collides(block, check)
  return block[1] == check[1] and block[2] == check[2]
end

function part_one_checks(block, dy, dx)
  return { { block[1]+dy, block[2]+dx } }
end

function part_two_parse()
  local start_y = 0
  local start_x = 0
  local grid = {}
  local blocks = {}

  for y, line in ipairs(grid_lines) do
    grid[y] = {}
    for x=1,#line do
      local c = string.sub(line, x, x)
      local x0 = 2*x-1
      local x1 = 2*x
      if c == '#' then
        grid[y][x0] = 1
        grid[y][x1] = 1
      elseif c == 'O' then
        table.insert(blocks, { y, x0 })
      elseif c == '@' then
        start_y = y
        start_x = x0
      end
    end
  end

  return grid, blocks, start_y, start_x
end

function part_two_collides(block, check)
  return block[1] == check[1] and (block[2] == check[2] or block[2]+1 == check[2])
end

function part_two_checks(block, dy, dx)
  if dy == 1 or dy == -1 then
    return { { block[1]+dy, block[2] }, { block[1]+dy, block[2]+1 } }
  end
  if dx == 1 then
    return { { block[1], block[2]+2 } }
  end
  return { { block[1], block[2]-1 } }
end

function solve(parse, collides, get_checks)
  local grid, blocks, y, x = parse()

  for i=1,#moves do
    local m = string.find("^v><", string.sub(moves, i, i))
    local dy = ({ -1, 1, 0, 0 })[m]
    local dx = ({ 0, 0, 1, -1 })[m]

    local blocks_to_move = {}
    local can_move = true
    local checks = {{ y + dy, x + dx }}

    while #checks > 0 do
      for _, check in ipairs(checks) do
        if grid[check[1]][check[2]] then
          can_move = false
        end
      end
      if not can_move then break end

      local next_checks = {}
      for block_idx, block in ipairs(blocks) do
        local is_moved = false
        for _, check in ipairs(checks) do
          if collides(block, check) then
            is_moved = true
            break
          end
        end
        if is_moved then
          blocks_to_move[block_idx] = block
          for _, next_check in ipairs(get_checks(block, dy, dx)) do
            table.insert(next_checks, next_check)
          end
        end
      end
      checks = next_checks
    end

    if can_move then
      for block_idx, block in pairs(blocks_to_move) do
        blocks[block_idx] = { block[1]+dy, block[2]+dx }
      end
      y = y + dy
      x = x + dx
    end
  end

  local total = 0
  for _, block in ipairs(blocks) do
    total = total + (block[1] - 1) * 100 + block[2] - 1
  end
  return total
end

print(solve(part_one_parse, part_one_collides, part_one_checks))
print(solve(part_two_parse, part_two_collides, part_two_checks))
