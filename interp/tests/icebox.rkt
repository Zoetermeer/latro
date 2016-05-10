#lang at-exp racket

(require "common.rkt"
         rackunit)

(test-case "it properly instantiates generic types in other generic types"
  (check-equal?
    @interp{
      type Maybe<a> =
        | Just a
        | Nothing
        ;

      type UserDefinedList<a> = struct {
        a Head;
        Option<UserDefinedList<a>> Tail;
      };

      UserDefinedList<Int> { Head = 42; Tail = Nothing; };
    }
    "<<Int>UserDefinedList { Head = 42, Tail = <Int>Maybe = Nothing }>"))
