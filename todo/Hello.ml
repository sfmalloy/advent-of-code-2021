let do_add a b = a + b;;

let () = 
    Printf.printf "Hello from OCaml!\n";
    Printf.printf "a + b = %d\n" (do_add 1 2);
