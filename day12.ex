defmodule Solution do

  def get(grid, r, c), do: Enum.at(Enum.at(grid, r), c)

  def neighbours(r, c), do: [ { r-1, c }, { r+1, c }, { r, c-1 }, { r, c+1 } ]

  def fill(grid, v, r, c) do
    n_r = length(grid)
    n_c = length(Enum.at(grid, 0))
    char = get(grid, r, c)
    v = MapSet.put(v, {r, c})
    Enum.reduce(neighbours(r, c), { 1, [], v }, fn { nr, nc }, { a, p, v } -> 
      cond do
        nr < 0 || nr >= n_r || nc < 0 || nc >= n_c || get(grid, nr, nc) != char ->
          { a, [ { r,c,nr,nc} | p ], v }
        MapSet.member?(v, {nr, nc}) ->
          { a, p, v }
        true ->
          { sa, sp, sv } = fill(grid, v, nr, nc)
          { a+sa, p++sp, sv }
      end
    end)
  end

  def solve(grid, count_f) do
    n_r = length(grid)
    n_c = length(Enum.at(grid, 0))
    v = MapSet.new()
    { t, _ } =
      Enum.reduce(0..(n_r-1), {0, v}, fn r, {t, v} -> 
        Enum.reduce(0..(n_c-1), {t, v}, fn c, {t, v} ->
          if MapSet.member?(v, { r, c }) do
            { t, v }
          else
            { a, p, sv } = fill(grid, v, r, c)
            { t + a * count_f.(p), sv }
          end
        end)
      end)
    t
  end

  def count_sides(boundaries) do
    Enum.count(boundaries, fn {r, c, nr, nc} ->
      check =
        cond do
          r == nr -> { r-1, c, r-1, nc }
          c == nc -> { r, c-1, nr, c-1 }
        end
      not Enum.member?(boundaries, check)
    end)
  end
end

{:ok, input} = File.read("input/input12.txt") 
grid = input |> String.trim |> String.split("\n") |> Enum.map(&String.graphemes/1)

part_one = Solution.solve(grid, fn p -> length(p) end) 
part_two = Solution.solve(grid, &Solution.count_sides/1)
IO.puts(part_one)
IO.puts(part_two)
