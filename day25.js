const fs = require("fs");
const input = fs.readFileSync("input/input25.txt").toString().split("\n");
const n = input.length / 8;
const keys = [];
const locks = [];

for (let i = 0; i < n; i++) {
  const heights = [];
  for (let c = 0; c < 5; c++) {
    let height = 0;
    for (let r = 0; r < 5; r++) {
      if (input[i * 8 + 1 + r][c] === '#') height++;
    }
    heights.push(height);
  }
  if (input[i * 8][0] === '#') locks.push(heights);
  else keys.push(heights);
}

let partOne = 0;
for (const key of keys) {
  for (const lock of locks) {
    let fits = true;
    for (let i = 0; i < 5; i++) {
      fits = fits && key[i]+lock[i]<=5;
    }
    if (fits) partOne++;
  }
}
console.log(partOne);
