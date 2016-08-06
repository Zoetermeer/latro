module Result {
  module MonadInfix {
    @(>>=)(Ok(x), f) = f(x)
    @(>>=)(Error(e), _)   = Error(e)

    return(x) = Ok(x)
  }
}

module JsonLexer {
  import Core
  import Core.List
  import Result.MonadInfix


  type Tok =
    | TokLBrace
    | TokRBrace
    | TokComma
    | TokLBracket
    | TokRBracket
    | TokString(String)
    | TokNumber(Int)
    | TokTrue
    | TokFalse
    | TokNull
    | TokEof


  lexStr/private : String -> Result{String, %(String, String)}
  lexStr/private("") = Error("Unterminated string constant.")
  lexStr/private('"' :: cs) = Ok(%("", cs))
  lexStr/private(c :: cs) =
    lexStr/private(cs) >>= fun(answer) = {
      def %(str, inputRest) = answer
      Ok(%(c :: str, inputRest))
    }


  lexStr : String -> Result{String, %(Tok, String)}
  lexStr(input) =
    lexStr/private(input) >>= fun(answer) = {
      def %(strContents, rest) = answer
      Ok(%(TokString(strContents), rest))
    }


  lex([]) = Ok(%(TokEof(), ""))
  lex(c :: cs) = {
    switch (c) {
      '{' -> Ok(%(TokLBrace(), cs))
      '}' -> Ok(%(TokRBrace(), cs))
      ',' -> Ok(%(TokComma(), cs))
      '[' -> Ok(%(TokLBracket(), cs))
      ']' -> Ok(%(TokRBracket(), cs))
      '"' -> lexStr(cs)
      _   -> Error("Invalid token '" ++ [c] ++ "'.")
    }
  }


  read : String -> Result{String, Tok[]}
  read(input) = {
    lex(input) >>= fun(answer) = {
      def %(token, input') = answer
      switch (token) {
        TokEof() -> Ok([])
        _        ->
          read(input') >>= fun(toks) = Ok(token :: toks)
      }
    }
  }
}
