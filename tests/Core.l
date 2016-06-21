module Core {
  fun +(a, b) = primitive("add_int", a, b)
  fun -(a, b) = primitive("sub_int", a, b)
  fun *(a, b) = primitive("mul_int", a, b)
  fun /(a, b) = primitive("div_int", a, b)

  precedence * 5
  precedence / 5
  precedence + 6
  precedence - 6

  fun &&(True, True) = True
  fun &&(_, _) = False

  fun ||(True, _) = True
  fun ||(_, True) = True
  fun ||(_, _) = False

  type String = Char[]

  type Maybe{a} =
    | Just(a)
    | Nothing

  type Result{e, t} =
    | Ok(t)
    | Error(e)
}
