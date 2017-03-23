import IO
import Rope

itWrapsTwoRopesByASingleNode() = {
  let r1 = Rope.Leaf("hello ")
  let r2 = Rope.Leaf("world")

  println(Rope.concat'(r1, r2))
}

itDeletesRangeForLeaf() = {
  let leaf = Rope.Leaf("hello")
  println(delete(leaf, 1, 4))
}

itReturnsTheCharAtIndex() = {
  let rope = Node(11, Leaf("hello "), Leaf("world"))
  println(index(rope, 4))
  println(index(rope, 8))
}

itInsertsTheStringAtIndexForLeaf() = {
  let rope = Leaf("hello")
  println(show(insert(rope, 4, " n")))
}

itInsertsTheStringAtIndexForNode() = {
  let rope = Node(11, Leaf("hello "), Leaf("world"))
  println(show(insert(rope, 5, " wicked")))
  println(show(insert(rope, 9, "d go")))
  println(show(insert(rope, 6, "great ")))
}

stressTests() = {
  let r1 = Leaf("hello")
  let r2 = insert(r1, 5, " world")
  let r3 = insert(r2, 5, " wicked")
  let r4 = insert(r3, 0, "well, ")
  let r5 = insert(r4, 24, ".")

  println(show(r5))
  println(length'(r5))
}

main(_) = {
  let tests = [
    itWrapsTwoRopesByASingleNode,
    itDeletesRangeForLeaf,
    itReturnsTheCharAtIndex,
    itInsertsTheStringAtIndexForLeaf,
    itInsertsTheStringAtIndexForNode,
    stressTests
  ]

  Core.List.each(fun(testFun) = testFun(), tests)
}
