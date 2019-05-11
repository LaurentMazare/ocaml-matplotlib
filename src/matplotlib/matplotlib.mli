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

(* Vector of float *)
module V : sig
  type t
  val l : float list -> t
  val a : float array -> t
end

val init : Backend.t -> unit
val xlabel : string -> unit
val ylabel : string -> unit
val grid : bool -> unit
val title : string -> unit

val plot
  :  ?color:Color.t
  -> ?linewidth:float
  -> ?linestyle:Linestyle.t
  -> ?xs:V.t
  -> V.t
  -> unit

val show : unit -> unit
val savefig : string -> unit
val plot_data : [`png | `jpg] -> string
