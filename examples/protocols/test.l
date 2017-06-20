module Program {
  import Core
  import IO (println)

  type Eq<a> = | MkEq(a -> a -> Bool)

  eq<a> : Eq<a> -> a -> a -> Bool
  eq(MkEq(eqf), x, y) = eqf(x, y)

  boolEq(True, False) = False
  boolEq(False, True) = False
  boolEq(_, _) = True

  main(_) = {
    let eqInt = MkEq(prim(intEq))
    let eqBool = MkEq(boolEq)

    println(eq(eqInt, 42, 43))
    println(eq(eqInt, 42, 42))
    println(eq(eqBool, False, True))
  }
}
