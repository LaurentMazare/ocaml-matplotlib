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

let semilogy ?label ?color ?linewidth ?linestyle ?xs ys =
  let p = Mpl.pyplot_module () in
  Mpl.semilogy p ?label ?color ?linewidth ?linestyle ?xs ys

let semilogx ?label ?color ?linewidth ?linestyle ?xs ys =
  let p = Mpl.pyplot_module () in
  Mpl.semilogx p ?label ?color ?linewidth ?linestyle ?xs ys

let loglog ?label ?color ?linewidth ?linestyle ?xs ys =
  let p = Mpl.pyplot_module () in
  Mpl.loglog p ?label ?color ?linewidth ?linestyle ?xs ys

let fill_between ?color ?alpha xs ys1 ys2 =
  let p = Mpl.pyplot_module () in
  Mpl.fill_between p ?color ?alpha xs ys1 ys2

let hist ?label ?color ?bins ?orientation ?histtype ?xs ys =
  let p = Mpl.pyplot_module () in
  Mpl.hist p ?label ?color ?bins ?orientation ?histtype ?xs ys

let scatter ?s ?c ?marker ?alpha ?linewidths xys =
  let p = Mpl.pyplot_module () in
  Mpl.scatter p ?s ?c ?marker ?alpha ?linewidths xys

let scatter_3d ?s ?c ?marker ?alpha ?linewidths xyzs =
  let p = Mpl.pyplot_module () in
  Mpl.scatter_3d p ?s ?c ?marker ?alpha ?linewidths xyzs

let imshow ?cmap xys =
  let p = Mpl.pyplot_module () in
  Mpl.imshow p ?cmap xys

let legend ?labels ?loc () =
  let p = Mpl.pyplot_module () in
  Mpl.legend p ?labels ?loc ()
