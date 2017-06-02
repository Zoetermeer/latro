module Json.Tests.Repl {
  import Core
  import IO
  import Json
  import Json.Value

  repl() =
    IO.readln()
    |> parse
    |> IO.println
    |> fun(u) = repl()

  main(_) = {
    repl() 
  }
}
