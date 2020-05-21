open Base
open Pyops

let title label =
  let p = Mpl.pyplot_module () in
  ignore ((p.&("title")) [| Py.String.of_string label |])

let xlabel label =
  let p = Mpl.pyplot_module () in
  ignore ((p.&("xlabel")) [| Py.String.of_string label |])

let ylabel label =
  let p = Mpl.pyplot_module () in
  ignore ((p.&("ylabel")) [| Py.String.of_string label |])

let xlim ~left ~right =
  let p = Mpl.pyplot_module () in
  ignore ((p.&("xlim")) [| Py.Float.of_float left; Py.Float.of_float right |])

let ylim ~bottom ~top =
  let p = Mpl.pyplot_module () in
  ignore ((p.&("ylim")) [| Py.Float.of_float bottom; Py.Float.of_float top |])

let grid b =
  let p = Mpl.pyplot_module () in
  ignore ((p.&("grid")) [| Py.Bool.of_bool b |])

let plot ?label ?color ?linewidth ?linestyle ?xs ys =
  let p = Mpl.pyplot_module () in
  Mpl.plot p ?label ?color ?linewidth ?linestyle ?xs ys

let hist ?label ?color ?bins ?orientation ?histtype ?xs ys =
  let p = Mpl.pyplot_module () in
  Mpl.hist p ?label ?color ?bins ?orientation ?histtype ?xs ys

let scatter ?s ?c ?marker ?alpha ?linewidths xys =
  let p = Mpl.pyplot_module () in
  Mpl.scatter p ?s ?c ?marker ?alpha ?linewidths xys

let imshow ?cmap xys =
  let p = Mpl.pyplot_module () in
  Mpl.imshow p ?cmap xys

let legend ?labels ?loc () =
  let p = Mpl.pyplot_module () in
  Mpl.legend p ?labels ?loc ()
