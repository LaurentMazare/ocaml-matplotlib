open Base
open Pyops

let float_array_to_python xs =
  Py.List.of_array_map Py.Float.of_float xs

let xlabel label =
  let p = Mpl.pyplot_module () in
  ignore (p.&("xlabel")[| Py.String.of_string label |])

let title label =
  let p = Mpl.pyplot_module () in
  ignore (p.&("title")[| Py.String.of_string label |])

let ylabel label =
  let p = Mpl.pyplot_module () in
  ignore (p.&("ylabel")[| Py.String.of_string label |])

let grid b =
  let p = Mpl.pyplot_module () in
  ignore (p.&("grid")[| Py.Bool.of_bool b |])

let plot ?color ?linewidth ?linestyle ?xs ys =
  let p = Mpl.pyplot_module () in
  let keywords =
    List.filter_opt
      [ Option.map color ~f:(fun color -> "color", Mpl.Color.to_pyobject color)
      ; Option.map linewidth ~f:(fun lw -> "linewidth", Py.Float.of_float lw)
      ; Option.map linestyle ~f:(fun ls -> "linestyle", Mpl.Linestyle.to_pyobject ls)
      ]
  in
  let args =
    match xs with
    | Some xs -> [| float_array_to_python xs; float_array_to_python ys |]
    | None -> [| float_array_to_python ys |]
  in
  ignore (Py.Module.get_function_with_keywords p "plot" args keywords)
