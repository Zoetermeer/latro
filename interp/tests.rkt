#lang at-exp racket
(require rackunit)

(define (compile)
  (system "alex Lex.x")
  (system "happy Parse.y")
  (system "ghc -o interp Main.hs"))

(compile)

(define (interp . s)
  (with-output-to-string
    (λ ()
      (system (format "./interp \"~a\"" (apply string-append s))))))

(test-case "it evaluates literals"
  (check-equal? @interp{True;} "True")
  (check-equal? @interp{False;} "False")
  (check-equal? @interp{42;} "42"))

(test-case "it does not allow nested modules to escape the local env"
  (check-equal?
    @interp{
      m := module {
        m1 := module {
          fun g(x, y) := { y + x; };
        };
      };

      m1.g(1, 1);
    }
    "Error: Unbound identifier 'm1'"))
