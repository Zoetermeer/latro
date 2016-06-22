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

  fun insert(Node(weight, left, right), n, string) {
    def w1 = weight + length(string)
    def w2 = length'(right) + length(string)

    cond {
      case n < length'(left) -> Node(w1, insert(left, n, string), right)
      case n > length'(left) -> Node(w1, left, insert(right, n - length'(left), string))
      case _                 -> Node(w1, left, Node(w2, Leaf(string), right))
    }
  }


  substring => fun(t, Int, Int) : Maybe{String}
  fun substring(Leaf(string), i, j) {
    def %(_, tmp) = string.splitAt(i)
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

import Rope

def rope = Node(11, Leaf("hello "), Leaf("world"))
delete(rope, 4, 7).show()
