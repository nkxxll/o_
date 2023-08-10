let port = ref 4321
let usage = "o_htmx_caml -p <port>\ndefault is 4321"

let speclist =
  [ ("-p", Arg.Set_int port, "Port for the htmx webserver to run on") ]

let anon_fun anonymous_arg = print_endline ("arg: " ^ anonymous_arg ^ " is not allowed see usage with -h/--help")

let get_args = Arg.parse speclist anon_fun usage
