let executable (query, variables, of_json) =
  variables (fun vars ->
    let response = `Assoc ["data", `Assoc [
      "non_nullable_int", `Int 42
    ]] in
    of_json response
  )

let suite : (string * [>`Quick] * (unit -> unit)) list = [
  ("it works", `Quick, fun () ->
    let exec_query = executable [%graphql {|
        query Foo($int: Int) {
          non_nullable_int
        }
    |}] in
    let expected = object method non_nullable_int = 42 end in
    let query_type = Alcotest.testable (fun formatter t -> Format.pp_print_text formatter (string_of_int t#non_nullable_int)) (fun a b -> a#non_nullable_int = b#non_nullable_int) in
    Alcotest.(check query_type) "foo" expected (exec_query ~int:1 ());
  );
]