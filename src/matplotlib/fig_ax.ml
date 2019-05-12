open Base
open Pyops

module Ax = struct
  type t = Py.Object.t

  let set_title t title =
    ignore (t.&("set_title")[| Py.String.of_string title |])

  let set_xlabel t label =
    ignore (t.&("set_xlabel")[| Py.String.of_string label |])

  let set_ylabel t label =
    ignore (t.&("set_ylabel")[| Py.String.of_string label |])

  let grid t ?which ?axis b =
    let keywords =
      let b = Some ("b", Py.Bool.of_bool b) in
      let which =
        Option.map which ~f:(fun which ->
          let which =
            match which with
            | `major -> "major"
            | `minor -> "minor"
            | `both -> "both"
          in
          "which", Py.String.of_string which)
      in
      let axis =
        Option.map axis ~f:(fun axis ->
          let axis =
            match axis with
            | `both -> "both"
            | `x -> "x"
            | `y -> "y"
          in
          "axis", Py.String.of_string axis)
      in
      List.filter_opt [ b; which; axis ]
    in
    ignore (Py.Module.get_function_with_keywords t "grid" [||] keywords)

  let plot t ?color ?linewidth ?linestyle ?xs ys =
    Mpl.plot t ?color ?linewidth ?linestyle ?xs ys
end

module Fig = struct
  type t = Py.Object.t

  let create ?figsize () =
    let p = Mpl.pyplot_module () in
    let keywords =
      let figsize =
        Option.map figsize ~f:(fun (w, h) ->
          "figsize", Py.Tuple.of_pair Py.Float.(of_float w, of_float h))
      in
      List.filter_opt [ figsize ]
    in
    Py.Module.get_function_with_keywords p "figure" [||] keywords

  let add_subplot t ~nrows ~ncols ~index =
    let keywords = [] in
    let args = [| nrows; ncols; index |] |> Array.map ~f:Py.Int.of_int in
    Py.Module.get_function_with_keywords t "add_subplot" args keywords

  let create_with_ax ?figsize () =
    let t = create ?figsize () in
    let ax = add_subplot t ~nrows:1 ~ncols:1 ~index:1 in
    t, ax

  let suptitle t title =
    ignore (t.&("suptitle")[| Py.String.of_string title |])
end
