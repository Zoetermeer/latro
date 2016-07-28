length{t} : t[] -> Int
length([]) = 0
length(_::xs) = 1 + length(xs)


main(_) {
  IO.println(length([]))
  IO.println(length([1, 2, 3]))
}
