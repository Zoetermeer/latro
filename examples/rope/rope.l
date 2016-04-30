//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope
def Rope = module {
  type Rope =
    | Leaf String
    | Node Int Rope Rope
    ;


  concat' => fun(Rope, Rope) : Rope;
  concat'(r1, r2) {
    def weight = length'(r1) + length'(r2);
    Node(weight, r1, r2);
  };


  delete => fun(Rope, Int, Int) : Rope;
  delete(Leaf(string), i, j) {
    def (s1, tmp) = string.splitAt(i);
    def (_, s2)   = tmp.splitAt(j - i);
    def weight    = String.append(s1, s2).length();

    Node(weight, Leaf(s1), Leaf(s2));
  }

  delete(Node(weight, left, right), i, j) {
    def llen = length' left
    def w = weight - (j - i);

    cond {
      case i > j                  -> error "Cannot delete a negative range";
      case i < llen && j < llen   -> Node(w, delete(left, i, j), right);
      case i < llen && j >= llen  -> Node(w, delete(left, i, llen), delete(right, 0, j - llen));
      case i >= llen              -> Node(w, left, delete(right, i - llen, j - llen));
    };
  };


  index => fun(Rope, Int) : Char;
  index(Leaf(string), n) { string[n]; }
  index(Node(weight, left, right), n) {
    cond {
      case n < length'(left)  -> index(left, n);
      case _                  -> index(right, n - length'(left));
    };
  };


  insert => fun(Rope, Int, String) : Rope
  insert(Leaf(oldString), n, newString) {
    def (s1, s3) = oldString.splitAt(n);
    def s2       = newString;
    def w1       = length(String.concat([s1, s2, s3]));
    def w2       = length(String.append(s1, s2));

    Node(w1, Node(w2, Leaf(s1), Leaf(s2)), Leaf(s3));
  }

  insert(Node(weight, left, right), n, string) {
    def w1 = weight + string.length();
    def w2 = length'(right) + string.length();

    cond {
      case n < length'(left)  -> Node(w1, insert(left, n, string), right);
      case n > length'(left)  -> Node(w1, left, insert(right, n - length'(left), string));
      case _                  -> Node(w1, left, Node(w2, Leaf(string), right));
    };
  };


  length' => fun(Rope) : Int
  length'(Leaf(string)) { string.length(); }
  length'(Node(weight, _, _)) { weight; };


  substring => fun(Rope, Int, Int) : String;
  substring(Leaf(string), i, j) {
    def (_, tmp) = string.splitAt(i);
    def (s, _) = tmp.splitAt(j - i);

    s;
  }

  substring(Node(_, left, right), i, j) {
    def llen = length'(left);

    cond {
      case i > j -> error "Cannot substring a negative range";
      case i < llen && j >= llen -> substring(left, i, j);
      case i < llen && j >= llen -> String.append(substring(left, i, llen), substring(right, 0, j - llen));
      case i >= llen -> substring(right, i - llen, j - llen);
    };
  };


  toString => fun(Rope)() : String;
  (Leaf(string)).toString() { string; }
  (Node(_, left, right)).toString() { String.append(toString(left), toString(right)); };
};
