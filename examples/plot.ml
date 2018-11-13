open Base

let () =
  let plt = Matplotlib.init Default in
  let xys =
    List.init 120 ~f:(fun i ->
      let i = Float.of_int i in
      i, Float.sin (i /. 20.))
  in
  Matplotlib.xlabel plt "x";
  Matplotlib.ylabel plt "sin(x)";
  Matplotlib.grid plt true;
  Matplotlib.plot plt ~xys;
  Matplotlib.savefig plt "test.png";
  Matplotlib.show plt
