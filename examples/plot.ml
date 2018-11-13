open Base

let () =
  let plt = Matplotlib.init Default in
  let xys =
    List.init 120 ~f:(fun i ->
      let i = Float.of_int i in
      i, Float.sin (i /. 20.))
  in
  let xys2 =
    List.init 120 ~f:(fun i ->
      let i = Float.of_int i in
      i, Float.cos (i /. 12.))
  in
  Matplotlib.xlabel plt "x";
  Matplotlib.ylabel plt "sin(x)";
  Matplotlib.grid plt true;
  Matplotlib.plot plt ~color:Red ~xys;
  Matplotlib.plot plt ~color:Green ~linestyle:Dotted ~linewidth:2. ~xys:xys2;
  Matplotlib.savefig plt "test.png";
  Matplotlib.show plt
