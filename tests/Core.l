fun +(a, b) = prim(intAdd)(a, b)
fun -(a, b) = prim(intSub)(a, b)
fun *(a, b) = prim(intMul)(a, b)
fun /(a, b) = prim(intDiv)(a, b)

precedence + 6
precedence - 6
precedence * 5
precedence / 5

fun <(a, b)   = prim(intLt)(a, b)
fun <=(a, b)  = prim(intLeq)(a, b)
fun >(a, b)   = prim(intGt)(a, b)
fun >=(a, b)  = prim(intGeq)(a, b)
fun ==(a, b)  = prim(intEq)(a, b)

fun ||(True, _) = True
fun ||(_, True) = True
fun ||(_, _)    = False

fun &&(True, True) = True
fun &&(_, _)       = False

precedence || 7
precedence && 7

module Core { }

module IO {
  def println = prim(println)
}
