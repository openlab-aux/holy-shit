open Omnibus
open Omnibus_rest
open Holy_shit_types


(* single quote endpoint *)

let single_quote_f = function
  | Some x -> Some (Quote (Ptime.min, x, "test quote"))
  | None -> None

let single_quote : (string option, quote option) endpoint  = {
  route    = "/quotes/<timestamp>";
  meth     = "GET";
  from_req = (fun req -> get_var "timestamp" req.vars);
  f        = single_quote_f;
  to_resp  = (fun (Some (Quote (_, x, _))) -> { status = `OK; headers = Cohttp.Header.init (); body = Cohttp_lwt_body.of_string x});
}
