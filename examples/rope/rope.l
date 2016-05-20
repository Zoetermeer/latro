//This is a transliteration of Pat Brown's
//Haskell Rope implementation:
//https://github.com/ptrckbrwn/rope
def Core = module {
  type String = Char[];
  type Maybe<a> =
    | Just a
    | Nothing
    ;
};

lt => fun(Int, Int) : Bool;
lt(0, 0) { False; }
lt(0, _) { True; }
lt(_, 0) { False; }
lt(a, b) {
  lt(a - 1, b - 1);
};

leq => fun(Int, Int) : Bool;
leq(0, 0) { True; }
leq(0, _) { True; }
leq(_, 0) { False; }
leq(a, b) {
  leq(a - 1, b - 1);
};

def gt = fun(a, b) { !(leq(a, b)); };
def geq = fun(a, b) { !(lt(a, b)); };

and => fun(Bool, Bool) : Bool;
and(True, True) { True; }
and(True, _) { False; }
and(_, _) { False; };

def List = module {
  length<a> => fun(a[]) : Int;
  length([]) { 0; }
  length(x::xs) { 1 + length(xs); };

  append<a> => fun(a[], a[]) : a[];
  append([], bs) { bs; }
  append(as, []) { as; }
  append(a::as, bs) {
    a :: append(as, bs);
  };

  elem<a> => fun(a[], Int) : Core.Maybe<a>;
  elem([], _) { Core.Nothing(); }
  elem(x::_, 0) { Core.Just(x); }
  elem(_::xs, n) { elem(xs, n - 1); };
};

def Str = module {
  splitAt => fun(Core.String, Int) : (Core.String, Core.String);
  splitAt(s, 0) { (s, ""); }
  splitAt("", _) { ("", ""); }
  splitAt(c::cs, 1) { ([c], cs); }
  splitAt(c::cs, n) {
    def (a, b) = splitAt(cs, n - 1);
    (c :: a, b);
  };
};


type Rope =
  | Leaf Core.String
  | Node Int Rope Rope
  ;


length' => fun(Rope) : Int;
length'(Leaf(string)) { List.length(string); }
length'(Node(weight, _, _)) { weight; };


concat' => fun(Rope, Rope) : Rope;
concat'(r1, r2) {
  def weight = length'(r1) + length'(r2);
  Node(weight, r1, r2);
};


delete => fun(Rope, Int, Int) : Rope;
delete(Leaf(string), i, j) {
  def (s1, tmp) = Str.splitAt(string, i);
  def (_, s2)   = Str.splitAt(tmp, j - i);
  def weight    = List.length(List.append(s1, s2));

  Node(weight, Leaf(s1), Leaf(s2));
}

delete(Node(weight, left, right), i, j) {
  def llen = length'(left);
  def w = weight - (j - i);

  cond {
    case gt(i, j)                         -> Node(weight, left, right);
    case and(lt(i, llen), lt(j, llen))    -> Node(w, delete(left, i, j), right);
    case and(lt(i, llen), geq(j, llen))   -> Node(w, delete(left, i, llen), delete(right, 0, j - llen));
    case geq(i, llen)                     -> Node(w, left, delete(right, i - llen, j - llen));
  };
};


index => fun(Rope, Int) : Core.Maybe<Char>;
index(Leaf(string), n) { List.elem(string, n); }
index(Node(weight, left, right), n) {
  cond {
    case lt(n, length'(left)) -> index(left, n);
    case _                    -> index(right, n - length'(left));
  };
};


insert => fun(Rope, Int, Core.String) : Rope;
insert(Leaf(oldString), n, newString) {
  def (s1, s3) = Str.splitAt(oldString, n);
  def s2       = newString;
  def w1       = List.length(List.append(List.append(s1, s2), s3));
  def w2       = List.length(List.append(s1, s2));

  Node(w1, Node(w2, Leaf(s1), Leaf(s2)), Leaf(s3));
}

insert(Node(weight, left, right), n, string) {
  def w1 = weight + List.length(string);
  def w2 = length'(right) + List.length(string);

  cond {
    case lt(n, length'(left)) -> Node(w1, insert(left, n, string), right);
    case gt(n, length'(left)) -> Node(w1, left, insert(right, n - length'(left), string));
    case _                    -> Node(w1, left, Node(w2, Leaf(string), right));
  };
};


substring => fun(Rope, Int, Int) : Core.Maybe<Core.String>;
substring(Leaf(string), i, j) {
  def (_, tmp) = Str.splitAt(string, i);
  def (s, _)   = Str.splitAt(tmp, j - i);

  Core.Just(s);
}

substring(Node(_, left, right), i, j) {
  def llen = length'(left);

  cond {
    case gt(i, j)                         -> Core.Nothing();
    case and(lt(i, llen), geq(j, llen))   -> substring(left, i, j);
    case geq(i, llen)                     -> substring(right, i - llen, j - llen);
  };
};


toString => fun(Rope) : Core.String;
toString(Leaf(string)) { string; }
toString(Node(_, left, right)) { List.append(toString(left), toString(right)); };

def leaf = Leaf("hello");
delete(leaf, 1, 4);
