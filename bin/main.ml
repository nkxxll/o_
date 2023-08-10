let hello name = "<html>\n\t<body>\n\t<h1>Hello " ^ name ^ "</h1>\n\r\t</body>\n\r</html>"

let () =
  Args.get_args;
  print_endline ("Web Server will be started on: " ^ Int.to_string !Args.port);
  Dream.run ~interface:"127.0.0.1" ~port:!Args.port
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun _ -> Dream.html (hello "buddy"))
       ; Dream.post "/echo" (fun request ->
           let open Lwt.Syntax in
           let* body = Dream.body request in
           Dream.respond ~headers:[ "Content-Type", "application/octet-stream" ] body)
       ]
;;
