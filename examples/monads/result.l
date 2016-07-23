module Result {
  module MonadInfix {
    @(>>=)(Ok(x), f) = f(x)
    @(>>=)(err, _)   = err

    return(x) = Ok(x)
  }
}
