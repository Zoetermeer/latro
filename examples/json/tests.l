import Core
import Core.List
import JsonLexer
import Parser

quote : String -> String
quote(s) = ['"'] ++ s ++ ['"']

main(_) = {
  IO.println(read("{}"))
  IO.println(read(quote("hello")))
  IO.println(read("[,]{?"))

  IO.println(parse("[" ++ quote("hello") ++ "]"))
}
