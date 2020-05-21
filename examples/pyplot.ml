(* Example using the pyplot api. *)
open Base
open Matplotlib

let () =
  let xs = List.init 120 ~f:Float.of_int in
  let ys1 = List.map xs ~f:(fun i -> Float.sin (i /. 20.)) in
  let ys2 = List.map xs ~f:(fun i -> Float.cos (i /. 12.)) in
  let xs = Array.of_list xs in
  let ys1 = Array.of_list ys1 in
  let ys2 = Array.of_list ys2 in
  Pyplot.xlabel "x";
  Pyplot.ylabel "y";
  Pyplot.grid true;
  Pyplot.plot ~color:Red ~xs ys1;
  Pyplot.plot ~color:Green ~linestyle:Dotted ~linewidth:2. ~xs ys2;
  Pyplot.legend ~labels:[|"$y=\\sin(x/20)$"; "$y=\\cos(x/12)$"|] ();
  Mpl.savefig "test.png";
  let data = Mpl.plot_data `png in
  Stdio.Out_channel.write_all "test2.png" ~data;
  Mpl.show ()
