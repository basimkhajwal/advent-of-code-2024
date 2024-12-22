open Core

(* Map from each pair (c1,c2) to possible move sequences that start at c1 and
   end with pushing c2.  *)
let make_possible_moves keypad =
  let chars = List.concat_map keypad ~f:String.to_list in
  let char_to_pos = 
    List.foldi keypad ~init:Char.Map.empty ~f:(fun i acc row ->
      String.foldi row ~init:acc ~f:(fun j acc c -> Map.set acc ~key:c ~data:(i, j))
    )
  in
  let invalid_pos = Map.find_exn char_to_pos ' ' in
  List.cartesian_product chars chars
  |> List.concat_map ~f:(fun (c1, c2) ->
    let (i1, j1) = Map.find_exn char_to_pos c1 in
    let (i2, j2) = Map.find_exn char_to_pos c2 in
    let m n c = String.make (max n 0) c in
    let vert = m (i2 - i1) 'v' ^ m (i1 - i2) '^' in
    let horz = m (j2 - j1) '>' ^ m (j1 - j2) '<' in
    let key = String.of_char_list [ c1; c2 ] in
    (* a) (r1,c1) -> (r2,c1) -> (r2,c2) *)
    let a = 
      if [%equal: (int * int)] invalid_pos (i2, j1) then []
      else [ key, vert ^ horz ^ "A" ]
    in
    (* b) (r1,c1) -> (r1,c2) -> (r2,c2) *)
    let b = 
      if [%equal: (int * int)] invalid_pos (i1, j2) then []
      else [ key, horz ^ vert ^ "A" ]
    in
    a @ b
  ) 
  |> String.Map.of_alist_multi

let cost_of_keypresses ~parent_costs keys =
  let chars = String.to_list keys in
  let without_last = List.drop_last_exn chars in
  List.zip_exn ('A' :: without_last) chars
  |> List.sum (module Int) ~f:(fun (c1, c2) -> Map.find_exn parent_costs (String.of_char_list [c1; c2]))

let get_next_costs ~possible_moves parent_costs =
  Map.map possible_moves ~f:(fun moves ->
    List.map moves ~f:(cost_of_keypresses ~parent_costs)
    |> List.min_elt ~compare
    |> Option.value_exn
  )

let rec apply_n_times ~f ~n x = if n <= 0 then x else apply_n_times ~f ~n:(n-1) (f x)

let numpad = make_possible_moves [ "789"; "456"; "123"; " 0A" ] ;;

let dirpad = make_possible_moves [ " ^A"; "<v>" ]  ;;

let get_move_costs ~num_dirpads =
  let init_costs = Map.map dirpad ~f:(Fn.const 1) in
  let last_costs = apply_n_times ~n:num_dirpads ~f:(get_next_costs ~possible_moves:dirpad) init_costs in
  get_next_costs ~possible_moves:numpad last_costs

let solve ~num_dirpads inputs = 
  let parent_costs = get_move_costs ~num_dirpads in
  List.sum (module Int) inputs ~f:(fun input ->
    let num = Int.of_string (String.chop_suffix_exn input ~suffix:"A") in
    num * cost_of_keypresses ~parent_costs input
  )

let () = 
  let input = In_channel.with_file "input/input21.txt" ~f:In_channel.input_lines in
  printf "Part one: %d\n" (solve ~num_dirpads:2 input);
  printf "Part two: %d\n" (solve ~num_dirpads:25 input);