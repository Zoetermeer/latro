module Maybe {
  module MonadInfix {
    @(>>=)(Just(x), f) = f(x)
    @(>>=)(_, _) = Nothing()

    return(x) = Just(x)
  }
}
