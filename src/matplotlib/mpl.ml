open Base
open Pyops

let pyplot_module = ref None

let maybe_py_init () =
  if not (Py.is_initialized ())
  then (
    Py.initialize ();
    (* Reinstall the default signal handler as it may have been
       overriden when launching python. *)
    Caml.Sys.(set_signal sigint Signal_default))

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
      ignore ((mpl.&("use")) [| Py.String.of_string backend_str |]));
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
  ignore ((p.&("savefig")) [| Py.String.of_string filename |])

let plot_data format =
  let p = pyplot_module () in
  let format =
    match format with
    | `png -> "png"
    | `jpg -> "jpg"
  in
  let io = Py.import "io" in
  let bytes_io = (io.&("BytesIO")) [||] in
  let _ =
    Py.Module.get_function_with_keywords
      p
      "savefig"
      [| bytes_io |]
      [ "format", Py.String.of_string format ]
  in
  (bytes_io.&("getvalue")) [||] |> Py.String.to_string

let show () =
  let p = pyplot_module () in
  ignore ((p.&("show")) [||])

let style_available () =
  let p = pyplot_module () in
  (p.@$("style")).@$("available") |> Py.List.to_list_map Py.String.to_string

let style_use s =
  let p = pyplot_module () in
  ignore (((p.@$("style")).&("use")) [| Py.String.of_string s |])

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

let float_array_to_python xs = Py.List.of_array_map Py.Float.of_float xs

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
    | Some xs -> [| List.map (ys :: xs) ~f:float_array_to_python |> Py.List.of_list |]
    | None -> [| float_array_to_python ys |]
  in
  ignore (Py.Module.get_function_with_keywords p "hist" args keywords)

let scatter p ?s ?c ?marker ?alpha ?linewidths xys =
  let keywords =
    List.filter_opt
      [ Option.map c ~f:(fun c -> "c", Color.to_pyobject c)
      ; Option.map s ~f:(fun s -> "s", Py.Float.of_float s)
      ; Option.map marker ~f:(fun m -> "marker", String.of_char m |> Py.String.of_string)
      ; Option.map alpha ~f:(fun a -> "alpha", Py.Float.of_float a)
      ; Option.map linewidths ~f:(fun l -> "linewidths", Py.Float.of_float l)
      ]
  in
  let xs = Py.List.of_array_map (fun (x, _) -> Py.Float.of_float x) xys in
  let ys = Py.List.of_array_map (fun (_, y) -> Py.Float.of_float y) xys in
  ignore (Py.Module.get_function_with_keywords p "scatter" [| xs; ys |] keywords)

module Imshow_data = struct
  type 'a data =
    | Scalar of 'a array array
    | Rgb of ('a * 'a * 'a) array array
    | Rgba of ('a * 'a * 'a * 'a) array array

  type 'a typ_ =
    | Int : int typ_
    | Float : float typ_

  let int = Int
  let float = Float

  type t = P : ('a data * 'a typ_) -> t

  let scalar typ_ data = P (Scalar data, typ_)
  let rgb typ_ data = P (Rgb data, typ_)
  let rgba typ_ data = P (Rgba data, typ_)

  let to_pyobject (P (data, typ_)) =
    let to_pyobject ~scalar_to_pyobject =
      match data with
      | Scalar data ->
        Py.List.of_array_map (Py.List.of_array_map scalar_to_pyobject) data
      | Rgb data ->
        let rgb_to_pyobject (r, g, b) =
          (scalar_to_pyobject r, scalar_to_pyobject g, scalar_to_pyobject b)
          |> Py.Tuple.of_tuple3
        in
        Py.List.of_array_map (Py.List.of_array_map rgb_to_pyobject) data
      | Rgba data ->
        let rgba_to_pyobject (r, g, b, a) =
          ( scalar_to_pyobject r
          , scalar_to_pyobject g
          , scalar_to_pyobject b
          , scalar_to_pyobject a )
          |> Py.Tuple.of_tuple4
        in
        Py.List.of_array_map (Py.List.of_array_map rgba_to_pyobject) data
    in
    match typ_ with
    | Int -> to_pyobject ~scalar_to_pyobject:Py.Int.of_int
    | Float -> to_pyobject ~scalar_to_pyobject:Py.Float.of_float
end

let imshow p ?cmap data =
  let keywords =
    List.filter_opt [ Option.map cmap ~f:(fun c -> "cmap", Py.String.of_string c) ]
  in
  let data = Imshow_data.to_pyobject data in
  ignore (Py.Module.get_function_with_keywords p "imshow" [| data |] keywords)
