import Rope

itWrapsTwoRopesByASingleNode() {
  def r1 = Leaf("hello ")
  def r2 = Leaf("world")

  IO.println(concat'(r1, r2))
}

itDeletesRangeForLeaf() {
  def leaf = Leaf("hello")
  IO.println(delete(leaf, 1, 4))
}

itReturnsTheCharAtIndex() {
  def rope = Node(11, Leaf("hello "), Leaf("world"))
  IO.println(index(rope, 4))
  IO.println(index(rope, 8))
}

itInsertsTheStringAtIndexForLeaf() {
  def rope = Leaf("hello")
  IO.println(show(insert(rope, 4, " n")))
}

itInsertsTheStringAtIndexForNode() {
  def rope = Node(11, Leaf("hello "), Leaf("world"))
  IO.println(show(insert(rope, 5, " wicked")))
  IO.println(show(insert(rope, 9, "d go")))
  IO.println(show(insert(rope, 6, "great ")))
}

stressTests() {
  def r1 = Leaf("hello")
  def r2 = insert(r1, 5, " world")
  def r3 = insert(r2, 5, " wicked")
  def r4 = insert(r3, 0, "well, ")
  def r5 = insert(r4, 24, ".")

  IO.println(show(r5))
  IO.println(length'(r5))
}

main(_) {
  def tests = [
    itWrapsTwoRopesByASingleNode,
    itDeletesRangeForLeaf,
    itReturnsTheCharAtIndex,
    itInsertsTheStringAtIndexForLeaf,
    itInsertsTheStringAtIndexForNode,
    stressTests
  ]

  Core.List.each(fun(testFun) { testFun() }, tests)
}
