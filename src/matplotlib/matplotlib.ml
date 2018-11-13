open Base
open Pyops

module Backend = struct
  type t =
    | Agg
    | Default
    | Other of string

  let to_string_option = function
    | Agg -> Some "Agg"
    | Default -> None
    | Other str -> Some str
end

module Color = struct
  type t =
    | Red
    | Green
    | Blue
    | White
    | Black
    | Yellow
    | Orange
    | Other of string

  let to_pyobject t =
    let str =
      match t with
      | Red -> "red"
      | Green -> "green"
      | Blue -> "blue"
      | White -> "white"
      | Black -> "black"
      | Yellow -> "yellow"
      | Orange -> "orange"
      | Other str -> str
    in
    Py.String.of_string str
end

module Linestyle = struct
  type t =
    | Solid
    | Dotted
    | Other of string

  let to_pyobject t =
    let str =
      match t with
      | Solid -> "-"
      | Dotted -> ":"
      | Other str -> str
    in
    Py.String.of_string str
end

type t = Py.Object.t

let init backend =
  Py.initialize ();
  let plt = Py.import "matplotlib.pyplot" in
  Option.iter (Backend.to_string_option backend) ~f:(fun backend_str ->
    ignore (plt.&("switch_backend")[| Py.String.of_string backend_str |]));
  plt

let xlabel t label =
  ignore (t.&("xlabel")[| Py.String.of_string label |])

let ylabel t label =
  ignore (t.&("ylabel")[| Py.String.of_string label |])

let grid t b =
  ignore (t.&("grid")[| Py.Bool.of_bool b |])

let savefig t filename =
  ignore (t.&("savefig")[| Py.String.of_string filename |])

let plot ?color ?linewidth ?linestyle t ~xys =
  let xs, ys = List.unzip xys in
  let xs = List.map xs ~f:Py.Float.of_float |> Py.List.of_list in
  let ys = List.map ys ~f:Py.Float.of_float |> Py.List.of_list in
  let keywords =
    List.filter_opt
      [ Option.map color ~f:(fun color -> "color", Color.to_pyobject color)
      ; Option.map linewidth ~f:(fun lw -> "linewidth", Py.Float.of_float lw)
      ; Option.map linestyle ~f:(fun ls -> "linestyle", Linestyle.to_pyobject ls)
      ]
  in
  ignore (Py.Module.get_function_with_keywords t "plot" [| xs; ys |] keywords)

let show t =
  ignore (t.&("show")[| |])
