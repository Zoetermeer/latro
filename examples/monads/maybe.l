type Maybe{a} =
  | Just(a)
  | Nothing

fun >>=(Just(x), f) = f(x)
fun >>=(_, _) = Nothing()

fun return(x) = Just(x)

fun value(3) = Nothing()
fun value(i) = Just(i)


value(1) >>= fun(a) =
value(3) >>= fun(b) =
return(a + b)
