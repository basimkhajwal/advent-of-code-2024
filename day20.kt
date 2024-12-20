import java.io.File

fun main() {
  val lines = File("input/input20.txt").readLines()
  val h = lines.size
  val w = lines[0].length
  val walls = Array(h) { y -> Array(w) { x -> lines[y][x] == '#' } }
  val start = lines.flatMapIndexed { y, row -> row.mapIndexedNotNull { x, c -> if (c == 'S') Pair(y, x) else null } }.first()
  val end = lines.flatMapIndexed { y, row -> row.mapIndexedNotNull { x, c -> if (c == 'E') Pair(y, x) else null } }.first()

  fun oneStep(y: Int, x: Int): List<Pair<Int,Int>> {
    return listOf(Pair(y-1,x), Pair(y+1,x), Pair(y,x-1), Pair(y,x+1))
  }

  fun nStep(y: Int, x: Int, n: Int): List<Pair<Pair<Int,Int>,Int>> {
    return (-n..n).flatMap { dy ->
     (-n..n).mapNotNull { dx ->
      val d = Math.abs(dy) + Math.abs(dx)
      if (d > 0 && d <= n) Pair(Pair(y+dy, x+dx), d) else null
     }
    }
  }

  fun valid(y: Int, x: Int): Boolean = y >= 0 && y < h && x >= 0 && x < w && !walls[y][x]

  fun distsFrom(from: Pair<Int,Int>): Array<Array<Int>> {
    var frontier = mutableListOf(from);
    val dists = Array(h) { y -> Array(w) { x -> -1 }}
    dists[from.first][from.second] = 0
    while (!frontier.isEmpty()) {
      val nextFrontier = mutableListOf<Pair<Int,Int>>();
      for ((y, x) in frontier) {
        for ((ny, nx) in oneStep(y, x)) {
          if (valid(ny, nx) && dists[ny][nx] == -1) {
            dists[ny][nx] = dists[y][x] + 1
            nextFrontier.add(Pair(ny, nx))
          }
        }
      }
      frontier = nextFrontier
    }
    return dists
  }

  val distsFromStart = distsFrom(start)
  val distsFromEnd = distsFrom(end)

  fun countCheats(maxStep: Int): Int {
    val normalDist = distsFromEnd[start.first][start.second]
    var savingCheats = 0
    for (y in 0..h-1) {
      for (x in 0..w-1) {
        if (!valid(y, x)) continue
        for ((k, d) in nStep(y, x, maxStep)) {
          val (ny, nx) = k
          if (!valid(ny, nx)) continue
          val cheatDist = distsFromStart[y][x] + d + distsFromEnd[ny][nx]
          if (cheatDist <= normalDist - 100) savingCheats += 1
        }
      }
    }
    return savingCheats
  }

  println(countCheats(2))
  println(countCheats(20))
}