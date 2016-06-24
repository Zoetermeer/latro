#lang at-exp racket

(require "common.rkt"
         rackunit)

#;@alpha-convert{
  module Number {
    type t = Int
  }

  module Div {
    type t =
      | Num(Number.t)
      | ByZero

    fun div(x, 0) = ByZero()
    fun div(x, y) = Num(x / y)
  }

  def Div.Num(answer) = Div.div(100, 10)
  answer
}

@interp{
  fun foo(x) {
    (fun(x) { x + 1 })(x) + x
  }
}
