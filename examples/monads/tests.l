import Core.List
import Maybe.MonadInfix

itWorksOnDisparateTypeParamsToMaybe() = {
  let result =
    Just("hello") >>= fun(str) =
    Just(length(str)) >>= fun(len) =
    return(len + 1)

  IO.println(result)
}

itShortCircuitsOnNothing() = {
  let result =
    Just("hello") >>= fun(str) =
    Nothing() >>= fun(len) =
    return(len + 1)

  IO.println(result)
}

main(_) = {
  itWorksOnDisparateTypeParamsToMaybe()
  itShortCircuitsOnNothing()
}
