import os

fn conv(x int, y int) string { return '${x},${y}' }

fn main() {
  lines := os.read_lines("input/input08.txt")!
  mut locs := map[u8][][]int{}
  for r, line in lines {
    for c, v in line {
      if v != "."[0] {
        locs[v] << [r,c]
      }
    }
  }
  mut incl1 := map[string]bool{}
  mut incl2 := map[string]bool{}
  for _, loc in locs {
    for a in loc {
      ar := a[0]; ac := a[1]
      for b in loc {
        if a == b { continue } 
        br := b[0]; bc := b[1]
        dr := ar-br; dc := ac-bc
        incl1[conv(ar+dr, ac+dc)] = true
        incl1[conv(br-dr, bc-dc)] = true
        for i in -50..51 { incl2[conv(ar+dr*i,ac+dc*i)] = true }
      }
    }
  }
  mut part_one := 0
  mut part_two := 0
  for r := 0; r < 50; r++ {
    for c := 0; c < 50; c++ {
      if incl1[conv(r,c)] { part_one += 1 }
      if incl2[conv(r,c)] { part_two += 1 }
    }
  }
  println(part_one)
  println(part_two)
}
