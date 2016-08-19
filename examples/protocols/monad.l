protocol Monad{m} {
  @(>>=){a, b} : m{a} -> (a -> m{b}) -> m{b}
}
