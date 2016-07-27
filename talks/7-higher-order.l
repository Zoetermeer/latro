import Core

square : Int -> Int
square(x) = x * x

squareEm : Int[] -> Int[]
squareEm(xs) = List.map(square, xs)

main(_) {
  IO.println(squareEm([1, 2, 3, 4]))
}
