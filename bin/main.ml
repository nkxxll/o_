open! Base

let _hello name =
  "<html>\n\t<body>\n\t<h1>Hello " ^ name ^ "</h1>\n\r\t</body>\n\r</html>"
;;

let elt_to_string elt = Fmt.str "%a" (Tyxml.Html.pp_elt ()) elt

let form =
  "<head>\n\
   <script src=\"https://unpkg.com/htmx.org@1.9.4\" \
   integrity=\"sha384-zUfuhFKKZCbHTY6aRR46gxiqszMk5tcHjsVFxnUo8VMus4kHGVdIYVbOYYNlKmHV\" \
   crossorigin=\"anonymous\"></script>\n\
  \  </head>\n\
  \  <form>\n\
  \  <div>\n\
  \    <label for=\"example\">Let's submit some text</label>\n\
  \    <input id=\"example\" type=\"text\" name=\"text\" />\n\
  \  </div>\n\
  \  <div>\n\
  \    <input type=\"submit\" value=\"Send\" hx-post=\"/echo\" hx-target=\"body\"/>\n\
  \  </div>\n\
   </form>"
;;

let tyxml_respond _ =
  let open Tyxml.Html in
  let response = h1 [ txt "Hello from Tyxml" ] in
  Dream.html @@ elt_to_string response
;;

let () =
  Args.get_args;
  Stdio.print_endline ("Web Server will be started on: " ^ Int.to_string !Args.port);
  Dream.run ~interface:"127.0.0.1" ~port:!Args.port
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun _ -> Dream.html form)
       ; Dream.get "/tyxml" tyxml_respond
       ; Dream.post "/echo" (fun request ->
           let open Lwt.Syntax in
           (* getting the body with lwt async lib
              the body is a promise with the star we can await the real body *)
           let* body = Dream.body request in
           (* now we split the body which is a form data so something like: text=value*)
           let values = Str.split (Str.regexp "=") body in
           let value = List.nth values 1 in
           match value with
           | Some string -> Dream.html ("<h1>" ^ string ^ "</h1>")
           | None -> Dream.html "There was no value provided")
       ]
;;
