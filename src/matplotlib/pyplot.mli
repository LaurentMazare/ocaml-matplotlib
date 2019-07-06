val xlim : left:float -> right:float -> unit
val ylim : bottom:float -> top:float -> unit
val xlabel : string -> unit
val ylabel : string -> unit
val grid : bool -> unit
val title : string -> unit

val plot
  :  ?label:string
  -> ?color:Mpl.Color.t
  -> ?linewidth:float
  -> ?linestyle:Mpl.Linestyle.t
  -> ?xs:float array
  -> float array
  -> unit

val hist
  :  ?label:string
  -> ?color:Mpl.Color.t
  -> ?bins:int
  -> ?orientation:[ `horizontal | `vertical ]
  -> ?histtype:[ `bar | `barstacked | `step | `stepfilled ]
  -> ?xs:float array list
  -> float array
  -> unit

val scatter
  :  ?s:float
  -> ?c:Mpl.Color.t
        (* Possible markers:
     'o', 'v', '^', '<', '>', '8', 's', 'p', '*', 'h', 'H', 'D', 'd', 'P', 'X'
  *)
  -> ?marker:char
  -> ?alpha:float
  -> ?linewidths:float
  -> (float * float) array
  -> unit

val imshow : ?cmap:string -> Mpl.Imshow_data.t -> unit
