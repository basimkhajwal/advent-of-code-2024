package main

import "fmt"
import "os"
import "strings"
import "strconv"

func search(seen [][]bool, grid [][]int, i int, j int) int {
  if seen[i][j] { return 0 }
  seen[i][j] = true
  if grid[i][j] == 9 { return 1 }

  ans := 0
  for _, pair := range [4][2]int{ {i-1,j},{i+1,j},{i,j-1},{i,j+1} } {
    r, c := pair[0], pair[1]
    if r >= 0 && r < len(grid) && c >= 0 && c < len(grid[r]) && grid[r][c] == grid[i][j]+1 {
      ans += search(seen, grid, r, c)
    }
  }
  return ans
}

func main() {
  input, _ := os.ReadFile("input/input10.txt")
  lines := strings.Split(string(input), "\n")

  grid := [][]int{}
  for _, line := range lines {
    row := []int{}
    for _, c := range line {
      i, _ := strconv.Atoi(string(c))
      row = append(row, i)
    }
    grid = append(grid, row)
  }

  partOne := 0
  for i := 0; i < len(grid); i++ {
    for j := 0; j < len(grid[i]); j++ {
      if grid[i][j] == 0 {
        seen := make([][]bool, len(grid))
        for r, row := range grid {
          seen[r] = make([]bool, len(row))
        }
        partOne += search(seen, grid, i, j)
      }
    }
  }
  fmt.Println(partOne)

  pathCount := make([][]int, len(grid))
  for i, row := range grid {
    pathCount[i] = make([]int, len(row))
    for j, val := range row {
      if val == 9 { pathCount[i][j] = 1 }
    }
  }
  partTwo := 0
  for v := 8; v >= 0; v-- {
    for i := 0; i < len(grid); i++ {
      for j := 0; j < len(grid[i]); j++ {
        if grid[i][j] == v {
          for _, pair := range [4][2]int{ {i-1,j},{i+1,j},{i,j-1},{i,j+1} } {
            r, c := pair[0], pair[1]
            if r >= 0 && r < len(grid) && c >= 0 && c < len(grid[r]) && grid[r][c] == grid[i][j]+1 {
              pathCount[i][j] += pathCount[r][c]
            }
          }
          if v == 0 { partTwo += pathCount[i][j] }
        }
      }
    }
  }
  fmt.Println(partTwo)
}
