let () = 
  Args.get_args;
  print_endline ("This is the port " ^ !Args.port)
