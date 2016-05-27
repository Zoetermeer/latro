module List {
  fun len([]) = 0;
  fun len(x::xs) = 1 + len(xs);

  fun append([], b) = b;
  fun append(a, []) = a;
  fun append(a::as, bs) = a :: append(as, bs);

  fun map(_, []) = [];
  fun map(f, x::xs) = f(x) :: map(f, xs);
};

module String {
  type String = Char[];
  def concat = fun(s1, s2) { List.append(s1, s2); };
};

fun weird('l') = 'w';
fun weird(c) = c;

List.map(weird, String.concat("hello ", "world"));
