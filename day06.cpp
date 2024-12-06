#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <set>
using namespace std;

int UP = 0;
int RIGHT = 1;
int DOWN = 2;
int LEFT = 3;

int DR[] = { -1, 0, 1, 0 };
int DC[] = { 0, 1, 0, -1 };

int R, C;
vector<vector<bool>> grid;
int guard_r, guard_c;

int simulate() {
  set<pair<int,int>> pos;
  set<tuple<int,int,int>> pos_dir;
  int dir = 0;
  int r = guard_r;
  int c = guard_c;
  while (true) {
    if (pos_dir.count({ r, c, dir }) > 0) return -1;
    pos_dir.insert({r,c,dir});
    pos.insert({ r, c });
    int dr = r + DR[dir];
    int dc = c + DC[dir];
    if (! (dr >= 0 && dr < R && dc >= 0 && dc < C)) break;
    if (grid[dr][dc]) { dir = (dir + 1) % 4; }
    else { r = dr; c = dc; }
  }
  return pos.size();
}

int main() {

  ifstream file("input/input06.txt");
  if (!file) return 1;

  string line;
  while (getline(file, line)) {
    vector<bool> grid_line;
    for (int j = 0; j < line.size(); j++) {
      grid_line.push_back(line[j] == '#');
      if (line[j] == '^') {
        guard_r = grid.size();
        guard_c = j;
      }
    }
    grid.push_back(grid_line);
  }
  file.close();
  R = grid.size();
  C = grid[0].size();

  int part_one = simulate();
  int part_two = 0;
  for (int r = 0; r < R; r++) {
    for (int c = 0; c < C; c++) {
      if (r == guard_r && c == guard_c) continue;
      if (grid[r][c]) continue;

      grid[r][c] = true;
      if (simulate() == -1) part_two++;
      grid[r][c] = false;
    }
  }

  cout << part_one << " " << part_two << endl;

  return 0;
}
