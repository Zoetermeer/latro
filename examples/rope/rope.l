//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope

type String = Char[]
type Maybe<a> =
  | Just(a)
  | Nothing

fun lt(0, 0) = False
fun lt(0, _) = True
fun lt(_, 0) = False
fun lt(a, b) {
  lt(a - 1, b - 1)
}

fun leq(0, 0) = True
fun leq(0, _) = True
fun leq(_, 0) = False
fun leq(a, b) {
  leq(a - 1, b - 1)
}

fun gt(a, b) = !leq(a, b)
fun geq(a, b) { !(lt(a, b)) }

fun and(True, True) = True
fun and(True, _)    = False
fun and(_, _)       = False

module List {
  fun length([])    = 0
  fun length(x::xs) = 1 + length(xs)

  fun append([], bs)    = bs
  fun append(as, [])    = as
  fun append(a::as, bs) = a :: append(as, bs)

  fun atIndex([], _)    = Nothing()
  fun atIndex(x::_, 0)  = Just(x)
  fun atIndex(_::xs, n) = atIndex(xs, n - 1)
}

fun (s).splitAt(0)      = %(s, "")
fun ("").splitAt(_)     = %("", "")
fun (c::cs).splitAt(1)  = %([c], cs)
fun (c::cs).splitAt(n) {
  def %(a, b) = cs.splitAt(n - 1)
  %(c :: a, b)
}

type Rope =
  | Leaf(String)
  | Node(Int, Rope, Rope)


length' => fun(Rope) : Int
fun length'(Leaf(string))       = List.length(string)
fun length'(Node(weight, _, _)) = weight


concat' => fun(Rope, Rope) : Rope
fun concat'(r1, r2) {
  def weight = length'(r1) + length'(r2)
  Node(weight, r1, r2)
}


delete => fun(Rope, Int, Int) : Rope
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
    case gt(i, j)                         -> Node(weight, left, right)
    case and(lt(i, llen), lt(j, llen))    -> Node(w, delete(left, i, j), right)
    case and(lt(i, llen), geq(j, llen))   -> Node(w, delete(left, i, llen), delete(right, 0, j - llen))
    case geq(i, llen)                     -> Node(w, left, delete(right, i - llen, j - llen))
  }
}


index => fun(Rope, Int) : Maybe<Char>
fun index(Leaf(string), n) = List.atIndex(string, n)
fun index(Node(weight, left, right), n) {
  cond {
    case lt(n, length'(left)) -> index(left, n)
    case _                    -> index(right, n - length'(left))
  }
}


insert => fun(Rope, Int, String) : Rope
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
    case lt(n, length'(left)) -> Node(w1, insert(left, n, string), right)
    case gt(n, length'(left)) -> Node(w1, left, insert(right, n - length'(left), string))
    case _                    -> Node(w1, left, Node(w2, Leaf(string), right))
  }
}


substring => fun(Rope, Int, Int) : Maybe<String>
fun substring(Leaf(string), i, j) {
  def %(_, tmp) = string.splitAt(i)
  def %(s, _)   = tmp.splitAt(j - i)

  Just(s)
}

fun substring(Node(_, left, right), i, j) {
  def llen = length'(left)

  cond {
    case gt(i, j)                         -> Nothing()
    case and(lt(i, llen), geq(j, llen))   -> substring(left, i, j)
    case geq(i, llen)                     -> substring(right, i - llen, j - llen)
  }
}


toString => fun(Rope) : String
fun toString(Leaf(string)) = string
fun toString(Node(_, left, right)) = List.append(toString(left), toString(right))

def leaf = Leaf("hello")
delete(leaf, 1, 4)
