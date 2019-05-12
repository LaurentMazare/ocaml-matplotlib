open Base

let () =
  let xs = List.init 120 ~f:Float.of_int in
  let ys1 = List.map xs ~f:(fun i -> Float.sin (i /. 20.)) in
  let ys2 = List.map xs ~f:(fun i -> Float.cos (i /. 12.)) in
  let xs = Matplotlib.V.l xs in
  let ys1 = Matplotlib.V.l ys1 in
  let ys2 = Matplotlib.V.l ys2 in
  Matplotlib.xlabel "x";
  Matplotlib.ylabel "sin(x)";
  Matplotlib.grid true;
  Matplotlib.plot ~color:Red ~xs ys1;
  Matplotlib.plot ~color:Green ~linestyle:Dotted ~linewidth:2. ~xs ys2;
  Matplotlib.savefig "test.png";
  let data = Matplotlib.plot_data `png in
  Stdio.Out_channel.write_all "test2.png" ~data;
  Matplotlib.show ()
