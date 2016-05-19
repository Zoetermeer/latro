def Core = module {
  type Maybe<a> =
    | Some a
    | None
    ;
};

def Map = module {
  type t<k, v> = (k, v)[];

  insert<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  insert(map, key, val) { (key, val) :: map; };

  find<k, v> => fun(t<k, v>, k) : Core.Maybe<v>;
  find(_, _) { Core.None(); };
};

def m = [(1, "hello")];
Map.find(m, 3);
