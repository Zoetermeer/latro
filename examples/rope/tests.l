module Example.Rope.Tests {
  import Core.List = List
  import IO
  import Example
  import Example.Rope = Rope

  itWrapsTwoRopesByASingleNode() = {
    let r1 = Rope.Leaf("hello ")
    let r2 = Rope.Leaf("world")

    println(Rope.concat'(r1, r2))
  }

  itDeletesRangeForLeaf() = {
    let leaf = Rope.Leaf("hello")
    println(Rope.delete(leaf, 1, 4))
  }

  itReturnsTheCharAtIndex() = {
    let rope = Rope.Node(11, Rope.Leaf("hello "), Rope.Leaf("world"))
    println(Rope.index(rope, 4))
    println(Rope.index(rope, 8))
  }

  itInsertsTheStringAtIndexForLeaf() = {
    let rope = Rope.Leaf("hello")
    println(Rope.show(Rope.insert(rope, 4, " n")))
  }

  itInsertsTheStringAtIndexForNode() = {
    let rope = Rope.Node(11, Rope.Leaf("hello "), Rope.Leaf("world"))
    println(Rope.show(Rope.insert(rope, 5, " wicked")))
    println(Rope.show(Rope.insert(rope, 9, "d go")))
    println(Rope.show(Rope.insert(rope, 6, "great ")))
  }

  stressTests() = {
    let r1 = Rope.Leaf("hello")
    let r2 = Rope.insert(r1, 5, " world")
    let r3 = Rope.insert(r2, 5, " wicked")
    let r4 = Rope.insert(r3, 0, "well, ")
    let r5 = Rope.insert(r4, 24, ".")

    println(Rope.show(r5))
    println(Rope.length'(r5))
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

    List.each(fun(testFun) = testFun(), tests)
  }
}
