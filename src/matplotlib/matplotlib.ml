open Base
open Pyops

let plt_module = ref None

let maybe_py_init () =
  if not (Py.is_initialized ())
  then Py.initialize ()

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

let init_ backend =
  maybe_py_init ();
  let plt = Py.import "matplotlib.pyplot" in
  Option.iter (Backend.to_string_option backend) ~f:(fun backend_str ->
    ignore (plt.&("switch_backend")[| Py.String.of_string backend_str |]));
  plt

let init backend =
  let plt = init_ backend in
  plt_module := Some plt

let maybe_init () =
  match !plt_module with
  | Some t -> t
  | None ->
    let t = init_ Default in
    plt_module := Some t;
    t

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

module V = struct
  type t = Py.Object.t

  let l xs =
    maybe_py_init ();
    Py.List.of_list_map Py.Float.of_float xs

  let a xs =
    maybe_py_init ();
    Py.List.of_array_map Py.Float.of_float xs
end

let xlabel label =
  let t = maybe_init () in
  ignore (t.&("xlabel")[| Py.String.of_string label |])

let title label =
  let t = maybe_init () in
  ignore (t.&("title")[| Py.String.of_string label |])

let ylabel label =
  let t = maybe_init () in
  ignore (t.&("ylabel")[| Py.String.of_string label |])

let grid b =
  let t = maybe_init () in
  ignore (t.&("grid")[| Py.Bool.of_bool b |])

let savefig filename =
  let t = maybe_init () in
  ignore (t.&("savefig")[| Py.String.of_string filename |])

let plot_data format =
  let t = maybe_init () in
  let format =
    match format with
    | `png -> "png"
    | `jpg -> "jpg"
  in
  let io = Py.import "io" in
  let bytes_io = io.&("BytesIO")[||] in
  let _ =
    Py.Module.get_function_with_keywords
      t
      "savefig"
      [| bytes_io |]
      [ "format", Py.String.of_string format ]
  in
  bytes_io.&("getvalue")[||] |> Py.String.to_string

let plot ?color ?linewidth ?linestyle ?xs ys =
  let t = maybe_init () in
  let keywords =
    List.filter_opt
      [ Option.map color ~f:(fun color -> "color", Color.to_pyobject color)
      ; Option.map linewidth ~f:(fun lw -> "linewidth", Py.Float.of_float lw)
      ; Option.map linestyle ~f:(fun ls -> "linestyle", Linestyle.to_pyobject ls)
      ]
  in
  let args =
    match xs with
    | Some xs -> [| xs; ys |]
    | None -> [| ys |]
  in
  ignore (Py.Module.get_function_with_keywords t "plot" args keywords)

let show () =
  let t = maybe_init () in
  ignore (t.&("show")[| |])
