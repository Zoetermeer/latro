type Maybe{a} =
  | Just(a)
  | Nothing

fun >>=(Just(x), f) = f(x)
fun >>=(_, _) = Nothing()

fun return(x) = Just(x)

def simulatedInput1 = Nothing()
def simulatedInput2 = Just("swaine")

fun compose(f, g) = fun(x) = f(g(x))

simulatedInput1 >>= fun(s) {
  simulatedInput2 >>= return
}
