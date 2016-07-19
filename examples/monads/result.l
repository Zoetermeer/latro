module Result {
  module MonadInfix {
    fun >>=(Ok(x), f) = f(x)
    fun >>=(err, _)   = err

    fun return(x) = Ok(x)
  }
}
