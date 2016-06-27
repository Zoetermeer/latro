module Core {
  type String = Char[]

  type Result{E, T} =
    | Ok(T)
    | Error(T)
  with {
    fun (Ok(_)).isOk() = True
    fun (_).isOk() = False
  }
}

module Json {
  import Core

  type Value =
    | JsonObject(%(String, Value)[])
    | JsonArray(Value[])
    | JsonString(String)
    | JsonNumber(Int)
    | JsonBool(Bool)
    | JsonNull()


  type Tok =
    | TokLBrace()
    | TokRBrace()
    | TokComma()
    | TokLBracket()
    | TokRBracket()
    | TokString(String)
    | TokNumber(Int)
    | TokTrue()
    | TokFalse()
    | TokNull()
    | TokEof()


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


  fun parse-array(ts) {
    def rv = parse-value(ts)
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


  fun parse-value([]) = Ok(JsonNull())
  fun parse-value(t :: ts) {
    switch (t) {
      case TokLBracket() -> parse-array(ts)
      case TokNull       -> Ok(%(JsonNull(), ts))
    }
  }


  fun parse(input) {
    def rv = parse-value(read(input))
    switch (rv) {
      case Ok(%(v, _)) -> Ok(v)
      case Error(msg) -> Error(msg)
    }
  }
}

import Core
import Json

read("{}")
