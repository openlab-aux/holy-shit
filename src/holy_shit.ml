open Cohttp_lwt
open Cohttp

open Mug
open Holy_shit_endpoints

type quote = Quote of Ptime.t * string * string

let stub _ =
  { status = `OK; headers = (Header.init ());
  body = Cohttp_lwt_body.of_string "Not implemented yet" }

let routes:route list =
  [
    ("/about", "GET", stub);
    ("/quotes/", "GET", stub);
    ("/quotes/post", "POST", stub);
    ("/quotes/<timestamp>", "DELETE", stub);
    Mug_rest.route_of_endpoint single_quote;
  ]

let _ = run_mug routes 8080
