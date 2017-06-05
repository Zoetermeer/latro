module Json.Tests.Repl {
  import Core
  import IO.(readln, print, println).{
    except(readln, print)
    renaming(println -> printLine)
  }

  import IO.{
    except(readln, print)
    renaming(println -> printLine)
  }

  import Json.Value.(parse)

  repl() =
    readln()
    |> parse
    |> println
    |> fun(u) = repl()

  main(_) = repl()
}
