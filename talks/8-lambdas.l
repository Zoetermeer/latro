import Core

squareEm : Int[] -> Int[]
squareEm(xs) = List.map(fun(x) = x * x, xs)

main(_) {
  IO.println(squareEm([1, 2, 3, 4]))
}
