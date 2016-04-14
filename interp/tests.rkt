#lang at-exp racket
(require rackunit)

(define (needs-recompile? file depends-on-file)
  (> (file-or-directory-modify-seconds depends-on-file)
     (file-or-directory-modify-seconds file)))


(define (compile)
  (when (needs-recompile? "Lex.hs" "Lex.x")
    (system "alex Lex.x"))

  (when (needs-recompile? "Parse.hs" "Parse.y")
    (system "happy Parse.y"))
  (system "ghc -o interp Main.hs"))

(compile)

(define (call-interpreter opts program)
  (call-with-output-file
    "./test.spar"
    (λ (out)
      (fprintf out "~a" program))
    #:mode 'text
    #:exists 'truncate/replace)
  (with-output-to-string
    (λ ()
      (system "./interp ./test.spar"))))

(define (interp . s)
  (call-interpreter '() (apply string-append s)))

(define (strip-quotation-marks s)
  (printf "Cleaning string ~a\n" s)
  (define cs (string->list s))
  (list->string (drop (take cs (string-length s)) 1)))

(define (parse-tree . s)
  (read
    (open-input-string
      (strip-quotation-marks
        (call-interpreter '("-p") (apply string-append s))))))

; Interpreter tests
(test-case "it evaluates literals"
  (check-equal? @interp{True;} "True")
  (check-equal? @interp{False;} "False")
  (check-equal? @interp{42;} "42")
  (check-equal? @interp{"hello";} "hello"))

(test-case "it returns an error for unbound identifiers"
  (check-equal? @interp{x;} "Error: Unbound identifier 'x'"))

(test-case "it evaluates arithmetic exps"
  (check-equal? (interp "4 + 3;") "7")
  (check-equal? (interp "4 + 3 * 2;") "10")
  (check-equal? (interp "4 - 3 / 3;") "3")
  (check-equal? (interp "3 * 2 + 4;") "10")
  (check-equal? (interp "(4 + 3) * 2;") "14"))

(test-case "it evaluates arithmetic expressions involving application"
  (check-equal?
    @interp{
      fun f(Int) : Int;
      f(x) := { x; };

      3 + f(4);
    }
    "7"))

(test-case "it evaluates if-else expressions"
  (check-equal?
    @interp{
      if (True) {
        42;
      } else {
        43;
      };
    }
    "42"))

(test-case "it takes the else branch on false"
  (check-equal?
    @interp{
      if (False) {
        42;
      } else {
        43;
      };
    }
    "43"))

(test-case "it does not allow bindings to escape from then/else scopes"
  (check-equal?
    @interp{
      def v := if (True) {
        def x := 42;
        x;
      } else { 0; };

      x;
    }
    "Error: Unbound identifier 'x'"))

(test-case "it does not allow bindings to escape the test exp of an if/else"
  (check-equal?
    @interp{
      if (def x := 42) {
        x;
      } else {
        x;
      };
    }
    "Error: Unbound identifier 'x'"))

(test-case "it does not add bindings introduced in subexpressions to the module export env"
  (check-equal?
    @interp{
      module {
        if (True) {
          def x := 42;
        } else {
          ();
        };
      };
    }
    "<module (Closure [] []) (Exports [] [])>"))

(test-case "it evaluates non-literals in the test position"
  (check-equal?
    @interp{
      fun f(Int) : Int;
      f(x) := {
        if (x) { True; } else { False; };
      };

      if (f(1)) {
        42;
      } else {
        43;
      };
    }
    "42"))


(test-case "it evaluates nested if-else expressions"
  (check-equal?
    @interp{
      42 + (if (True) { 1; } else { 2; });
    }
    "43"))

(test-case "it returns function values"
  (check-equal?
    @interp{
      fun f() : Int;
      f() := { 42; };

      f;
    }
    "<fun f (Closure [] [])>"))

(test-case "it returns function values with closures"
  (check-equal?
    @interp{
      def v := 1;
      fun f() : Int;
      f() := { v; };

      f;
    }
    "<fun f (Closure [] [v])>"))

(test-case "it returns module values"
  (check-equal?
    @interp{
      def m := module {}; m;
    }
    "<module (Closure [] []) (Exports [] [])>"))

(test-case "it adds definitions to module exports"
  (check-equal?
    @interp{
      def m := module { def v := 42; }; m;
    }
    "<module (Closure [] []) (Exports [] [v])>"))

(test-case "it applies functions on modules with multiple decs"
  (check-equal?
    @interp{
      def m := module {
        fun f() : Int;
        f() := { 42; };

        fun g() : Int;
        g() := { 43; };
      };

      m.g();
    }
    "43"))

(test-case "it returns values defined in modules"
  (check-equal?
    @interp{
      def m := module { def v := 42; };
      m.v;
    }
    "42"))

(test-case "it can apply module-exported functions"
  (check-equal?
    @interp{
      def m := module {
        fun f() : Int;
        f() := { 42; };
      };
      m.f();
    }
    "42"))

(test-case "it can apply module-exported functions occurring after a nested module dec"
  (check-equal?
    @interp{
      def m := module {
        def n := module { };

        fun f() : Int;
        f() := { 42; };
      };
      m.f();
    }
    "42"))

(test-case "it can apply module-exported functions occurring before a nested module dec"
  (check-equal?
    @interp{
      def m := module {
        fun f() : Int;
        f() := { 42; };

        def n := module { };
      };
      m.f();
    }
    "42"))

(test-case "it returns nested module values"
  (check-equal?
    @interp{
      def a := module {
        def b := module {
          def v := 42;
        };
      };

      a.b.v;
    }
    "42"))

(test-case "it applies defined functions"
  (check-equal?
    @interp{
      fun f() : Int;
      f() := { 42; };
      f();
    }
    "42"))

(test-case "it substitutes function args"
  (check-equal?
    @interp{
      fun f(Int) : Int;
      f(x) := { x; };
      f(42);
    }
    "42"))

(test-case "it correctly shadows bindings in function bodies"
  (check-equal?
    @interp{
      def m := module { };
      fun f(Int) : Int;
      f(m) := { m; };
      f(42);
    }
    "42"))

(test-case "it captures bindings from the env in function bodies"
  (check-equal?
    @interp{
      def m := module { };
      fun f() : module { };
      f() := { m; };
      f();
    }
    "<module (Closure [] []) (Exports [] [])>"))

(test-case "it preserves lexical scope for local module defs"
  (check-equal?
    @interp{
      fun f() : module { };
      f() := {
        def m := module {};
      };
      m;
    }
    "Error: Unbound identifier 'm'"))

(test-case "it does not add locals in function bodies to the module export env"
  (check-equal?
    @interp{
      module {
        fun f() : Int;
        f() := {
          def x := 42;
          x;
        };
      };
    }
    "<module (Closure [] []) (Exports [] [f])>"))

(test-case "it can apply functions on returned local modules"
  (check-equal?
    @interp{
      fun f() : module { };
      f() := {
        module {
          fun g() : Int;
          g() := { 42; };
        };
      };
      f().g();
    }
    "42"))

(test-case "it returns nested module values"
  (check-equal?
    @interp{
      def m := module {
        def m' := module {
          fun g() : Int;
          g() := { 43; };
        };

        fun f() : Int;
        f() := { 42; };
      };

      m.m';
    }
    "<module (Closure [] []) (Exports [] [g])>"))

(test-case "it resolves functions on nested modules"
  (check-equal?
    @interp{
      def m := module {
        def m' := module {
          fun g() : Int;
          g() := { 43; };
        };

        fun f() : Int;
        f() := { 42; };
      };

      m.m'.g();
    }
    "43"))

(test-case "it evaluates functions with compound bodies on nested modules"
  (check-equal?
    @interp{
      def m := module {
        def m1 := module {
          fun g(Int, Int) : Int;
          g(x, y) := { y + x; };
        };

        fun f() : Int;
        f() := { 42; };
      };

      m.m1.g(m.f(), 1);
    }
    "43"))

(test-case "it evaluates higher-order functions"
  (check-equal?
    @interp{
      fun f(fun(Int) : Int, Int) : Int;
      f(g, x) := {
        g(10) + x;
      };

      fun h(Int) : Int;
      h(x) := {
        x + 1;
      };

      f(h, 3);
    }
    "14"))

(test-case "it does not allow nested modules to escape the local env"
  (check-equal?
    @interp{
      def m := module {
        def m1 := module {
          fun g(Int, Int) : Int;
          g(x, y) := {
            y + x;
          };
        };
      };

      m1.g(1, 1);
    }
    "Error: Unbound identifier 'm1'"))

(test-case "it does not capture id's in lexical scope for modules as exports"
  (check-equal?
    @interp{
      def m := module {
        fun f() : Int;
        f() := { 42; };

        def n := module { };
      };

      m.n.f();
    }
    "Error: Unbound identifier 'f'"))

(test-case "it evaluates recursive functions"
  (check-equal?
    @interp{
      fun f(Int) : Int;
      f(x) := {
        if (x) {
          x + f(x - 1);
        } else {
          x;
        };
      };
      f(4);
    }
    "10"))

(test-case "it resolves member accesses on captured modules"
  (check-equal?
    @interp{
      def m := module {
        def n := module {
          def o := module {
            def v := 42;
          };
        };

        fun f() : Int;
        f() := { n.o.v; };
      };

      m.f();
    }
    "42"))

(test-case "it evaluates accesses on module-level scalars"
  (check-equal?
    @interp{
      def m := module {
        def v := 6;
      };

      m.v;
    }
    "6"))

(test-case "it can access prior bindings in a module closure"
  (check-equal?
    @interp{
      def m := module { };
      fun f() : Int;
      f() := { 1; };

      def n := module {
        def v := 2;
      };

      n;
    }
    "<module (Closure [] [f, m]) (Exports [] [v])>"))

(test-case "it evaluates accesses on nested-module-level scalars"
  (check-equal?
    @interp{
      def m := module {
        def n := module {
          def v := 6;
        };
      };

      m.n.v;
    }
    "6"))

(test-case "it evaluates accesses on inline modules"
  (check-equal?
    @interp{
      module { def v := 6; }.v;
    }
    "6"))

(test-case "it returns the empty struct"
  (check-equal?
    @interp{
      type t = struct { };
      t { };
    }
    "<struct <<{ }>> { }>"))

(test-case "it evaluates struct instances"
  (check-equal?
    @interp{
      type Point = struct {
        Int X;
        Int Y;
      };

      Point { X = 3; Y = 4; };
    }
    "<struct <<{ X <<Int>>, Y <<Int>> }>> { X = 3, Y = 4 }>"))

(test-case "it evaluates struct field accesses"
  (check-equal?
    @interp{
      type Point = struct {
        Int X;
        Int Y;
      };

      def p := Point { X = 3; Y = 4; };
      p.Y;
    }
    "4"))

(test-case "it returns an error on undefined-field accesses"
  (check-equal?
    @interp{
      type t = struct { };
      def v := t { };
      v.x;
    }
    "Error: Unbound identifier 'x'"))

(test-case "it evaluates nested struct field accesses"
  (check-equal?
    @interp{
      type Point = struct {
        Int X;
        Int Y;
      };

      type Line = struct {
        Point A;
        Point B;
      };

      def l := Line {
        A = Point { X = 0; Y = 0; };
        B = Point { X = 3; Y = 4; };
      };

      l.B.Y;
    }
    "4"))

(test-case "it evaluates module-exported struct types"
  (check-equal?
    @interp{
      def Geometry := module {
        type Point = struct {
          Int X;
          Int Y;
        };

        type Line = struct {
          Point A;
          Point B;
        };
      };

      def l := Geometry.Line {
        A = Geometry.Point { X = 0; Y = 0; };
        B = Geometry.Point { X = 3; Y = 4; };
      };

      l.B.Y;
    }
    "4"))

(test-case "it does not allow module-exported type bindings to escape"
  (check-equal?
    @interp{
      def Geometry := module {
        type Point = struct {
          Int X;
          Int Y;
        };
      };

      def p := Point { X = 0; Y = 0; };
      p;
    }
    "Error: Unbound identifier 'Point'"))

(test-case "it evaluates algebraic data type definitions"
  (check-equal?
    @interp{
      def Prims := module {
        type IntOption =
          | Just Int
          | None
          ;
      };
      Prims;
    }
    "<module (Closure [] []) (Exports [IntOption] [Just, None])>"))

(test-case "it constructs ADT instances"
  (check-equal?
    @interp{
      type IntOption =
        | Just Int
        | None
        ;

      Just(42);
    }
    "<IntOption = Just(42)>"))

(test-case "it scopes ADT defs/ctors to module exports"
  (check-equal?
    @interp{
      def m := module {
        type IntOption =
          | Just Int
          | None
          ;
      };

      Just(42);
    }
    "Error: Unbound identifier 'Just'"))

(test-case "it evaluates multi-arity ADT constructors"
  (check-equal?
    @interp{
      type T =
        | IBTuple Int Bool
        | B Bool
        ;

      type S = struct {
        T A;
        T B;
      };

      S { B = B(True); A = IBTuple(2, False); };
    }
    "<struct <<{ A T, B T }>> { B = <T = B(True)>, A = <T = IBTuple(2, False)> }>"))

(test-case "it evaluates tuple expressions"
  (check-equal?
    @interp{
      (4, False);
    }
    "<tuple (4, False)>"))

(test-case "it evaluates 3-tuples"
  (check-equal?
    @interp{
      (3, True, 4);
    }
    "<tuple (3, True, 4)>"))

(test-case "it applies functions with tuple arguments"
  (check-equal?
    @interp{
      fun f((Int, Bool)) : (Int, Bool);
      f(pair) := { pair; };

      f((5, False));
    }
    "<tuple (5, False)>"))

(test-case "it evaluates list expressions"
  (check-equal?
    @interp{
      [1, 2, 3];
    }
    "<list [1, 2, 3]>"))

(test-case "it evaluates list bindings"
  (check-equal?
    @interp{
      def ls := [1, 2, 3, 4];
      ls;
    }
    "<list [1, 2, 3, 4]>"))

(test-case "it evaluates list cons operations"
  (check-equal?
    @interp{
      1 :: [2, 3, 4];
    }
    "<list [1, 2, 3, 4]>"))

(test-case "it makes cons right-associative"
  (check-equal?
    @interp{
      fun f(Int, Int) : Int[];
      f(x, y) := {
        x :: y :: [3, 4, 5];
      };

      f(1, 2);
    }
    "<list [1, 2, 3, 4, 5]>"))

(test-case "it evaluates list patterns"
  (check-equal?
    @interp{
      def [a, b, c] := [1, 2, 3];
      a + b + c;
    }
    "6"))

(test-case "it evaluates list patterns with pattern subexpressions"
  (check-equal?
    @interp{
      def [_, b, 3] := [1, 2, 3];
      b;
    }
    "2"))

(test-case "it fails to bind to list patterns if lengths don't match"
  (check-equal?
    @interp{
      def [a, b] := [];
      a;
    }
    "Error: Binding pattern match failure for value '<list []>'"))

(test-case "it evaluates list cons patterns"
  (check-equal?
    @interp{
      def x::xs := [1, 2, 3, 4];
      (x, xs);
    }
    "<tuple (1, <list [2, 3, 4]>)>"))

(test-case "it evaluates cons patterns with list pat subexpressions"
  (check-equal?
    @interp{
      def x::[] := [3];
      x;
    }
    "3"))

(test-case "it evaluates cons patterns in sublists"
  (check-equal?
    @interp{
      def xs::[[3, 4], [x, _, z]] := [[1, 2], [3, 4], [5, 6, 7]];
      (xs, x, z);
    }
    "<tuple (<list [1, 2]>, 5, 7)>"))

(test-case "it evaluates tuple pattern bindings"
  (check-equal?
    @interp{
      def (a, b) := (1, True);
      b;
    }
    "True"))

(test-case "it returns an error for match failures in pattern bindings"
  (check-equal?
    @interp{
      def (a, b) := 42;
      a;
    }
    "Error: Binding pattern match failure for value '42'"))

(test-case "it evaluates wildcards in tuple patterns"
  (check-equal?
    @interp{
      def (_, b) := (1, 43);
      b;
    }
    "43"))

(test-case "it throws away expressions bound to wildcards"
  (check-equal?
    @interp{
      def _ := 42;
      43;
    }
    "43"))

(test-case "it evaluates switch expressions"
  (check-equal?
    @interp{
      def v := (4, False);
      switch (v) {
        case (0, _) -> 1;
        case (4, True) -> 2;
        case (_, False) -> 3;
        case _ -> 4;
      };
    }
    "3"))

(test-case "it evaluates patterns in argument-binding position"
  (check-equal?
    @interp{
      fun IsZero(Int) : Bool;
      IsZero(0) := { True; }
      IsZero(_) := { False; };

      (IsZero(1), IsZero(0));
    }
    "<tuple (False, True)>"))

(test-case "it evaluates tuple patterns in argument bindings"
  (check-equal?
    @interp{
      fun Fst((Int, Bool)) : Int;
      Fst((a, _)) := { a; };

      fun Snd((Int, Bool)) : Bool;
      Snd((_, b)) := { b; };

      def v := (42, False);
      (Snd(v), Fst(v));
    }
    "<tuple (False, 42)>"))

(test-case "it returns an error for non-exhaustive patterns in argument bindings"
  (check-equal?
    @interp{
      fun IsZero(Int) : Bool;
      IsZero(0) := { True; };

      IsZero(1);
    }
    "Error: Non-exhaustive pattern in function 'IsZero'"))

(test-case "it evaluates ADT patterns"
  (check-equal?
    @interp{
      type StringOption =
        | Some String
        | None
        ;

      def Some(x) := Some("hello world");
      x;
    }
    "hello world"))

(test-case "it returns an error for non-exhaustive patterns in ADT bindings"
  (check-equal?
    @interp{
      type IntOption =
        | Some Int
        | None
        ;

        def None() := Some(10);
      }
      "Error: Non-exhaustive pattern binding for '<IntOption = Some(10)>'"))

(test-case "it evaluates ADT argument patterns"
  (check-equal?
    @interp{
      type IntOption = | Some Int | None ;
      fun IsSome(IntOption) : Bool;
      IsSome(Some(_)) := { True; }
      IsSome(_) := { False; };

      def s := Some(42);
      def Some(v) := s;
      (IsSome(None), IsSome(s), v);
    }
    "<tuple (False, True, 42)>"))

(test-case "it has enough to encode common list operations"
  (check-equal?
    @interp{
      fun IsEven(Int) : Bool;
      IsEven(x) := {
        switch (x) {
          case 0 -> True;
          case 1 -> False;
          case 2 -> True;
          case _ -> IsEven(x - 2);
        };
      };

      type BoolList = Bool[];

      def IntList := module {
        type t = Int[];

        fun IsEmpty(t) : Bool;
        IsEmpty([]) := { True; }
        IsEmpty(_) := { False; };

        fun Concat(t, t) : t;
        Concat(xs, []) := { xs; }
        Concat([], ys) := { ys; }
        Concat((x::xs), ys) := {
          x :: Concat(xs, ys);
        };

        fun Map(fun(Int) : Bool, t) : BoolList;
        Map(f, []) := { []; }
        Map(f, (x::xs)) := {
          def b := f(x);
          b :: Map(f, xs);
        };
      };

      [
        IntList.IsEmpty([1]),
        IntList.IsEmpty([]),
        IntList.Concat([], []),
        IntList.Concat([1, 2], []),
        IntList.Concat([1, 2], [3, 4, 5])
      ];
    }
    "<list [False, True, <list []>, <list [1, 2]>, <list [1, 2, 3, 4, 5]>]>"))
