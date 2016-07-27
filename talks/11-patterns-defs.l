import Core

isEven(x) = mod(x, 2) == 0

sumEvens([]) = 0
sumEvens(xs) {
  def %(evens, _) = List.partition(isEven, xs)
  List.foldl((+), 0, evens)
}

main(_) {
  IO.println(sumEvens([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
}
