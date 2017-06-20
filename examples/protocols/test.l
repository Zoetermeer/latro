module Program {
  import Core
  import IO (println)

  type Eq<t1> = | MkEq(t1 -> t1 -> Bool, t1 -> t1 -> Bool)

  eq<a> : Eq<a> -> a -> a -> Bool
  eq(MkEq(eqf, _), x, y) = eqf(x, y)

  notEq<a> : Eq<a> -> a -> a -> Bool
  notEq(MkEq(_, notEqF), x, y) = notEqF(x, y)


  boolEq(True, False) = False
  boolEq(False, True) = False
  boolEq(_, _) = True

  boolNotEq(x, y) = not(boolEq(x, y))

  main(_) = {
    let eqInt = MkEq(prim(intEq), fun(x, y) = not(prim(intEq)(x, y)))
    let eqBool = MkEq(boolEq, boolNotEq)

    println(eq(eqInt, 42, 43))
    println(eq(eqInt, 42, 42))
    println(eq(eqBool, False, True))
    println(notEq(eqBool, False, True))
  }
}
