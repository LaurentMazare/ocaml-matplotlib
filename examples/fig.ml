(* Example using the object oriented api. *)
open Base
open Matplotlib

let left_graph ax =
  let xs = List.init 120 ~f:Float.of_int in
  let ys1 = List.map xs ~f:(fun i -> Float.sin (i /. 20.)) in
  let ys2 = List.map xs ~f:(fun i -> Float.cos (i /. 12.)) in
  let xs = Array.of_list xs in
  let ys1 = Array.of_list ys1 in
  let ys2 = Array.of_list ys2 in
  Ax.set_title ax "left ax";
  Ax.set_xlabel ax "x label";
  Ax.set_ylabel ax "sin(x)";
  Ax.grid ax true;
  Ax.plot ax ~label:"sin1" ~color:Red ~xs ys1;
  Ax.plot ax ~label:"sin2" ~color:Green ~linestyle:Dotted ~linewidth:2. ~xs ys2;
  Ax.legend ax

let right_graph ax =
  let rnds =
    Array.init 5000 ~f:(fun _ ->
      let u1 = Random.float 1. in
      let u2 = Random.float 1. in
      Float.cos (2. *. 3.1415 *. u1) *. Float.sqrt (-. 2. *. Float.log u2))
  in
  Ax.hist ax rnds ~bins:50;
  Ax.set_title ax "hist";
  Ax.set_xlabel ax "Sample values";
  Ax.set_ylabel ax "Frequency"

let () =
  Mpl.style_available () |> List.iter ~f:Stdio.print_endline;
  Mpl.style_use "ggplot";
  let fig, ax1, ax2 = Fig.create_with_two_axes `horizontal in
  left_graph ax1;
  right_graph ax2;
  Fig.suptitle fig "the figure suptitle";
  Mpl.show ()

let () =
  let fig, ax = Fig.create_with_ax () in
  let xys1 =
    Array.init 1000 ~f:(fun i ->
      let f = Float.of_int i /. 20. in
      Float.sin f, Float.cos f)
  in
  let xys2 =
    Array.init 1000 ~f:(fun i ->
      let f = Float.of_int i /. 20. in
      let rho = 1. +. Float.cos f in
      rho *. Float.sin f, rho *. Float.cos f)
  in
  let xys3 =
    Array.init 1000 ~f:(fun i ->
      let f = Float.of_int i /. 20. in
      let rho = 1.5 +. 0.2 *. Float.cos (5. *. f) in
      rho *. Float.sin f, rho *. Float.cos f)
  in
  Ax.scatter ax ~s:4. ~c:Green ~marker:'o' ~alpha:0.5 xys1;
  Ax.scatter ax ~s:4. ~c:Red ~marker:'X' xys2;
  Ax.scatter ax ~c:Blue ~marker:'*' xys3;
  Fig.suptitle fig "...scatter...";
  Mpl.show ()
