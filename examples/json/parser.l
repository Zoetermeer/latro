module Json.Value.Field {
  import Core
  import Json
  import Json.Value

  type %(String, Value)

  new : String -> Value -> Field
  new(key, value) = %(key, value)
}

module Json.Value {
  import Core
  import Core.Result
  import Core.Result.Monadic
  import Json
  import Json.Token = Token
  import Json.Value.Field = Field

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
      let field = Field.new(fieldName, value)
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


  parseElements(ts) = {
    parseValue(ts) >>= fun(rv) = {
      let %(value, ts') = rv
      switch (ts') {
        Token.Comma @ ts'' -> {
          parseElements(ts'') >>= fun(restV) = {
            let %(rest, ts''') = restV
            accept(value @ rest, ts''')
          }
        }
        _                  -> accept([value], ts')
      } 
    }
    
  }


  parseArray(ts) = {
    parseElements(ts) >>= fun(ev) = {
      let %(elements, ts') = ev
      switch (ts') {
        Token.RBracket @ ts'' -> accept(Array(elements), ts'')
        _                     -> Error("Expected ']'")
      }
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
