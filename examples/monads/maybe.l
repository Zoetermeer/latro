module Core.Maybe.Monadic {
  import Core.Maybe

  infixl (>>=)(Just(x), f) = f(x)
  infixl (>>=)(_, _) = Nothing()

  return(x) = Just(x)
}
