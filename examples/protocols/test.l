protocol Eq on a {
  equal : a -> a -> Bool
}

imp Int : Eq {
  equal(x, y) = prim(intEq)(x, y)
}


and(True, True) = True
and(_, _)       = False

imp a[] : Eq
when a : Eq {
  equal([], []) = True
  equal(x::xs, y::ys) =
    and(equal(x, y), equal(xs, ys))

  equal(_, _) = False
}

areEqual{a} : a -> a -> Bool
when a : Eq
areEqual(x, y) = equal(x, y)

main(_) = {
  def areEq = areEqual([1, 2], [3, 4, 5])
  prim(println)(areEq)
}
