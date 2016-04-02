#lang at-exp racket
(require rackunit)

(define (compile)
  (system "alex Lex.x")
  (system "happy Parse.y")
  (system "ghc -o interp Main.hs"))

(compile)

(define (call-interpreter opts program)
  (with-output-to-string
    (λ ()
      (system
        (format "./interp ~a \"~a\"" (string-join opts) program)))))

(define (interp . s)
  (call-interpreter '() (apply string-append s)))

(define (strip-quotation-marks s)
  (define cs (string->list s))
  (list->string (drop (take cs (string-length s)) 1)))

(define (parse-tree . s)
  (read
    (open-input-string
      (strip-quotation-marks
        (call-interpreter '("-p") (apply string-append s))))))

(test-case "it parses literals"
  (check-equal?
    @parse-tree{42;}
    '(CompUnit ((ExpNum 42)))))

(test-case "it evaluates literals"
  (check-equal? @interp{True;} "True")
  (check-equal? @interp{False;} "False")
  (check-equal? @interp{42;} "42"))

(test-case "it evaluates arithmetic exps"
  (check-equal? (interp "4 + 3;") "7")
  (check-equal? (interp "4 + 3 * 2;") "10")
  (check-equal? (interp "4 - 3 / 3;") "3"))

(test-case "it returns module values"
  (check-equal?
    @interp{
      m := module {}; m;
    }
    "Module (Env [])"))


(test-case "it does not allow nested modules to escape the local env"
  (check-equal?
    @interp{
      m := module {
        m1 := module {
          fun g(x, y) := {
            y + x;
          };
        };
      };

      m1.g(1, 1);
    }
    "Error: Unbound identifier 'm1'"))
