open Printf

let bin_to_hex h =
  match h with
  | '0' -> [0;0;0;0]
  | '1' -> [0;0;0;1]
  | '2' -> [0;0;1;0]
  | '3' -> [0;0;1;1]
  | '4' -> [0;1;0;0]
  | '5' -> [0;1;0;1]
  | '6' -> [0;1;1;0]
  | '7' -> [0;1;1;1]
  | '8' -> [1;0;0;0]
  | '9' -> [1;0;0;1]
  | 'A' -> [1;0;1;0]
  | 'B' -> [1;0;1;1]
  | 'C' -> [1;1;0;0]
  | 'D' -> [1;1;0;1]
  | 'E' -> [1;1;1;0]
  | 'F' -> [1;1;1;1]
  | _   -> [];;

let get_input filename =
  let file = open_in filename in
  let hex = input_line file in 
    close_in file;
  let rec parse_file h = 
    match (String.length h) with
    | 0 -> []
    | _ -> bin_to_hex (String.get h 0) :: parse_file (String.sub h 1 ((String.length h) - 1)) in
  List.flatten (parse_file hex);;

(****************************************************************************)
(* Part 1 *)

let pow_2 n =
  let rec helper n p =
    match n with
    | 0 -> p
    | _ -> helper (n - 1) 2 * p in
  helper n 1;;

let decode bits length = 
  let rec combine b len pow2 total = 
    if len == length then
      total
    else
      combine (List.tl b) (len + 1) (pow2 / 2) (total + pow2 * (List.hd b)) in
  combine bits 0 (pow_2 (length - 1)) 0;;

let rec eat_numbers bits = 
  match bits with
  | 1::_::_::_::_::t -> eat_numbers t
  | 0::_::_::_::_::t -> t
  | _ -> bits;;

let rec chop_n bits n =
  match n with
  | 0 -> bits
  | _ -> chop_n (List.tl bits) (n - 1);;

let rec max_bit bits =
  match bits with
  | []   -> 0
  | 1::_ -> 1
  | _::t -> max_bit t;;

let version_sum bits =
  let rec helper bits sum =
    if (max_bit bits) == 1 then
      let version = decode bits 3 in
      let bits_no_version = chop_n bits 3 in
      let type_id = decode bits_no_version 3 in
      let param_bits = chop_n bits_no_version 3 in
      if type_id == 4 then
        helper (eat_numbers param_bits) (sum + version)
      else
        let length_type_id = List.hd param_bits in
        if length_type_id == 1 then
          helper (chop_n param_bits 12) (sum + version)
        else
          helper (chop_n param_bits 16) (sum + version)
    else
      sum in
  helper bits 0;;

(****************************************************************************)
(* Part 2 *)

type op =
  | Sum
  | Product
  | Minimum
  | Maximum
  | GreaterThan
  | LessThan
  | EqualTo

type len_type =
  | BitLength
  | SubPacketCount

type token =
  | Operation of {
      op_type : op;
      length_type : len_type;
      length : int;
      address : int
  }
  | Literal of { value : int; address : int }

type expr =
  | Add of { expression : expr list }
  | Multiply of { expression : expr list }
  | Min of { expression : expr list }
  | Max of { expression : expr list }
  | Greater of { expression : expr list }
  | Less of { expression : expr list }
  | Equal of { expression : expr list }
  | Number of { value : int; address : int }

exception LexError of string
exception ParseError of string

let num_to_op type_id =
  match type_id with
  | 0 -> Sum
  | 1 -> Product
  | 2 -> Minimum
  | 3 -> Maximum
  | 5 -> GreaterThan
  | 6 -> LessThan
  | 7 -> EqualTo
  | _ -> raise (LexError "Invalid operator")

let literal bits = 
  let rec combine bits =
    match bits with
    | 1::a::b::c::d::t -> List.append [a;b;c;d] (combine t)
    | 0::a::b::c::d::t -> [a;b;c;d]
    | _ -> [] in
  let num = combine bits in
  decode num (List.length num);;

let lex program =
  let rec helper bits ip =
    if (max_bit bits) == 1 then
      let no_version = chop_n bits 3 in
      let type_id = decode no_version 3 in
      let params = chop_n no_version 3 in
      if type_id == 4 then
        let trimmed = eat_numbers params in
        Literal {value = literal params; address = ip} :: helper trimmed (ip + 6 + (List.length params - List.length trimmed))
      else
        let length_id = List.hd params in
        if length_id == 1 then
          Operation {op_type = num_to_op type_id; length_type = SubPacketCount;
            length = decode (List.tl params) 11; address = ip} :: helper (chop_n params 12) (ip + 6 + 12)
        else
          Operation {op_type = num_to_op type_id; length_type = BitLength; 
            length = decode (List.tl params) 15; address = ip} :: helper (chop_n params 16) (ip + 6 + 16)
    else
      [] in
  helper program 0;;

let rec trim_n prog last =
  match prog with
  | [] -> []
  | h::t -> 
    match h with
    | Operation op -> if op.address == last then t else trim_n t last
    | Literal l -> if l.address == last then t else trim_n t last;;

let rec trim_b prog end_addr =
  match prog with
  | [] -> []
  | h::t ->
    match h with
    | Operation op -> if op.address == end_addr then t else trim_b t end_addr
    | Literal l -> if l.address == end_addr then t else trim_b t end_addr;;

let rec parse prog = 
  match prog with
  | [] -> []
  | h::t ->
    match h with
    | Literal l -> Number { value = l.value; address = l.address } :: parse t
    | Operation op -> 
      if op.length_type == BitLength then
        let expression_list = parse_b t (op.address + op.length) in
        let trimmed = trim_b t (op.address + op.length) in
        match op.op_type with
        | Sum -> Add { expression = expression_list } :: parse trimmed
        | Product -> Multiply { expression = expression_list } :: parse trimmed
        | Minimum -> Min { expression = expression_list } :: parse trimmed
        | Maximum -> Max { expression = expression_list } :: parse trimmed
        | GreaterThan -> Greater { expression = expression_list } :: parse trimmed
        | LessThan -> Less { expression = expression_list } :: parse trimmed
        | EqualTo -> Equal { expression = expression_list } :: parse trimmed
      else []
        (* let expression_list = parse_n t op.length in
        let trimmed = trim_n expression_list in
        match op.op_type with
        | Sum -> Add { expression = expression_list } :: parse trimmed
        | Product -> Multiply { expression = expression_list } :: parse trimmed
        | Minimum -> Min { expression = expression_list } :: parse trimmed
        | Maximum -> Max { expression = expression_list } :: parse trimmed
        | GreaterThan -> Greater { expression = expression_list } :: parse trimmed
        | LessThan -> Less { expression = expression_list } :: parse trimmed
        | EqualTo -> Equal { expression = expression_list } :: parse trimmed
and parse_n prog length =
  if length == 0 then
    []
  else
    parse (List.hd prog) :: parse_n (List.tl prog) (length - 1) *)
and parse_b prog last = 
  match prog with
  | [] -> []
  | h::t ->
    match h with
    | Operation op -> if op.address == last then parse (h :: []) else parse h :: parse_b t last
    | Literal l -> if l.address == last then parse;;

let () =
  let bits = get_input "inputs/test.in" in
  printf "%d\n" (List.length (bits));;
