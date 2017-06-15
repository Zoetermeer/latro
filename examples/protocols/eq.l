protocol Eq(a) {
  infixl (==) : a -> a -> Bool
  notEq       : a -> a -> Bool
}

//-->
type EqDict<t1> = | MkEqDict(t1 -> t1 -> Bool, t1 -> t1 -> Bool)


infixl (==)<t2>  : EqDict<t2> -> (t2 -> t2 -> Bool) where t2 : Eq
infixl (==)(dict) =
  switch (dict) {
    MkEqDict(eqf, _) -> fun(x, y) = eqf(x, y)
  }


notEq<t3>        : EqDict<t3> -> t3 -> t3 -> Bool
notEq(MkEqDict(_, notEqF), x, y) = notEqF(x, y)
//---

imp Eq(Int) {
  infixl (==)(x, y) = prim(intEq)(x, y)
  notEq(x, y)       = not(x == y)
}

//-->

let EqIntDict = MkEqDict(
  fun(x, y) = prim(intEq)(x, y),
  fun(x, y) = (==)(x, y)
)

//---

areEq(a, b) = a == b

//-->

areEq<a> : EqDict<a> -> a -> a -> Bool
areEq(d, x, y) = (==)(d, x, y)
