open Mug
open Cohttp_lwt
open Cohttp

type quote = Quote of Ptime.t * string * string

let stub _ =
  { status = `OK; headers = (Header.init ());
  body = Cohttp_lwt_body.of_string "Not implemented yet" }

let timestamp e = {
  status  = `OK;
  headers = Header.init ();
  body    = Cohttp_lwt_body.of_string
    ("timestamp: " ^ (StringMap.find "timestamp" e.vars))
  }

let routes:route list =
  [ ("/about", "GET", stub)
  ; ("/quotes/", "GET", stub)
  ; ("/quotes/post", "POST", stub)
  ; ("/quotes/<timestamp>", "GET", timestamp)
  ; ("/quotes/<timestamp>", "DELETE", stub)
  ]

let _ = run_mug routes 8080
