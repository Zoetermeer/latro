fun +(a, b) = prim(intAdd)(a, b)
fun -(a, b) = prim(intSub)(a, b)
fun *(a, b) = prim(intMul)(a, b)
fun /(a, b) = prim(intDiv)(a, b)

precedence + 6
precedence - 6
precedence * 5
precedence / 5

fun not(True) = False
fun not(_)    = True

fun <(a, b)   = prim(intLt)(a, b)
fun <=(a, b)  = prim(intLeq)(a, b)
fun >(a, b)   = prim(intGt)(a, b)
fun >=(a, b)  = prim(intGeq)(a, b)
fun ==(a, b)  = prim(intEq)(a, b)
fun !=(a, b)  = not(a == b)

precedence < 9
precedence > 9
precedence <= 9
precedence >= 9
precedence == 10
precedence != 10

fun ||(True, _) = True
fun ||(_, True) = True
fun ||(_, _)    = False

fun &&(True, True) = True
fun &&(_, _)       = False

precedence || 11
precedence && 11


type String = Char[]

type Maybe{a} =
  | Just(a)
  | Nothing

type Result{e, t} =
  | Ok(t)
  | Error(e)

module Core {
  fun id(v) = v

  module List {
    fun length([])    = 0
    fun length(x::xs) = 1 + length(xs)

    fun ++([], bs)    = bs
    fun ++(as, [])    = as
    fun ++(a::as, bs) = a :: (as ++ bs)

    fun ([]).at-index(_)    = Nothing()
    fun (x::_).at-index(0)  = Just(x)
    fun (_::xs).at-index(n) = xs.at-index(n - 1)

    fun each(_, []) = ()
    fun each(f, x::xs) {
      f(x)
      each(f, xs)
    }
  }
}

module IO {
  def println = prim(println)
}

type String = Char[]

module String {
  fun (s).splitAt(0)      = %("", s)
  fun ("").splitAt(_)     = %("", "")
  fun (c::cs).splitAt(1)  = %([c], cs)
  fun (c::cs).splitAt(n) {
    def %(a, b) = cs.splitAt(n - 1)
    %(c :: a, b)
  }
}
