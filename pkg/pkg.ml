#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "holy-shit" @@ fun c ->
    Ok [ Pkg.bin "src/holy_shit" ~dst:"holy-shit" ]
