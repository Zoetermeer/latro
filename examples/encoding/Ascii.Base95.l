module Ascii.Base95 {
  import Core
  import Core.Char = Char (toInt)
  import Core.List (reverse)

  type Exp = Int

  decode : String -> Exp -> Int
  decode("", _) = 0
  decode(c @ cs, exp) = {
    let code = Char.toInt(c) - 32
    code * (95 ** exp) + decode(cs, exp + 1)
  }

  atoi : String -> Int
  atoi(str) = decode(reverse(str), 0)
}
