module Json.Tests {
  import Core
  import Core.List
  import IO
  import Json
  import Json.Token = Token
  import Json.Value

  quote : String -> String
  quote(s) = ['"'] ++ s ++ ['"']

  main(_) = {
    println(Token.read("{}"))
    println(Token.read(quote("hello")))
    println(Token.read("[,]{?"))

    println(Token.read("42"))

    println(parse("[" ++ quote("hello") ++ "]"))
    println(parse("[42, 43, 44]"))

    println(parse("{" ++ quote("name") ++ ":" ++ quote("james") ++ "}"))

    let json = "{"
               ++ quote("name") ++ ":" ++ "42, "
               ++ quote("items") ++ ":" ++ "[" ++ quote("foo") ++ ", " ++ quote("bar") ++ "]"
               ++ "}"
    println(parse(json)) 
  }
}
