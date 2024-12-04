#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const char* input_file = "./input/input04.txt";

typedef struct {
  int width;
  int height;
  char** data;
} grid;

grid read_grid(const char* file_name) {
  grid grid;
  FILE* file;

  file = fopen(file_name, "r");
  if (file == NULL) {
    printf("Error reading file\n");
    exit(1);
  }

  char line[1000];
  grid.height = 0;
  grid.data = (char**) malloc(1000 * sizeof(char*));
  while (fgets(line, sizeof(line), file) != NULL) {
    grid.width = strlen(line);
    grid.data[grid.height] = (char*) malloc((grid.width + 1) * sizeof(char*));
    strcpy(grid.data[grid.height++], line);
  }

  return grid;
}

const int D = 8;
int dirs[8][2] = { { -1, 0 }, { 1, 0}, { 0, -1}, { 0, 1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1} };

int T = 4;
const char* target = "XMAS";

int P = 4;
const char* kinds[] = { "AMMSS", "ASMMS", "ASSMM", "AMSSM" };

int main() {

  grid grid = read_grid(input_file);
  int part_one = 0;
  int part_two = 0;

  for (int i = 0; i < grid.height; i++) {
    for (int j = 0; j < grid.width; j++) {
      for (int d = 0; d < D; d++) {
        int dr = dirs[d][0], dc = dirs[d][1];
        int r = i; int c = j;
        int valid = 1;
        for (int k = 0; k < T; k++) {
          if (r < 0 || r >= grid.height || j < 0 || j >= grid.width || grid.data[r][c] != target[k]) {
            valid = 0;
            break;
          }
          r += dr;
          c += dc;
        }
        if (valid) part_one++;
      }
    }
  }

  for (int i = 1; i+1 < grid.height; i++) {
    for (int j = 1; j+1 < grid.width; j++) {
      char v[6];
      v[0] = grid.data[i][j];
      v[1] = grid.data[i-1][j-1];
      v[2] = grid.data[i-1][j+1];
      v[3] = grid.data[i+1][j+1];
      v[4] = grid.data[i+1][j-1];
      v[5]=0;

      int valid = 0;
      for (int k = 0; k < P; k++) {
        if (strcmp(v, kinds[k]) == 0) {
          valid = 1;
          break;
        }
      }
      if (valid) part_two++;
    }
  }

  printf("Part 1: %d\n", part_one);
  printf("Part 2: %d\n", part_two);

  return 0;
}
