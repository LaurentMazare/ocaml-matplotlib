module Backend : sig
  type t =
    | Agg
    | Default
    | Other of string
end

module Color : sig
  type t =
    | Red
    | Green
    | Blue
    | White
    | Black
    | Yellow
    | Orange
    | Other of string

  val to_pyobject : t -> Py.Object.t
end

module Linestyle : sig
  type t =
    | Solid
    | Dotted
    | Other of string

  val to_pyobject : t -> Py.Object.t
end

(* [set_backend] has to be called before any other operation. *)
val set_backend : Backend.t -> unit

val pyplot_module : unit -> Py.Object.t

val show : unit -> unit
val savefig : string -> unit
val plot_data : [`png | `jpg] -> string

module Public : sig
  module Backend : sig
    type t =
      | Agg
      | Default
      | Other of string
  end

  module Color : sig
    type t =
      | Red
      | Green
      | Blue
      | White
      | Black
      | Yellow
      | Orange
      | Other of string
  end

  module Linestyle : sig
    type t =
      | Solid
      | Dotted
      | Other of string
  end


  (* [set_backend] has to be called before any other operation. *)
  val set_backend : Backend.t -> unit
  val show : unit -> unit
  val savefig : string -> unit
  val plot_data : [`png | `jpg] -> string
end

(* Only internal functions below. *)
val plot
  :  Py.Object.t
  -> ?label:string
  -> ?color:Color.t
  -> ?linewidth:float
  -> ?linestyle:Linestyle.t
  -> ?xs:float array
  -> float array
  -> unit

val hist
  : Py.Object.t
  -> ?label:string
  -> ?color:Color.t
  -> ?bins:int
  -> ?orientation:[ `horizontal | `vertical ]
  -> ?histtype:[ `bar | `barstacked | `step | `stepfilled ]
  -> ?xs:float array list
  -> float array
  -> unit
