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

;Interpreter tests
(test-case "it evaluates literals"
  (check-equal? @interp{True;} "True")
  (check-equal? @interp{False;} "False")
  (check-equal? @interp{42;} "42"))

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
      v := if (True) {
        x := 42;
        x;
      } else { 0; };

      x;
    }
    "Error: Unbound identifier 'x'"))

(test-case "it does not allow bindings to escape the test exp of an if/else"
  (check-equal?
    @interp{
      if (x := 42) {
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
          x := 42;
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
      v := 1;
      fun f() : Int;
      f() := { v; };

      f;
    }
    "<fun f (Closure [] [v])>"))

(test-case "it returns module values"
  (check-equal?
    @interp{
      m := module {}; m;
    }
    "<module (Closure [] []) (Exports [] [])>"))

(test-case "it adds definitions to module exports"
  (check-equal?
    @interp{
      m := module { v := 42; }; m;
    }
    "<module (Closure [] []) (Exports [] [v])>"))

(test-case "it applies functions on modules with multiple decs"
  (check-equal?
    @interp{
      m := module {
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
      m := module { v := 42; };
      m.v;
    }
    "42"))

(test-case "it can apply module-exported functions"
  (check-equal?
    @interp{
      m := module {
        fun f() : Int;
        f() := { 42; };
      };
      m.f();
    }
    "42"))

(test-case "it can apply module-exported functions occurring after a nested module dec"
  (check-equal?
    @interp{
      m := module {
        n := module { };

        fun f() : Int;
        f() := { 42; };
      };
      m.f();
    }
    "42"))

(test-case "it can apply module-exported functions occurring before a nested module dec"
  (check-equal?
    @interp{
      m := module {
        fun f() : Int;
        f() := { 42; };

        n := module { };
      };
      m.f();
    }
    "42"))

(test-case "it returns nested module values"
  (check-equal?
    @interp{
      a := module {
        b := module {
          v := 42;
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
      m := module { };
      fun f(Int) : Int;
      f(m) := { m; };
      f(42);
    }
    "42"))

(test-case "it captures bindings from the env in function bodies"
  (check-equal?
    @interp{
      m := module { };
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
        m := module {};
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
          x := 42;
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
      m := module {
        m' := module {
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
      m := module {
        m' := module {
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
      m := module {
        m1 := module {
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
      m := module {
        m1 := module {
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
      m := module {
        fun f() : Int;
        f() := { 42; };

        n := module { };
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
      m := module {
        n := module {
          o := module {
            v := 42;
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
      m := module {
        v := 6;
      };

      m.v;
    }
    "6"))

(test-case "it can access prior bindings in a module closure"
  (check-equal?
    @interp{
      m := module { };
      fun f() : Int;
      f() := { 1; };

      n := module {
        v := 2;
      };

      n;
    }
    "<module (Closure [] [f, m]) (Exports [] [v])>"))

(test-case "it evaluates accesses on nested-module-level scalars"
  (check-equal?
    @interp{
      m := module {
        n := module {
          v := 6;
        };
      };

      m.n.v;
    }
    "6"))

(test-case "it evaluates accesses on inline modules"
  (check-equal?
    @interp{
      module { v := 6; }.v;
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

      p := Point { X = 3; Y = 4; };
      p.Y;
    }
    "4"))

(test-case "it returns an error on undefined-field accesses"
  (check-equal?
    @interp{
      type t = struct { };
      v := t { };
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

      l := Line {
        A = Point { X = 0; Y = 0; };
        B = Point { X = 3; Y = 4; };
      };

      l.B.Y;
    }
    "4"))

(test-case "it evaluates module-exported struct types"
  (check-equal?
    @interp{
      Geometry := module {
        type Point = struct {
          Int X;
          Int Y;
        };

        type Line = struct {
          Point A;
          Point B;
        };
      };

      l := Geometry.Line {
        A = Geometry.Point { X = 0; Y = 0; };
        B = Geometry.Point { X = 3; Y = 4; };
      };

      l.B.Y;
    }
    "4"))

(test-case "it does not allow module-exported type bindings to escape"
  (check-equal?
    @interp{
      Geometry := module {
        type Point = struct {
          Int X;
          Int Y;
        };
      };

      p := Point { X = 0; Y = 0; };
      p;
    }
    "Error: Unbound identifier 'Point'"))

(test-case "it evaluates algebraic data type definitions"
  (check-equal?
    @interp{
      Prims := module {
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
      m := module {
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
