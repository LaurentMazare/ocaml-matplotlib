open Base
open Pyops

module Backend = struct
  type t =
    | Agg
    | Default

  let to_string_option = function
    | Agg -> Some "Agg"
    | Default -> None
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

let plot t ~xys =
  let xs, ys = List.unzip xys in
  let xs = List.map xs ~f:Py.Float.of_float |> Py.List.of_list in
  let ys = List.map ys ~f:Py.Float.of_float |> Py.List.of_list in
  ignore (t.&("plot")[| xs; ys |])

let show t =
  ignore (t.&("show")[| |])
