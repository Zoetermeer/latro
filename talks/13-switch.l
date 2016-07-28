import Core

fibSwitch : Int -> Int
fibSwitch(x) = switch(x) {
  0 -> 0
  1 -> 1
  n -> fibSwitch(n - 1) + fibSwitch(n - 2)
}

fibClauses : Int -> Int
fibClauses(0) = 0
fibClauses(1) = 1
fibClauses(n) = fibClauses(n - 1) + fibClauses(n - 2)

main(_) {
  List.each(
    fun(i) {
      IO.println(
        %(fibSwitch(i), fibClauses(i))
      )
    },
    [1, 2, 3, 4, 5, 6, 7]
  )
}
