fib : Int -> Int
fib(0) = 0
fib(1) = 1
fib(n) = fib(n - 1) + fib(n - 2)

main : String[] -> Unit
main(_) {
  IO.println(fib(0))
  IO.println(fib(7))
}
