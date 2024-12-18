import java.io.*;
import java.util.*;

class Day18 {

  record Pos(Integer y, Integer x) {}

  private static final int SIZE = 71;

  private static int movesToEnd(ArrayList<Pos> blocks, int blocksToPlace) {
    boolean[][] grid = new boolean[SIZE][SIZE];
    for (int i = 0; i < blocksToPlace && i < blocks.size(); i++) {
      grid[blocks.get(i).y][blocks.get(i).x] = true;
    }

    Pos start = new Pos(0, 0);
    Pos target = new Pos(SIZE-1, SIZE-1);
    boolean[][] seen = new boolean[SIZE][SIZE];
    var search = new ArrayList<Pos>();
    seen[start.y][start.x] = true;
    search.add(start);

    int[] DY = { -1, 1, 0, 0 };
    int[] DX = { 0, 0, -1, 1 };
    int dist = 0;
    while (!search.contains(target) && !search.isEmpty()) {
      var nextSearch = new ArrayList<Pos>();
      for (Pos pos : search) {
        for (int d = 0; d < 4; d++) {
          Pos n = new Pos(pos.y + DY[d], pos.x + DX[d]);
          if (n.y >= 0 && n.y < SIZE && n.x >= 0 && n.x < SIZE && !grid[n.y][n.x] && !seen[n.y][n.x]) {
            seen[n.y][n.x] = true;
            nextSearch.add(n);
          }
        }
      }
      search = nextSearch;
      dist++;
    }

    return search.isEmpty() ? -1 : dist;
  }

  public static void main(String[] args) throws Exception {
    Scanner scanner = new Scanner(new File("input/input18.txt"));
    var blocks = new ArrayList<Pos>();
    while (scanner.hasNextLine()) {
      String[] coords = scanner.nextLine().split(",");
      Pos pos = new Pos(Integer.valueOf(coords[1]), Integer.valueOf(coords[0]));
      blocks.add(pos);
    }
    
    System.out.printf("Part one: %d\n", movesToEnd(blocks, 1024));

    int l = 1024;
    int u = blocks.size()-1;
    while ((u - l) > 1) {
      int m = (l + u) / 2;
      if (movesToEnd(blocks, m) < 0) u = m;
      else l = m;
    }
    System.out.printf("Part two: %d,%d\n", blocks.get(l).x, blocks.get(l).y);
  }
}