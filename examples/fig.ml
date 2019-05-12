(* Example using the object oriented api. *)
open Base
open Matplotlib

let () =
  let xs = List.init 120 ~f:Float.of_int in
  let ys1 = List.map xs ~f:(fun i -> Float.sin (i /. 20.)) in
  let ys2 = List.map xs ~f:(fun i -> Float.cos (i /. 12.)) in
  let xs = Array.of_list xs in
  let ys1 = Array.of_list ys1 in
  let ys2 = Array.of_list ys2 in
  let _fig, ax = Fig.create_with_ax () in
  Ax.set_xlabel ax "x label";
  Ax.set_ylabel ax "sin(x)";
  Ax.grid ax true;
  Ax.plot ax ~color:Red ~xs ys1;
  Ax.plot ax ~color:Green ~linestyle:Dotted ~linewidth:2. ~xs ys2;
  Mpl.show ()
