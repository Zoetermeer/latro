protocol Object on a { }

type String = Char[]

imp Int : Object { }
imp String : Object { }

imp a[] : Object { }

main(_) = {
  prim(println)("it works")
}
