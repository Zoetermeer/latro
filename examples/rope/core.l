module Core {
  type Maybe<a> =
    | Just(a)
    | Nothing

  fun lt(0, 0) = False
  fun lt(0, _) = True
  fun lt(_, 0) = False
  fun lt(a, b) {
    lt(a - 1, b - 1)
  }

  fun leq(0, 0) = True
  fun leq(0, _) = True
  fun leq(_, 0) = False
  fun leq(a, b) {
    leq(a - 1, b - 1)
  }

  fun gt(a, b) = !leq(a, b)
  fun geq(a, b) { !(lt(a, b)) }

  fun and(True, True) = True
  fun and(True, _)    = False
  fun and(_, _)       = False
}

module List {
  fun length([])    = 0
  fun length(x::xs) = 1 + length(xs)

  fun append([], bs)    = bs
  fun append(as, [])    = as
  fun append(a::as, bs) = a :: append(as, bs)

  fun atIndex([], _)    = Core.Nothing()
  fun atIndex(x::_, 0)  = Core.Just(x)
  fun atIndex(_::xs, n) = atIndex(xs, n - 1)
}

module String {
  type t = Char[]
}

fun (s).splitAt(0)      = %(s, "")
fun ("").splitAt(_)     = %("", "")
fun (c::cs).splitAt(1)  = %([c], cs)
fun (c::cs).splitAt(n) {
  def %(a, b) = cs.splitAt(n - 1)
  %(c :: a, b)
}
