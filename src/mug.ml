open Lwt
open Cohttp_lwt

module StringMap = Map.Make(String)

type var_map = string StringMap.t

type handler = var_map -> Request.t -> Cohttp_lwt_body.t
  -> Cohttp.Code.status_code * Cohttp.Header.t * Cohttp_lwt_body.t

type route = string * string * handler

let route_path (p, _, _) = p
let route_meth (_, m, _) = m
let route_handler (_, _, h) = h

let split_path path = Re_str.split (Re_str.regexp "/") path

let is_var str = if String.length str >= 2
  then String.get str 0 == '<' && String.get str (String.length str - 1) = '>'
  else false

(* assumes is_var str == true *)
let var_name str = String.sub str 1 (String.length str - 2)

let combine_match_result (match1, map1) (match2, map2) =
  (match1 && match2, StringMap.union (fun _ oldv newv -> (Some newv)) map1 map2)

let rec match_route route path =
  if List.length route > List.length path
  then (false, StringMap.empty)
  else if List.length route == 0
    then (List.length path == 0, StringMap.empty)
    else let routeh = List.hd route in
         let pathh  = List.hd path in
         if is_var routeh
         then combine_match_result
          (true, (StringMap.singleton (var_name routeh) pathh))
          (match_route (List.tl route) (List.tl path))
         else combine_match_result
          (String.equal routeh pathh, StringMap.empty)
          (match_route (List.tl route) (List.tl path))

let rec router routes _conn req body =
  if List.length routes == 0
  then Cohttp_lwt_unix.Server.respond_string ~status:`Not_found ~body:"No handler available" ()
  else let route'           = routes |> List.hd |> route_path in
       let route            = split_path route' in
       let req_meth         = req |> Request.meth |> Cohttp.Code.string_of_method in
       let rt_meth          = routes |> List.hd |> route_meth in
       let handler          = routes |> List.hd |> route_handler in
       let uri              = req |> Request.uri |> Uri.to_string
                                  |> Uri.pct_decode |> split_path
                                  |> List.filter (fun str -> String.equal str "" |> not)
                                  |> List.tl in
       let (rt_match, vars) = match_route route uri in
       if String.equal rt_meth req_meth && rt_match
       then let (status, headers, body) = handler vars req body in
            Cohttp_lwt_unix.Server.respond ~headers ~status ~body ()
       else router (List.tl routes) _conn req body

let server routes = Cohttp_lwt_unix.Server.make ~callback:(router routes) ()

let run_mug routes port =
  ignore (Lwt_main.run (Cohttp_lwt_unix.Server.create ~mode:(`TCP (`Port port)) (server routes)))
