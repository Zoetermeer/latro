module Json.Tests.Repl {
  import Core
  import IO
  import Json.Value

  repl() =
    readln()
    |> parse
    |> println
    |> fun(u) = repl()

  main(_) = repl()
}
