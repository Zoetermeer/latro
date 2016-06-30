#lang at-exp racket

(require "common.rkt"
         rackunit)

@typecheck{
  module Number {
    type t = Int
  }

  module Arith {
    add => fun(Number.t, Number.t) : Number.t
    fun add(x, y) = x + y
  }

  Arith.add(1, 2)
}
