val xlabel : string -> unit
val ylabel : string -> unit
val grid : bool -> unit
val title : string -> unit

val plot
  :  ?color:Mpl.Color.t
  -> ?linewidth:float
  -> ?linestyle:Mpl.Linestyle.t
  -> ?xs:float array
  -> float array
  -> unit
