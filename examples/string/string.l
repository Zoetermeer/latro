def List = module {
  def len = fun(xs) {
    switch (xs) {
      case [] -> 0;
      case x::xs -> 1 + len(xs);
    };
  };

  def append = fun(a, b) {
    switch ((a, b)) {
      case ([], b) -> b;
      case (a, []) -> a;
      case (a::as, bs) -> a :: append(as, bs);
    };
  };

  def map = fun(f, xs) {
    switch(xs) {
      case [] -> [];
      case x::xs -> f(x) :: map(f, xs);
    };
  };
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
