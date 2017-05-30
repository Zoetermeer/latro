module Tests {
  import Core
  import Core.List
  import Core.Maybe
  import Core.Maybe.Monadic
  import IO

  itWorksOnDisparateTypeParamsToMaybe() = {
    let result =
      Just("hello") >>= fun(str) =
      Just(length(str)) >>= fun(len) =
      return(len + 1)

    println(result)
  }

  itShortCircuitsOnNothing() = {
    let result =
      Just("hello") >>= fun(str) =
      Nothing() >>= fun(len) =
      return(len + 1)

    println(result)
  }

  main(_) = {
    itWorksOnDisparateTypeParamsToMaybe()
    itShortCircuitsOnNothing()
  }
}
