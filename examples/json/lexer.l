module Json.Token {
  import Core
  import Core.Char = Char
  import Core.Int = Int
  import Core.List
  import Core.Result
  import Core.Result.Monadic
  import Json


  type | LBrace
       | RBrace
       | Comma
       | LBracket
       | RBracket
       | String(String)
       | Number(Int)
       | TrueLit
       | FalseLit
       | NullLit
       | Eof


  accept<a> : a -> String -> Result<String, %(a, String)>
  accept(v, rest) = Ok(%(v, rest))


  lexStr/private : String -> Result<String, %(String, String)>
  lexStr/private("") = Error("Unterminated string constant.")
  lexStr/private('"' @ cs) = Ok(%("", cs))
  lexStr/private(c @ cs) =
    lexStr/private(cs) >>= fun(answer) = {
      let %(str, inputRest) = answer
      Ok(%(c @ str, inputRest))
    }


  lexStr : String -> Result<String, %(Token, String)>
  lexStr(input) =
    lexStr/private(input) >>= fun(answer) = {
      let %(strContents, rest) = answer
      accept(String(strContents), rest)
    }


  lexNum/priv : String -> Result<String, %(String, String)>
  lexNum/priv("") = accept("", [])
  lexNum/priv(c @ cs) = cond {
    Char.isDigit(c) -> {
      lexNum/priv(cs) >>= fun(answer) = {
        let %(restOfStr, inputRest) = answer
        accept(c @ restOfStr, inputRest)
      }
    }
    _ -> accept("", c @ cs)
  }


  lexNum : String -> Result<String, %(Token, String)>
  lexNum(input) = {
    lexNum/priv(input) >>= fun(answer) = {
      let %(numStr, inputRest) = answer
      accept(Number(Int.unsafeRead(numStr)), inputRest)
    }
  }


  lex([]) = Ok(%(Eof(), ""))
  lex(c @ cs) = {
    switch (c) {
      ' ' -> lex(cs)
      '{' -> accept(LBrace(), cs)
      '}' -> accept(RBrace(), cs)
      ',' -> accept(Comma(), cs)
      '[' -> accept(LBracket(), cs)
      ']' -> accept(RBracket(), cs)
      '"' -> lexStr(cs)
      _   -> cond {
        Char.isDigit(c) -> lexNum(c @ cs)
        _               -> Error("Invalid token '" ++ [c] ++ "'.")
      }
    }
  }


  read : String -> Result<String, Token[]>
  read(input) = {
    lex(input) >>= fun(answer) = {
      let %(token, input') = answer
      switch (token) {
        Eof -> Ok([])
        _   ->
          read(input') >>= fun(toks) = Ok(token @ toks)
      }
    }
  }
}
