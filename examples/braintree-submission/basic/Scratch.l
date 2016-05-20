type String = Char[];

append<a> => fun(a[], a[]) : a[];
append([], bs) { bs; }
append(as, []) { as; }
append(a::as, bs) {
  a :: append(as, bs);
};

reverse<a> => fun(a[]) : a[];
reverse([]) { []; }
reverse(x::xs) {
  append(reverse(xs), [x]);
};

words => fun(String, String) : String[];
words("", s) { [reverse(s)]; }
words(c::cs, s) {
  switch ([c]) {
    case " " -> reverse(s) :: words(cs, "");
    case _ -> words(cs, c :: s);
  };
};

words("Add James 1 100", "");
