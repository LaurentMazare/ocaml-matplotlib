module Ax : sig
  type t

  val set_title : t -> string -> unit
  val set_xlim : t -> left:float -> right:float -> unit
  val set_ylim : t -> bottom:float -> top:float -> unit
  val set_xlabel : t -> string -> unit
  val set_ylabel : t -> string -> unit
  val grid : t -> ?which:[`major|`minor|`both] -> ?axis:[`both|`x|`y] -> bool -> unit
  val legend
    :  ?loc:
      [`best
      |`upper_right
      |`upper_left
      |`lower_left
      |`lower_right
      |`right
      |`center_left
      |`center_right
      |`lower_center
      |`upper_center
      |`center]
    -> t
    -> unit

  val plot
    :  t
    -> ?label:string
    -> ?color:Mpl.Color.t
    -> ?linewidth:float
    -> ?linestyle:Mpl.Linestyle.t
    -> ?xs:float array
    -> float array
    -> unit

  val hist
    :  t
    -> ?label:string
    -> ?color:Mpl.Color.t
    -> ?bins:int
    -> ?orientation:[ `horizontal | `vertical ]
    -> ?histtype:[ `bar | `barstacked | `step | `stepfilled ]
    -> ?xs:float array list
    -> float array
    -> unit
end

module Fig : sig
  type t

  val create : ?figsize:(float * float) -> unit -> t

  (* Use the same api as the python library even if it seems a
     bit odd.
     Note that the index starts at 1 in the upper left corner and
     increases to the right.
  *)
  val add_subplot : t -> nrows:int -> ncols:int -> index:int -> Ax.t

  val create_with_ax : ?figsize:(float * float) -> unit -> t * Ax.t

  val create_with_two_axes : ?figsize:(float * float) -> [`horizontal|`vertical] -> t * Ax.t * Ax.t

  val suptitle : t -> string -> unit
end
