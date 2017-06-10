module Program {
  import Ascii.Base95 {
    renaming (atoi -> base95atoi)
  }
  import Core
  import Core.List = List (each)
  import IO (println)

  main(_) = {
    let inputs = [
      " ",
      " !",
      "!!",
      "{!",
      "!a!$!!Z!{!" 
    ]

    List.each(base95atoi >> println, inputs)
  }
}
