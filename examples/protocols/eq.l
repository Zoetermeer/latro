protocol Eq(a) {
  infixl (==) : a -> a -> Bool
}

//-->
type Eq<a> = | MkEq(a -> a -> Bool)

infixl (==) : Eq<a> -> a -> a -> Bool
infixl (==)(MkEq(f), x, y) = f(x, y)
//---

imp Eq(Int) {
  infixl (==)(x, y) = prim(intEq)(x, y)
}

//-->

let EqInt = MkEq(fun(x, y) = prim(intEq)(x, y))

//---

areEq(a, b) = a == b

//-->

areEq<a> : Eq<a> -> a -> a -> Bool
areEq(d, x, y) = (==)(d, x, y)
