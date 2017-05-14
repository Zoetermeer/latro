import Core::Maybe

module Maybe {
  module MonadInfix {
    infixl (>>=)(Just(x), f) = f(x)
    infixl (>>=)(_, _) = Nothing()

    return(x) = Just(x)
  }
}
