//Implicit free type variable identifiers
//Still need the single-param restriction check
//
protocol Eq(a) {
  infixl (==) : a -> a -> Bool
}

//-->

==<a> : EqDict -> a -> a -> Bool
        where a : Eq
==(eqDict, x, y) = eqDict[a](x, y)

imp Eq(Int) {
  infixl (==)(x, y) = prim(intEq)(x, y)
}

//-->

DE[Eq] += { Int |-> fun(x, y) = prim(intEq)(x, y) }

member(_, []) = False
member(v, x @ xs) = {
  cond {
    v == x -> True
    _      -> member(v, xs)
  }
}

//-->

member(eqDict, v, xs) = {
  let args = %(v, xs)
  switch (args) {
    case %(_, [])     -> False
    case %(v, x @ xs) -> {
      cond {
        (prim(lookup)(eqDict, ==))(v, x) -> True
        _                                -> member(eqDict, v, xs)
      }
    }
  }
}


//Example
main(_) = {
  prim(println)(42 == 43)
}
