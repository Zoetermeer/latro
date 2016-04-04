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

(test-case "it evaluates arithmetic exps"
  (check-equal? (interp "4 + 3;") "7")
  (check-equal? (interp "4 + 3 * 2;") "10")
  (check-equal? (interp "4 - 3 / 3;") "3")
  (check-equal? (interp "3 * 2 + 4;") "10")
  (check-equal? (interp "(4 + 3) * 2;") "14"))

(test-case "it returns module values"
  (check-equal?
    @interp{
      m := module {}; m;
    }
    "Module (Env [])"))

(test-case "it returns values defined in modules"
  (check-equal?
    @interp{
      m := module { v := 42; }; m.v;
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
    "Module (Env [])"))

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

(test-case "it can apply functions on returned local modules"
  (check-equal?
    @interp{
      fun f() : module { g() : Int; };
      f() := {
        module {
          fun g() : Int;
          g() := { 42; };
        };
      };
      f().g();
    }
    "42"))

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
