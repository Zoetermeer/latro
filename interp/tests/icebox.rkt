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

(test-case "it has enough to encode common list operations"
  (check-equal?
    @interp{
      IsEven => fun(Int) : Bool;
      IsEven(x) {
        switch (x) {
          case 0 -> True;
          case 1 -> False;
          case 2 -> True;
          case _ -> IsEven(x - 2);
        };
      };

      type BoolList = Bool[];

      def IntList = module {
        type t = Int[];

        IsEmpty => fun(t) : Bool;
        IsEmpty([]) { True; }
        IsEmpty(_) { False; };

        Concat => fun(t[], t[]) : t[];
        Concat(xs, []) { xs; }
        Concat([], ys) { ys; }
        Concat(x::xs, ys) {
          x :: Concat(xs, ys);
        };

        Map => fun(fun(Int) : Bool, t) : BoolList;
        Map(f, []) { []; }
        Map(f, x::xs) {
          f(x) :: Map(f, xs);
        };
      };

      [
        IntList.IsEmpty([1]),
        IntList.IsEmpty([]),
        IntList.Concat([], []),
        IntList.Concat([1, 2], []),
        IntList.Concat([1, 2], [3, 4, 5]),
        IntList.Map(IsEven, [1, 2, 3, 4])
      ];
    }
    '(List (False True (List ()) (List (1 2)) (List (1 2 3 4 5)) (List (False True False True))))))

