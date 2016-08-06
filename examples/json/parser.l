module Result {
  module MonadInfix {
    @(>>=)(Ok(x), f) = f(x)
    @(>>=)(Error(e), _)   = Error(e)

    return(x) = Ok(x)
  }
}

module Parser {
  import Core
  import JsonLexer
  import Result.MonadInfix

  type Field = %(String, Value)

  type Value =
    | JsonObject(Field[])
    | JsonArray(Value[])
    | JsonString(String)
    | JsonNumber(Int)
    | JsonBool(Bool)
    | JsonNull


  parseArray(ts) = {
    def rv = parseValue(ts)
    switch (rv) {
      Ok(%(value, t :: ts')) -> {
        switch (t) {
          TokRBracket() -> Ok(%(JsonArray([value]), ts'))
          _ -> Error("Expected ']'")
        }
      }
      _ -> Error("Invalid array element")
    }
  }


  parseValue : Tok[] -> Result{String, %(Value, Tok[])}
  parseValue([]) = Ok(%(JsonNull(), []))
  parseValue(t :: ts) = {
    switch (t) {
      TokLBracket() -> parseArray(ts)
      TokString(s)  -> Ok(%(JsonString(s), ts))
      TokNull       -> Ok(%(JsonNull(), ts))
    }
  }


  parse : String -> Result{String, Value}
  parse(input) = {
    read(input)         >>= fun(tokens) =
    parseValue(tokens)  >>= fun(rv) = {
      def %(value, tokens') = rv
      return(value)
    }
  }
}
