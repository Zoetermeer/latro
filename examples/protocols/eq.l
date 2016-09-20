//Implicit free type variable identifiers
//Still need the single-param restriction check
//
protocol Eq on a {
  @(==) : a -> a -> Bool
}

imp Int : Eq {
  @(==)(x, y) = prim(intEq)(x, y)
}

main(_) = {
  prim(println)(42 == 43)
}
