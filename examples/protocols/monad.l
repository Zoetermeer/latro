protocol Monad on m {
  @(>>=){a, b} : m{a} -> (a -> m{b}) -> m{b}
}

type foo{a} = a[]


bar : a -> a
bar(x) = x


main(_) = {
  prim(println)(bar(42))
}
