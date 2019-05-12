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
