import Rope

fun itWrapsTwoRopesByASingleNode() {
  def r1 = Leaf("hello ")
  def r2 = Leaf("world")

  IO.println(concat'(r1, r2))
}

fun itDeletesRangeForLeaf() {
  def leaf = Leaf("hello")
  IO.println(delete(leaf, 1, 4))
}

fun itReturnsTheCharAtIndex() {
  def rope = Node(11, Leaf("hello "), Leaf("world"))
  IO.println(index(rope, 4))
  IO.println(index(rope, 8))
}

fun itInsertsTheStringAtIndexForLeaf() {
  def rope = Leaf("hello")
  IO.println(insert(rope, 4, " n").show())
}

fun itInsertsTheStringAtIndexForNode() {
  def rope = Node(11, Leaf("hello "), Leaf("world"))
  IO.println(insert(rope, 5, " wicked").show())
  IO.println(insert(rope, 9, "d go").show())
  IO.println(insert(rope, 6, "great ").show())
}

fun stressTests() {
  def r1 = Leaf("hello")
  def r2 = insert(r1, 5, " world")
  def r3 = insert(r2, 5, " wicked")
  def r4 = insert(r3, 0, "well, ")
  def r5 = insert(r4, 24, ".")

  IO.println(r5.show())
  IO.println(r5.length'())
}

def tests = [
  itWrapsTwoRopesByASingleNode,
  itDeletesRangeForLeaf,
  itReturnsTheCharAtIndex,
  itInsertsTheStringAtIndexForLeaf,
  itInsertsTheStringAtIndexForNode,
  stressTests
]

Core.List.each(fun(testFun) { testFun() }, tests)
