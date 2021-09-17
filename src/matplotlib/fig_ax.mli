module Ax : sig
  type t

  val set_title : t -> string -> unit
  val set_xlim : t -> left:float -> right:float -> unit
  val set_ylim : t -> bottom:float -> top:float -> unit
  val set_xlabel : t -> string -> unit
  val set_ylabel : t -> string -> unit
  val set_aspect : t -> aspect:[ `auto | `equal | `f of float ] -> unit

  val grid
    :  t
    -> ?which:[ `major | `minor | `both ]
    -> ?axis:[ `both | `x | `y ]
    -> bool
    -> unit

  val legend
    :  t -> ?labels:string array -> ?loc:Mpl.Loc.t -> unit -> unit

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

  val scatter
    :  t
    -> ?s:float
    -> ?c:Mpl.Color.t
          (* Possible markers:
       'o', 'v', '^', '<', '>', '8', 's', 'p', '*', 'h', 'H', 'D', 'd', 'P', 'X'
    *)
    -> ?marker:char
    -> ?alpha:float
    -> ?linewidths:float
    -> (float * float) array
    -> unit

  val imshow : t -> ?cmap:string -> Mpl.Imshow_data.t -> unit

  module Expert : sig
    val to_pyobject : t -> Py.Object.t
  end
end

module Ax3d : sig
  type t

  val set_title : t -> string -> unit
  val set_xlim : t -> left:float -> right:float -> unit
  val set_ylim : t -> bottom:float -> top:float -> unit
  val set_zlim : t -> bottom:float -> top:float -> unit
  val set_xlabel : t -> string -> unit
  val set_ylabel : t -> string -> unit
  val set_zlabel : t -> string -> unit
  val grid : t -> bool -> unit

  val scatter
    :  t
    -> ?s:float
    -> ?c:Mpl.Color.t
    -> ?marker:char
    -> ?alpha:float
    -> ?linewidths:float
    -> (float * float * float) array
    -> unit

  val imshow : t -> ?cmap:string -> Mpl.Imshow_data.t -> unit

  module Expert : sig
    val to_pyobject : t -> Py.Object.t
  end
end

module Fig : sig
  type t

  val create : ?figsize:float * float -> unit -> t

  (* Use the same api as the python library even if it seems a
     bit odd.
     Note that the index starts at 1 in the upper left corner and
     increases to the right.
  *)
  val add_subplot : t -> nrows:int -> ncols:int -> index:int -> Ax.t
  val add_subplot_3d : t -> nrows:int -> ncols:int -> index:int -> Ax3d.t
  val create_with_ax : ?figsize:float * float -> unit -> t * Ax.t

  val create_with_two_axes
    :  ?figsize:float * float
    -> [ `horizontal | `vertical ]
    -> t * Ax.t * Ax.t

  val suptitle : t -> string -> unit

  module Expert : sig
    val to_pyobject : t -> Py.Object.t
  end
end
