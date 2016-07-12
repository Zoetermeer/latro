//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope

module Rope {
  import Core
  import Core.List

  type t =
    | Leaf(String)
    | Node(Int, t, t)


  length' => fun(t) : Int
  fun length'(Leaf(string))       = length(string)
  fun length'(Node(weight, _, _)) = weight


  concat' => fun(t, t) : t
  fun concat'(r1, r2) {
    def weight = length'(r1) + length'(r2)
    Node(weight, r1, r2)
  }


  delete => fun(t, Int, Int) : t
  fun delete(Leaf(string), i, j) {
    def %(s1, tmp)  = string.splitAt(i)
    def %(_, s2)    = tmp.splitAt(j - i)
    def weight      = length(s1 @ s2)

    Node(weight, Leaf(s1), Leaf(s2))
  }

  fun delete(Node(weight, left, right), i, j) {
    def llen  = length'(left)
    def w     = weight - (j - i)

    cond {
      case i > j                      -> Node(weight, left, right)
      case i < llen && j < llen       -> Node(w, delete(left, i, j), right)
      case i < llen && j >= llen      -> Node(w, delete(left, i, llen), delete(right, 0, j - llen))
      case i >= llen                  -> Node(w, left, delete(right, i - llen, j - llen))
    }
  }


  index => fun(t, Int) : Maybe{Char}
  fun index(Leaf(string), n) = string.at-index(n)
  fun index(Node(weight, left, right), n) {
    cond {
      case n < length'(left) -> index(left, n)
      case _                 -> index(right, n - length'(left))
    }
  }


  insert => fun(t, Int, String) : t
  fun insert(Leaf(oldString), n, newString) {
    def %(s1, s3) = oldString.splitAt(n)
    def s2        = newString
    def w1        = length(s1 @ s2 @ s3)
    def w2        = length(s1 @ s2)

    Node(w1, Node(w2, Leaf(s1), Leaf(s2)), Leaf(s3))
  }

  fun insert(Node(_, left, right), n, string) {
    def llen = length'(left)
    cond {
      case n < llen -> concat'(insert(left, n, string), right)
      case n > llen -> concat'(left, insert(right, n - llen, string))
      case _        -> concat'(left, concat'(Leaf(string), right))
    }
  }


  substring => fun(t, Int, Int) : Maybe{String}
  fun substring(Leaf(str), i, j) {
    def %(_, tmp) = str.splitAt(i)
    def %(s, _)   = tmp.splitAt(j - i)

    Just(s)
  }

  fun substring(Node(_, left, right), i, j) {
    def llen = length'(left)

    cond {
      case i > j                      -> Nothing()
      case i < llen && j >= llen      -> substring(left, i, j)
      case i >= llen                  -> substring(right, i - llen, j - llen)
    }
  }


  fun (Leaf(string)).show() = string
  fun (Node(_, left, right)).show() =
    left.show() @ right.show()
}


//Tests
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
  IO.println(length'(r5))
}

itWrapsTwoRopesByASingleNode()
itDeletesRangeForLeaf()
itReturnsTheCharAtIndex()
itInsertsTheStringAtIndexForLeaf()
itInsertsTheStringAtIndexForNode()
stressTests()
