import Core.List
import Maybe.MonadInfix

fun itWorksOnDisparateTypeParamsToMaybe() {
  def result =
    Just("hello") >>= fun(str) =
    Just(length(str)) >>= fun(len) =
    return(len + 1)

  IO.println(result)
}

fun itShortCircuitsOnNothing() {
  def result =
    Just("hello") >>= fun(str) =
    Nothing() >>= fun(len) =
    return(len + 1)

  IO.println(result)
}

itWorksOnDisparateTypeParamsToMaybe()
itShortCircuitsOnNothing()
