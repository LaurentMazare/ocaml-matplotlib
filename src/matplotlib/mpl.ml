open Base
open Pyops

let pyplot_module = ref None

let maybe_py_init () =
  if not (Py.is_initialized ())
  then begin
    Py.initialize ();
    (* Reinstall the default signal handler as it may have been
       overriden when launching python. *)
    Caml.Sys.(set_signal sigint Signal_default)
  end

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
  let mpl = Py.import "matplotlib" in
  Option.iter (Backend.to_string_option backend) ~f:(fun backend_str ->
    ignore (mpl.&("use")[| Py.String.of_string backend_str |]));
  Py.import "matplotlib.pyplot"

let set_backend backend =
  let plt = init_ backend in
  pyplot_module := Some plt

let pyplot_module () =
  match !pyplot_module with
  | Some t -> t
  | None ->
    let t = init_ Default in
    pyplot_module := Some t;
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

let savefig filename =
  let p = pyplot_module () in
  ignore (p.&("savefig")[| Py.String.of_string filename |])

let plot_data format =
  let p = pyplot_module () in
  let format =
    match format with
    | `png -> "png"
    | `jpg -> "jpg"
  in
  let io = Py.import "io" in
  let bytes_io = io.&("BytesIO")[||] in
  let _ =
    Py.Module.get_function_with_keywords
      p
      "savefig"
      [| bytes_io |]
      [ "format", Py.String.of_string format ]
  in
  bytes_io.&("getvalue")[||] |> Py.String.to_string

let show () =
  let p = pyplot_module () in
  ignore (p.&("show")[| |])

let style_available () =
  let p = pyplot_module () in
  p.@$("style").@$("available") |> Py.List.to_list_map Py.String.to_string

let style_use s =
  let p = pyplot_module () in
  ignore (p.@$("style").&("use")[| Py.String.of_string s |])

module Public = struct
  module Backend = Backend
  module Color = Color
  module Linestyle = Linestyle

  let set_backend = set_backend
  let show = show
  let savefig = savefig
  let plot_data = plot_data
  let style_available = style_available
  let style_use = style_use
end

let float_array_to_python xs =
  Py.List.of_array_map Py.Float.of_float xs

let plot p ?label ?color ?linewidth ?linestyle ?xs ys =
  let keywords =
    List.filter_opt
      [ Option.map color ~f:(fun color -> "color", Color.to_pyobject color)
      ; Option.map linewidth ~f:(fun lw -> "linewidth", Py.Float.of_float lw)
      ; Option.map linestyle ~f:(fun ls -> "linestyle", Linestyle.to_pyobject ls)
      ; Option.map label ~f:(fun l -> "label", Py.String.of_string l)
      ]
  in
  let args =
    match xs with
    | Some xs -> [| float_array_to_python xs; float_array_to_python ys |]
    | None -> [| float_array_to_python ys |]
  in
  ignore (Py.Module.get_function_with_keywords p "plot" args keywords)

let hist p ?label ?color ?bins ?orientation ?histtype ?xs ys =
  let keywords =
    List.filter_opt
      [ Option.map color ~f:(fun color -> "color", Color.to_pyobject color)
      ; Option.map label ~f:(fun l -> "label", Py.String.of_string l)
      ; Option.map bins ~f:(fun b -> "bins", Py.Int.of_int b)
      ; Option.map orientation ~f:(fun o ->
        let o =
          match o with
          | `horizontal -> "horizontal"
          | `vertical -> "vertical"
        in
        "orientation", Py.String.of_string o)
      ; Option.map histtype ~f:(fun h ->
        let h =
          match h with
          | `bar -> "bar"
          | `barstacked -> "barstacked"
          | `step -> "step"
          | `stepfilled -> "stepfilled"
        in
        "histtype", Py.String.of_string h)
      ]
  in
  let args =
    match xs with
    | Some xs -> [| List.map (ys::xs) ~f:float_array_to_python |> Py.List.of_list |]
    | None -> [| float_array_to_python ys |]
  in
  ignore (Py.Module.get_function_with_keywords p "hist" args keywords)
