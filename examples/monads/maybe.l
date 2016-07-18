module Maybe {
  module MonadInfix {
    fun >>=(Just(x), f) = f(x)
    fun >>=(_, _) = Nothing()

    fun return(x) = Just(x)
  }
}
