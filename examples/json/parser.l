module Result {
  module MonadInfix {
    fun >>=(Ok(x), f) = f(x)
    fun >>=(err, _)   = err

    fun return(x) = Ok(x)

    partition{e, t} => fun(Result{e, t}[]) : %(e[], t[])
    fun partition([

    packResults{e, t} => fun(Result{e, t}[]) : Result{e, t}
    fun packResults([]) = Ok([])
    fun packResults(r :: rs) =
      switch (r) {
        case Ok(x) -> 
      }
  }
}

module Json {
  import Core
  import Result.MonadInfix

  type Field = %(String, Value)

  type Value =
    | JsonObject(Field[])
    | JsonArray(Value[])
    | JsonString(String)
    | JsonNumber(Int)
    | JsonBool(Bool)
    | JsonNull


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


  fun lex([]) = Ok(%(TokEof(), ""))
  fun lex(c :: cs) {
    switch (c) {
      case '{' -> Ok(%(TokLBrace(), cs))
      case '}' -> Ok(%(TokRBrace(), cs))
      case ',' -> Ok(%(TokComma(), cs))
      case '[' -> Ok(%(TokLBracket(), cs))
      case ']' -> Ok(%(TokRBracket(), cs))
      case _   -> Error("Invalid token.")
    }
  }


  fun read(input) {
    lex(input) >>= fun(%(token, input')) =
    switch (token) {
      case TokEof() -> Ok([])
      case _        -> Ok(
    }

    def tResult = lex(input)
    switch (tResult) {
      case Ok(%(token, input')) -> {
        switch (token) {
          case TokEof() -> []
          case _        -> token :: read(input')
        }
      }
      case _ -> []
    }
  }


  fun parseArray(ts) {
    def rv = parseValue(ts)
    switch (rv) {
      case Ok(%(value, t :: ts')) -> {
        switch (t) {
          case TokRBracket() -> Ok(%(JsonArray([value]), ts'))
          case _ -> Error("Expected ']'")
        }
      }
      case _ -> Error("Invalid array element")
    }
  }


  fun parseValue([]) = Ok(%(JsonNull(), []))
  fun parseValue(t :: ts) {
    switch (t) {
      case TokLBracket() -> parseArray(ts)
      case TokNull       -> Ok(%(JsonNull(), ts))
    }
  }


  fun parse(input) {
    read(input)         >>= fun(tokens) =
    parseValue(tokens)  >>= fun(rv) =
    switch (rv) {
      case Ok(%(v, _)) -> Ok(v)
      case Error(msg) -> Error(msg)
    }
  }
}
