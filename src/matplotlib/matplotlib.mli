type t

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

val init : Backend.t -> t
val xlabel : t -> string -> unit
val ylabel : t -> string -> unit
val grid : t -> bool -> unit

val plot
  :  ?color:Color.t
  -> ?linewidth:float
  -> ?linestyle:Linestyle.t
  -> t
  -> xys:(float * float) list
  -> unit

val show : t -> unit
val savefig : t -> string -> unit
