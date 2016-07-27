type Optional{a} =
  | Present(a)
  | Absent

isPresent{a} : Optional{a} -> Bool
isPresent(Present(_)) = True
isPresent(_) = False

main(_) {
  def p = Present(42)
  IO.println(p)

  def Present(x) = p
  IO.println(x)
}
