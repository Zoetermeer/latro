aboutThisNumber : Int -> String
aboutThisNumber(x) =
  if (x < 5) {
    "it's less than 5"
  } else {
    "it's greater than or equal to 5"
  }

moreAboutThisNumber : Int -> String
moreAboutThisNumber(x) =
  cond {
    x < 5 -> "it's less than 5"
    x > 5 -> "it's greater than 5"
    _     -> "it's 5"
  }

main(_) {
  IO.println(aboutThisNumber(5))
  IO.println(moreAboutThisNumber(5))
  IO.println(moreAboutThisNumber(4))
}
