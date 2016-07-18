fun foldr(f, a, x::xs) = f(x, foldr(f, a, xs))
fun foldr(f, a, [])    = a

fun and(xs)            = foldr((&&), True, xs)
