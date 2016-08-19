protocol Eq{a} {
  @(==) : a -> a -> Bool
}

protocol Comparable on a when a : Eq {
  @(<=) : a -> a -> Bool
}


Int : Eq {
  @(==)(x, y) = prim(intEq)(x, y)
}

Int : Comparable {
  @(<=)(x, y) = prim(intLeq)(x, y)
}


sort{a} : a[] -> a[] when a : Comparable
sort([]) = []
sort([x, y]) = cond {
  y < x -> [y, x]
  _     -> [x, y]
}
sort(p::xs) = {
  def (lt, gt) = partition(fun(x) = x <= p, xs)
  sort(lt) ++ [p] ++ sort(gt)
}
