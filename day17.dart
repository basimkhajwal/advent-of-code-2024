import 'dart:io';

List<int> simulate(int a, int b, int c, List<int> ins) {
  List<int> res = [];
  var ip = 0;
  while (ip+1 < ins.length) {
    final literal = ins[ip+1];
    final combo = [0, 1, 2, 3, a, b, c, 7][literal];
    switch (ins[ip]) {
      case 0: a >>= combo; ip += 2;
      case 1: b ^= literal; ip += 2;
      case 2: b = (combo % 8); ip += 2;
      case 3:
        if (a != 0) { ip = literal; }
        else { ip += 2; }
      case 4: b ^= c; ip += 2;
      case 5: res.add(b % 8); ip += 2;
      case 6: b = a >> combo; ip += 2;
      case 7: c = a >> combo; ip += 2;
    }
  }
  return res;
}

// Hard code input statement and reverse search

int nextOutput(int a) {
  final b0 = (a & 7) ^ 1;
  return (b0 ^ (a >> b0) ^ 4) % 8;
}

int buildProgram(int currA, List<int> ins, int idx) {
  if (idx < 0) return currA;
  for (int i = 0; i < 8; i++) {
    int nextA = (currA << 3) + i;
    if (nextOutput(nextA) == ins[idx]) {
      int finalA = buildProgram(nextA, ins, idx-1);
      if (finalA >= 0) return finalA;
    }
  }
  return -1;
}

void main() async {
  final input = await File("input/input17.txt").readAsString();
  final [ ...regs, _, program, _ ] = input.split("\n");
  final [a, b, c] = regs.map((e) => int.parse(e.split(": ")[1])).toList();
  final ins = program.split(": ")[1].split(",").map(int.parse).toList();
  final partOne = simulate(a, b, c, ins);
  print("Part one: " + partOne.join(","));
  final partTwo = buildProgram(0, ins, ins.length-1);
  print("Part two: $partTwo");
}