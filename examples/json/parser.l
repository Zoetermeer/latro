module Json.Value {
  import Core
  import Core.Result
  import Core.Result.Monadic
  import Json
  import Json.Token = Token

  type Field = %(String, Value)

  type | Object(Field[])
       | Array(Value[])
       | String(String)
       | Number(Int)
       | Bool(Bool)
       | Null


  parseObject(ts) = Error("not implemented")


  parseArray(ts) = {
    let rv = parseValue(ts)
    switch (rv) {
      Ok(%(value, t @ ts')) -> {
        switch (t) {
          Token.RBracket -> Ok(%(Array([value]), ts'))
          _              -> Error("Expected ']'")
        }
      }
      _ -> Error("Invalid array element")
    }
  }


  parseValue : Token[] -> Result<String, %(Value, Token[])>
  parseValue([]) = Ok(%(Null(), []))
  parseValue(t @ ts) = {
    switch (t) {
      Token.LBrace     -> parseObject(ts)
      Token.LBracket   -> parseArray(ts)
      Token.String(s)  -> Ok(%(String(s), ts))
      Token.Number(n)  -> Ok(%(Number(n), ts))
      Token.NullLit    -> Ok(%(Null(), ts))
    }
  }


  parse : String -> Result<String, Value>
  parse(input) = {
    Token.read(input)   >>= fun(tokens) =
    parseValue(tokens)  >>= fun(rv) = {
      let %(value, tokens') = rv
      return(value)
    }
  }
}
