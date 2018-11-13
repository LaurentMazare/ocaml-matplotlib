type t

module Backend : sig
  type t =
    | Agg
    | Default
end

val init : Backend.t -> t
val xlabel : t -> string -> unit
val ylabel : t -> string -> unit
val grid : t -> bool -> unit
val plot : t -> xys:(float * float) list -> unit
val show : t -> unit
val savefig : t -> string -> unit
