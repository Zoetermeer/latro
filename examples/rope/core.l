module Core {
  fun &&(True, True) = True
  fun &&(_, _) = False

  precedence && 2

  fun ||(True, _) = True
  fun ||(_, True) = True
  fun ||(_, _) = False

  precedence || 2

  fun <(0, 0) = False
  fun <(0, _) = True
  fun <(_, 0) = False
  fun <(a, b) = a - 1 < b - 1

  precedence < 1

  fun not(True) = False
  fun not(_)    = True

  fun <=(0, 0) = True
  fun <=(0, _) = True
  fun <=(_, 0) = False
  fun <=(a, b) = a - 1 <= b - 1

  precedence <= 1

  fun >(a, b) = not(a <= b)
  fun >=(a, b) = not(a < b)

  precedence > 1
  precedence >= 1

  type String = Char[]

  fun (s).splitAt(0)      = %(s, "")
  fun ("").splitAt(_)     = %("", "")
  fun (c::cs).splitAt(1)  = %([c], cs)
  fun (c::cs).splitAt(n) {
    def %(a, b) = cs.splitAt(n - 1)
    %(c :: a, b)
  }

  type Maybe{a} =
    | Just(a)
    | Nothing

  type Result{e, t} =
    | Ok(t)
    | Error(e)

  module List {
    fun length([])    = 0
    fun length(x::xs) = 1 + length(xs)

    fun @([], bs)    = bs
    fun @(as, [])    = as
    fun @(a::as, bs) = a :: (as @ bs)

    fun ([]).at-index(_)    = Nothing()
    fun (x::_).at-index(0)  = Just(x)
    fun (_::xs).at-index(n) = xs.at-index(n - 1)
  }
}
