module List {
  fun len([]) = 0
  fun len(x::xs) = 1 + len(xs)

  fun @([], b) = b
  fun @(a, []) = a
  fun @(a::as, bs) = a :: (as @ bs)

  fun map(_, []) = []
  fun map(f, x::xs) = f(x) :: map(f, xs)
}

import List

fun weird('l') = 'w'
fun weird(c) = c

List.map(weird, "hello " @ "world")
