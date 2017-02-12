open Cohttp_lwt

open Omnibus
open Holy_shit_endpoints


let stub _ =
  { status = `OK; headers = (Cohttp.Header.init ());
  body = Cohttp_lwt_body.of_string "Not implemented yet" }

let routes:route list =
  [
    ("/about", "GET", stub);
    ("/quotes/", "GET", stub);
    ("/quotes/post", "POST", stub);
    ("/quotes/<timestamp>", "DELETE", stub);
    Omnibus_rest.route_of_endpoint single_quote;
  ]

let _ = run_omnibus routes 8080
