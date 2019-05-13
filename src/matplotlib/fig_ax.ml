open Base
open Pyops

module Ax = struct
  type t = Py.Object.t

  let set_title t title =
    ignore (t.&("set_title")[| Py.String.of_string title |])

  let set_xlim t ~left ~right =
    ignore (t.&("set_xlim")[| Py.Float.of_float left; Py.Float.of_float right |])

  let set_ylim t ~bottom ~top =
    ignore (t.&("set_ylim")[| Py.Float.of_float bottom; Py.Float.of_float top |])

  let set_xlabel t label =
    ignore (t.&("set_xlabel")[| Py.String.of_string label |])

  let set_ylabel t label =
    ignore (t.&("set_ylabel")[| Py.String.of_string label |])

  let set_aspect t ~aspect =
    let aspect =
      match aspect with
      | `auto -> Py.String.of_string "auto"
      | `equal -> Py.String.of_string  "equal"
      | `f f -> Py.Float.of_float f
    in
    ignore (t.&("set_aspect")[| aspect |])

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

  let legend ?loc t =
    let keywords =
      let loc =
        Option.map loc ~f:(fun loc ->
          let loc =
            match loc with
            | `best -> "best"
            | `upper_right -> "upper right"
            | `upper_left -> "upper left"
            | `lower_left -> "lower left"
            | `lower_right -> "lower right"
            | `right -> "right"
            | `center_left -> "center left"
            | `center_right -> "center right"
            | `lower_center -> "lower center"
            | `upper_center -> "upper center"
            | `center -> "center"
          in
          "loc", Py.String.of_string loc)
      in
      List.filter_opt [ loc ]
    in
    ignore (Py.Module.get_function_with_keywords t "legend" [||] keywords)

  let plot = Mpl.plot
  let hist = Mpl.hist
  let scatter = Mpl.scatter

  module Expert = struct
    let to_pyobject = Fn.id
  end
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

  let create_with_two_axes ?figsize orientation =
    let t = create ?figsize () in
    let nrows, ncols =
      match orientation with
      | `horizontal -> 1, 2
      | `vertical -> 2, 1
    in
    let ax1 = add_subplot t ~nrows ~ncols ~index:1 in
    let ax2 = add_subplot t ~nrows ~ncols ~index:2 in
    t, ax1, ax2

  let suptitle t title =
    ignore (t.&("suptitle")[| Py.String.of_string title |])

  module Expert = struct
    let to_pyobject = Fn.id
  end
end
