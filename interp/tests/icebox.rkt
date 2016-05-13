#lang at-exp racket

(require "common.rkt"
         rackunit)

(test-case "it checks structs"
  (check-equal?
    @typecheck{
      type WeirdPoint = struct { Int X; Bool Y; };
      WeirdPoint { X = 1; Y = False; };
    }
    '(App (Struct (X Y)) (Int Bool))))

(test-case "it fails on undefined-member initializers"
  (check-match
    @typecheck{
      type WeirdPoint = struct { Int X; Bool Y; };
      WeirdPoint { X = 1; A = False; };
    }
    `(UndefinedMember (Id A ,_))))

(test-case "it fails on type mismatches in field initializers"
  (check-equal?
    @typecheck{
      type WeirdPoint = struct { Int X; Bool Y; };
      WeirdPoint { X = 1; Y = 2; };
    }
    '(CantUnify (Expected Bool) (Got Int))))

(test-case "it fails on attempts to struct-initialize non-struct types"
  (check-equal?
    @typecheck{
      type Foo = Int;
      Foo { X = 1; };
    }
    '(InvalidStructType Int)))

; Pending a well-defined typing semantics around structs
; (test-case "it checks struct-field accesses"
;   (check-equal?
;     @typecheck{
;       type Point = struct { Int X; Int Y; };
;       (Point { X = 1; Y = 2; }).Y;
;     }
;     'Int))

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
