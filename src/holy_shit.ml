open Mug
open Cohttp_lwt
open Cohttp

type quote = Quote of Ptime.t * string * string

let stub _ _ _ = (`OK, (Header.init ()), Cohttp_lwt_body.of_string "Not implemented yet")

let routes:route list =
  [ ("/about", "GET", stub)
  ; ("/quotes/", "GET", stub)
  ; ("/quotes/post", "POST", stub)
  ; ("/quotes/<timestamp>", "GET", stub)
  ; ("/quotes/<timestamp>", "DELETE", stub)
  ]

let _ = run_mug routes 8080
