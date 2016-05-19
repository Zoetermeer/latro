def List = module {
  len<a> => fun(a[]) : Int;
  len([]) { 0; }
  len(x::xs) { 1 + len(xs); };

  append<a> => fun(a[], a[]) : a[];
  append([], b) { b; }
  append(a, []) { a; }
  append(a::as, bs) { a :: append(as, bs); };

  map<a, b> => fun(fun(a) : b, a[]) : b[];
  map(_, []) { []; }
  map(f, x::xs) { f(x) :: map(f, xs); };
};

def String = module {
  type String = Char[];

  def concat = fun(s1, s2) { List.append(s1, s2); };
};

def weird = fun(c) {
  switch (c) {
    case 'l' -> 'w';
    case _ -> c;
  };
};

List.map(weird, String.concat("hello ", "world"));
