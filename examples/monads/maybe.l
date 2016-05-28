type Maybe<a> =
  | Just a
  | Nothing
  ;

bind<a, b> => fun(Maybe<a>, fun(a) : Maybe<b>) : Maybe<b>;
fun bind(Nothing(), _) = Nothing();
fun bind(Just(x), f) = f(x);

fun return(x) = Just(x);

def simulatedInput1 = Just("james");
def simulatedInput2 = Just("swaine");


bind(simulatedInput1, fun(s) = Just(s));
