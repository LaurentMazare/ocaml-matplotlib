open Base
open Pyops

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
  Mpl.plot p ?color ?linewidth ?linestyle ?xs ys
