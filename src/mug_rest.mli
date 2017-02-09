open Mug

type ('a, 'b) endpoint = {
 route     : string;
 meth      : string;
 from_req  : (request -> 'a);
 f         : ('a -> 'b);
 to_resp   : ('b -> response)
}

val route_of_endpoint : ('a, 'b) endpoint -> route
