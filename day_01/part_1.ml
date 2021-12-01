open Core

let count_increases l =
  let rec aux acc previous list =
    match list with
    | [] -> acc
    | h :: t -> if h > previous then aux (acc + 1) h t else aux acc h t
  in
  match l with
  | [] -> 0
  | h :: t -> aux 0 h t
;;

let () =
  In_channel.read_lines "./input"
  |> List.map ~f:Int.of_string
  |> count_increases
  |> Printf.printf "%d\n"
;;
