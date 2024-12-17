use std::{collections::{BinaryHeap, HashMap, HashSet}, fs};

#[derive(Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
enum Dir { N, E, S, W }

const DIRS: [Dir; 4] = [ Dir::N, Dir::E, Dir::S, Dir::W ];

fn next(d: Dir) -> Dir {
  use Dir::*;
  match d { N => E, E => S, S => W, W => N }
}

fn prev(d: Dir) -> Dir {
  use Dir::*;
  match d { N => W, E => N, S => E, W => S }
}

fn diff(d: Dir) -> (i32, i32) {
  match d {
    Dir::N => (-1, 0),
    Dir::S => (1, 0),
    Dir::E => (0, 1),
    Dir::W => (0, -1)
  }
}

fn inv(d: Dir) -> Dir {
  use Dir::*;
  match d { N => S, E => W, S => N, W => E }
}

fn apply(y: i32, x: i32, d: Dir) -> (i32, i32) {
  let (dy, dx) = diff(d);
  (y + dy, x + dx)
}

#[derive(PartialEq, Eq, Hash, PartialOrd, Ord, Clone, Copy, Debug)]
struct Loc {
  y: i32,
  x: i32,
  d: Dir
}

fn shortest_dists(start: Loc, graph: &HashMap<Loc, Vec<(Loc, i32)>>) -> HashMap<Loc, i32> {
  let mut dists: HashMap<Loc, i32> = HashMap::new();
  let mut search = BinaryHeap::new();
  search.push((0, start));

  while let Some((neg_dist, loc)) = search.pop() {
    let dist = - neg_dist; 
    // println!("{:?}: {}", loc, dist);
    if dists.contains_key(&loc) { continue; }
    dists.insert(loc, dist);
    if let Some(edges) = graph.get(&loc) {
      // println!("{:?}", edges);
      for (neighbour, weight) in edges {
        search.push((-(dist+weight), *neighbour));
      }
    }
  }
  return dists;
}

fn main() {
  let data = fs::read_to_string("input/input16.txt").unwrap();
  let mut grid : Vec<Vec<bool>> = Vec::new();
  let mut start = (0, 0);
  let mut target = (0, 0);
  for (y, line) in data.lines().enumerate() {
    let mut row = Vec::new();
    for (x, c) in line.chars().enumerate() {
      row.push(c=='#');
      if c == 'S' { start = (y as i32, x as i32); }
      if c == 'E' { target = (y as i32, x as i32); }
    }
    grid.push(row);
  }

  let mut graph: HashMap<Loc, Vec<(Loc, i32)>> = HashMap::new();
  for (y, row) in grid.iter().enumerate() {
    for (x, blocked) in row.iter().enumerate() {
      for d in DIRS {
        let loc = Loc { y: y as i32, x: x as i32, d };
        let mut edges = Vec::new();
        let (ny, nx) = apply(y as i32, x as i32, d);
        if !blocked {
          if !grid[ny as usize][nx as usize] {
            edges.push((Loc { y: ny, x : nx, d }, 1));
          }
          edges.push((Loc { y: y as i32, x: x as i32, d: next(d) }, 1000));
          edges.push((Loc { y: y as i32, x: x as i32, d: prev(d) }, 1000));
        }
        graph.insert(loc, edges);
      }
    }
  }

  let start = Loc { y: start.0, x: start.1, d: Dir::E };
  let targets = DIRS.map(|d| Loc { y: target.0, x: target.1, d });

  let dists_from_start = shortest_dists(start, &graph);
  let min_target_dist = targets.iter().filter_map(|t| dists_from_start.get(&t)).min().unwrap();
  println!("Part one: {}", min_target_dist);

  let mut on_shortest_path = HashSet::new();
  for t in targets {
    let dists_from_t = shortest_dists(t, &graph);
    for (loc, dist_from_start) in dists_from_start.iter() {
      let inv_loc = Loc { y: loc.y, x: loc.x, d: inv(loc.d) };
      if let Some(dist_from_t) = dists_from_t.get(&inv_loc) {
        if dist_from_start + dist_from_t == *min_target_dist {
          on_shortest_path.insert((loc.y, loc.x));
        }
      }
    }
  }
  println!("Part two: {}", on_shortest_path.len());
}