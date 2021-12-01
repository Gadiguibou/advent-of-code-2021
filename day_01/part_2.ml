open Core

let count_increases l =
  let rec aux acc (first, second, third) list =
    match list with
    | [] -> acc
    | h :: t ->
      if second + third + h > first + second + third
      then aux (acc + 1) (second, third, h) t
      else aux acc (second, third, h) t
  in
  match l with
  | fst :: snd :: trd :: tail -> aux 0 (fst, snd, trd) tail
  | _ -> 0
;;

let () =
  In_channel.read_lines "./input"
  |> List.map ~f:Int.of_string
  |> count_increases
  |> Printf.printf "%d\n"
;;
