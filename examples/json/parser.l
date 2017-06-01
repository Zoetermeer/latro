module Json.Value {
  import Core
  import Core.Result
  import Core.Result.Monadic
  import Json
  import Json.Token = Token

  type Field = %(String, Value)

  mkField(name, value) = %(name, value)

  type | Object(Field[])
       | Array(Value[])
       | String(String)
       | Number(Int)
       | Bool(Bool)
       | Null

  accept<a> : a -> Token[] -> Result<String, %(a, Token[])>
  accept(v, rest) = Ok(%(v, rest))


  parseFields(Token.String(fieldName) @ Token.Colon @ valueTokens) = {
    parseValue(valueTokens) >>= fun(rv) = {
      let %(value, tokens') = rv
      let field = mkField(fieldName, value)
      switch (tokens') {
        Token.Comma @ tokens'' -> {
          parseFields(tokens'') >>= fun(rv') = {
            let %(fields, tokens''') = rv'
            accept(field @ fields, tokens''')
          }
        }
        _ -> accept([field], tokens')
      }
    }
  }


  parseObject(Token.LBrace @ ts) = {
    parseFields(ts) >>= fun(rv) = {
      let %(fields, tokens') = rv
      switch (tokens') {
        Token.RBrace @ tokens'' -> accept(Object(fields), tokens'')
        _                       -> Error("Unterminated object")
      }
    }
  }


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
      Token.LBrace     -> parseObject(t @ ts)
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
