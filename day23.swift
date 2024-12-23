import Foundation

let content = try! String(contentsOfFile: "input/input23.txt")
let input_pairs = content.split(separator: "\n").map {
  let parts = $0.split(separator: "-").map(String.init)
  return (parts[0], parts[1])
}

func toIdx(_ s: String) -> Int {
  let y = s.map { $0.asciiValue! - 97 }
  return Int(y[0]) * 26 + Int(y[1])
}

let num_ascii = 26 * 26
var conn_by_ascii = Array(repeating: Array(repeating: false, count: num_ascii), count: num_ascii)
for (a, b) in input_pairs {
  conn_by_ascii[toIdx(a)][toIdx(b)] = true
  conn_by_ascii[toIdx(b)][toIdx(a)] = true
}

let nodes = Array(Set(input_pairs.flatMap { [ $0, $1 ] }))
let n = nodes.count
var conn = Array(repeating: Array(repeating: false, count: n), count: n)
for i in 0..<nodes.count {
  for j in i+1..<nodes.count {
    if conn_by_ascii[toIdx(nodes[i])][toIdx(nodes[j])] {
      conn[i][j] = true
      conn[j][i] = true
    }
  }
}

func extend(_ groups: [[Int]]) -> [[Int]] {
  var next_groups: [[Int]] = []
  for group in groups {
    let last = group[group.count-1] 
    for i in last+1..<n {
      if group.allSatisfy({ conn[$0][i] }) {
        next_groups.append(group + [i])
      }
    }
  }
  return next_groups
}

let singles = Array(0..<n).map{[$0]}
let pairs = extend(singles)
let triples = extend(pairs)
let part_one =  triples.filter { $0.contains { nodes[$0].starts(with: "t") } }
print(part_one.count)

var prevGroups = pairs
var groups = triples
while (!groups.isEmpty) {
  prevGroups = groups
  groups = extend(groups)
}
let part_two = prevGroups[0].map { nodes[$0] }
print(part_two.sorted().joined(separator: ","))