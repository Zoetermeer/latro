module Json.Token {
  import Core
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


  accept : Token -> String -> Result<String, %(Token, String)>
  accept(tok, rest) = Ok(%(tok, rest))


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


  lex([]) = Ok(%(Eof(), ""))
  lex(c @ cs) = {
    switch (c) {
      '{' -> accept(LBrace(), cs)
      '}' -> accept(RBrace(), cs)
      ',' -> accept(Comma(), cs)
      '[' -> accept(LBracket(), cs)
      ']' -> accept(RBracket(), cs)
      '"' -> lexStr(cs)
      _   -> Error("Invalid token '" ++ [c] ++ "'.")
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
