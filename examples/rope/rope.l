//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope
import Core
import Core::List

module Rope {
  type Rope =
    | Leaf(String)
    | Node(Int, Rope, Rope)

  length' : Rope -> Int
  length'(Leaf(string)) = length(string)
  length'(Node(weight, _, _)) = weight


  concat' : Rope -> Rope -> Rope
  concat'(r1, r2) = {
    let weight = length'(r1) + length'(r2)
    Node(weight, r1, r2)
  }


  delete : Rope -> Int -> Int -> Rope
  delete(Leaf(string), i, j) = {
    let %(s1, tmp)  = Core::String::splitAt(string, i)
    let %(_, s2)    = Core::String::splitAt(tmp, j - i)
    let weight      = length(s1 ++ s2)

    Node(weight, Leaf(s1), Leaf(s2))
  }

  delete(Node(weight, left, right), i, j) = {
    let llen  = length'(left)
    let w     = weight - (j - i)

    cond {
      i > j                      -> Node(weight, left, right)
      i < llen && j < llen       -> Node(w, delete(left, i, j), right)
      i < llen && j >= llen      -> Node(w, delete(left, i, llen), delete(right, 0, j - llen))
      i >= llen                  -> Node(w, left, delete(right, i - llen, j - llen))
    }
  }


  index : Rope -> Int -> Maybe<Char>
  index(Leaf(string), n) = atIndex(string, n)
  index(Node(weight, left, right), n) = {
    cond {
      n < length'(left)  -> index(left, n)
      _                  -> index(right, n - length'(left))
    }
  }


  insert : Rope -> Int -> String -> Rope
  insert(Leaf(oldString), n, newString) = {
    let %(s1, s3) = Core::String::splitAt(oldString, n)
    let s2        = newString
    let w1        = length(s1 ++ s2 ++ s3)
    let w2        = length(s1 ++ s2)

    Node(w1, Node(w2, Leaf(s1), Leaf(s2)), Leaf(s3))
  }

  insert(Node(_, left, right), n, string) = {
    let llen = length'(left)
    cond {
      n < llen -> concat'(insert(left, n, string), right)
      n > llen -> concat'(left, insert(right, n - llen, string))
      _        -> concat'(left, concat'(Leaf(string), right))
    }
  }


  substring : Rope -> Int -> Int -> Maybe<String>
  substring(Leaf(str), i, j) = {
    let %(_, tmp) = Core::String::splitAt(str, i)
    let %(s, _)   = Core::String::splitAt(tmp, j - i)

    Core::Maybe::Just(s)
  }

  substring(Node(_, left, right), i, j) = {
    let llen = length'(left)

    cond {
      i > j                      -> Core::Maybe::Nothing()
      i < llen && j >= llen      -> substring(left, i, j)
      i >= llen                  -> substring(right, i - llen, j - llen)
    }
  }


  show : Rope -> String
  show(Leaf(string)) = string
  show(Node(_, left, right)) = show(left) ++ show(right)
}
