//Implicit free type variable identifiers
//Still need the single-param restriction check
//
protocol Eq {
  @(==) : a -> a -> Bool
}


Int : Eq {
  @(==)(x, y) = prim(intEq)(x, y)
}
