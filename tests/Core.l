fun +(a, b) = prim(intAdd)(a, b)
fun -(a, b) = prim(intSub)(a, b)
fun *(a, b) = prim(intMul)(a, b)
fun /(a, b) = prim(intDiv)(a, b)

precedence + 6
precedence - 6
precedence * 5
precedence / 5

module Core { }

module IO {
  def println = prim(println)
}
