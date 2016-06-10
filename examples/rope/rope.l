//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope

module Rope {
  type t =
    | Leaf(String.t)
    | Node(Int, t, t)


  length' => fun(t) : Int
  fun length'(Leaf(string))       = List.length(string)
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
    def weight      = List.length(List.append(s1, s2))

    Node(weight, Leaf(s1), Leaf(s2))
  }

  fun delete(Node(weight, left, right), i, j) {
    def llen  = length'(left)
    def w     = weight - (j - i)

    cond {
      case Core.gt(i, j)                                  -> Node(weight, left, right)
      case Core.and(Core.lt(i, llen), Core.lt(j, llen))   -> Node(w, delete(left, i, j), right)
      case Core.and(Core.lt(i, llen), Core.geq(j, llen))  -> Node(w, delete(left, i, llen), delete(right, 0, j - llen))
      case Core.geq(i, llen)                              -> Node(w, left, delete(right, i - llen, j - llen))
    }
  }


  index => fun(t, Int) : Core.Maybe<Char>
  fun index(Leaf(string), n) = List.atIndex(string, n)
  fun index(Node(weight, left, right), n) {
    cond {
      case Core.lt(n, length'(left))  -> index(left, n)
      case _                          -> index(right, n - length'(left))
    }
  }


  insert => fun(t, Int, String.t) : t
  fun insert(Leaf(oldString), n, newString) {
    def %(s1, s3) = oldString.splitAt(n)
    def s2        = newString
    def w1        = List.length(List.append(List.append(s1, s2), s3))
    def w2        = List.length(List.append(s1, s2))

    Node(w1, Node(w2, Leaf(s1), Leaf(s2)), Leaf(s3))
  }

  fun insert(Node(weight, left, right), n, string) {
    def w1 = weight + List.length(string)
    def w2 = length'(right) + List.length(string)

    cond {
      case Core.lt(n, length'(left))  -> Node(w1, insert(left, n, string), right)
      case Core.gt(n, length'(left))  -> Node(w1, left, insert(right, n - length'(left), string))
      case _                          -> Node(w1, left, Node(w2, Leaf(string), right))
    }
  }


  substring => fun(t, Int, Int) : Core.Maybe<String.t>
  fun substring(Leaf(string), i, j) {
    def %(_, tmp) = string.splitAt(i)
    def %(s, _)   = tmp.splitAt(j - i)

    Core.Just(s)
  }

  fun substring(Node(_, left, right), i, j) {
    def llen = length'(left)

    cond {
      case Core.gt(i, j)                                  -> Core.Nothing()
      case Core.and(Core.lt(i, llen), Core.geq(j, llen))  -> substring(left, i, j)
      case Core.geq(i, llen)                              -> substring(right, i - llen, j - llen)
    }
  }


  toString => fun(t) : String.t
  fun toString(Leaf(string)) = string
  fun toString(Node(_, left, right)) = List.append(toString(left), toString(right))
}

def leaf = Rope.Leaf("hello")
Rope.delete(leaf, 1, 4)
