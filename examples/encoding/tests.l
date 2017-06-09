module Program {
  import Ascii.Base95 {
    renaming (atoi -> base95atoi)
  }
  import IO (println)

  main(_) = {
    println(base95atoi(" "))
    println(base95atoi(" !"))
    println(base95atoi("!!"))
    println(base95atoi("{!"))
  }
}
