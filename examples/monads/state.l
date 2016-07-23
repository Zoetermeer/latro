module State {
  type State{s, r} = (s -> %(r, s))

  return{r, s} : r -> (s -> %(r, s))
  return{r, s} : r -> State{s, r}
  return(x) = fun(s) = %(x, s)

  get{s} : (-> (s -> %(s, s)))
  get() = fun(s) = %(s, s)

  put{v, s} : v -> s -> (s -> %(Unit, s))
  put(x, _) = fun(_) = %((), x)

  module MonadInfix {
    @(>>=){s, a, b} : State{s, a} -> (a -> State{s, b}) -> State{s, b}
    @(>>=)(s, f)
  }

  module MonadInfix {
    @(>>=)(Ok(x), f) = f(x)
    @(>>=)(err, _)   = err

    return(x) = Ok(x)
  }
}
