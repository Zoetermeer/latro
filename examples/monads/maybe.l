type Maybe<a> =
  | Just(a)
  | Nothing

//bind<a, b> => fun(Maybe<a>)(fun(a) : Maybe<b>) : Maybe<b>;
fun (Just(x)).bind(f) = f(x)
fun (_).bind(_) = Nothing()

fun return(x) = Just(x)

def simulatedInput1 = Just("james")
def simulatedInput2 = Just("swaine")

fun compose(f, g) = fun(x) = f(g(x))

simulatedInput1.bind(fun(s) {
  simulatedInput2.bind(return)
})
