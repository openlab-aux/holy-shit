open Mug
open Mug_rest

let single_quote = {
  route    = "/quotes/<timestamp>";
  meth     = "GET";
  from_req = (fun req -> StringMap.find "timestamp" req.vars);
  f        = (fun x -> Some x);
  to_resp  = (fun (Some x) -> { status = `OK; headers = Cohttp.Header.init (); body = Cohttp_lwt_body.of_string x});
}
