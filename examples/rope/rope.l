//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope
import Core
import Core.List

module Rope {
  type Rope =
    | Leaf(String)
    | Node(Int, Rope, Rope)

  fun (Leaf(string)).length'() = List.length(string)
  fun (Node(weight, _, _)).length'() = weight


  concat' => fun(Rope, Rope) : Rope
  fun concat'(r1, r2) {
    def weight = r1.length'() + r2.length'()
    Node(weight, r1, r2)
  }


  delete => fun(Rope, Int, Int) : Rope
  fun delete(Leaf(string), i, j) {
    def %(s1, tmp)  = string.splitAt(i)
    def %(_, s2)    = tmp.splitAt(j - i)
    def weight      = List.length(s1 @ s2)

    Node(weight, Leaf(s1), Leaf(s2))
  }

  fun delete(Node(weight, left, right), i, j) {
    def llen  = left.length'()
    def w     = weight - (j - i)

    cond {
      case i > j                      -> Node(weight, left, right)
      case i < llen && j < llen       -> Node(w, delete(left, i, j), right)
      case i < llen && j >= llen      -> Node(w, delete(left, i, llen), delete(right, 0, j - llen))
      case i >= llen                  -> Node(w, left, delete(right, i - llen, j - llen))
    }
  }


  index => fun(Rope, Int) : Maybe{Char}
  fun index(Leaf(string), n) = string.at-index(n)
  fun index(Node(weight, left, right), n) {
    cond {
      case n < left.length'() -> index(left, n)
      case _                  -> index(right, n - left.length'())
    }
  }


  insert => fun(Rope, Int, String) : Rope
  fun insert(Leaf(oldString), n, newString) {
    def %(s1, s3) = oldString.splitAt(n)
    def s2        = newString
    def w1        = List.length(s1 @ s2 @ s3)
    def w2        = List.length(s1 @ s2)

    Node(w1, Node(w2, Leaf(s1), Leaf(s2)), Leaf(s3))
  }

  fun insert(Node(_, left, right), n, string) {
    def llen = left.length'()
    cond {
      case n < llen -> concat'(insert(left, n, string), right)
      case n > llen -> concat'(left, insert(right, n - llen, string))
      case _        -> concat'(left, concat'(Leaf(string), right))
    }
  }


  substring => fun(Rope, Int, Int) : Maybe{String}
  fun substring(Leaf(str), i, j) {
    def %(_, tmp) = str.splitAt(i)
    def %(s, _)   = tmp.splitAt(j - i)

    Just(s)
  }

  fun substring(Node(_, left, right), i, j) {
    def llen = left.length'()

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
