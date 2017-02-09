open Mug

type ('a, 'b) endpoint = {
 route     : string;
 meth      : string;
 from_req  : (request -> 'a);
 f         : ('a -> 'b);
 to_resp   : ('b -> response)
}

let endpoint_handler endp req = req |> endp.from_req |> endp.f |> endp.to_resp

let route_of_endpoint endp = (endp.route, endp.meth, endpoint_handler endp)
