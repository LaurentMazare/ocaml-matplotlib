# ocaml-matplotlib
Plotting for ocaml using matplotlib pyplot and object-orient apis.


## Use in Jupyter notebooks
To use in an [ocaml jupyter notebook](https://github.com/akabe/ocaml-jupyter), you can add the following in you jupyter init script, or in a notebook cell.

```ocaml
open Matplotlib;;
let plot () =
  let data = Mpl.plot_data `png in
  ignore (Jupyter_notebook.display ~base64:true "image/png" data);;

let () =
    Mpl.set_backend Agg;
    Mpl.style_use "ggplot"
;;
```

Using `plot` in the notebook then flushes the current picture and displays it (no need for a temporary file, everything is in memory).
