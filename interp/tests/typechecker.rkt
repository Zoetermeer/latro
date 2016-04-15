#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it typechecks scalar literals"
  (check-equal? @typecheck{42;} 'Int)
  (check-equal? @typecheck{True;} 'Bool)
  (check-equal? @typecheck{"hello";} 'String))

(test-case "it typechecks tuples"
  (check-equal?
    @typecheck{(1, False);}
    '(App Tuple (Int Bool))))

(test-case "it typechecks tuples of tuples"
  (check-equal?
    @typecheck{(42, ("hello", True));}
    '(App Tuple (Int (App Tuple (String Bool))))))

(test-case "it typechecks arithmetic expressions"
  (check-equal? @typecheck{1 + 1;} 'Int)
  (check-equal? @typecheck{1 - 1;} 'Int)
  (check-equal? @typecheck{42 + 3 * 1 / 33;} 'Int))

(test-case "it fails to typecheck using non-numerics in arithmetic"
  (check-equal?
    @typecheck{1 + True;}
    '(Error "Expected 'Int' but instead got: 'Bool'")))

(test-case "it fails to typecheck using non-numerics on the LHS of arithmetic exps"
  (check-equal?
    @typecheck{False + 42;}
    '(Error "Expected 'Int' but instead got: 'Bool'")))

(test-case "it fails to typecheck if no numerics are given in arithmetic"
  (check-equal?
    @typecheck{False + True;}
    '(Error "Expected 'Int' but instead got: 'Bool'")))

(test-case "it typechecks list expressions"
  (check-equal?
    @typecheck{[1, 2, 3];}
    '(App List (Int))))

(test-case "it makes empty-list expressions polymorphic"
  (check-equal?
    @typecheck{[];}
    '(Poly (t) (App List ((Var t))))))
