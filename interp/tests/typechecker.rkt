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

(test-case "it fails non-uniformly-typed list expressions"
  (check-equal?
    @typecheck{[1, False];}
    '(Error "Expected 'Int' but instead got: 'Bool'")))

(test-case "it checks cons expressions"
  (check-equal?
    @typecheck{1::[2, 3];}
    '(App List (Int))))

(test-case "it fails ill-typed conses"
  (check-equal?
    @typecheck{1::[False, True];}
    '(Error "Expected 'Bool' but instead got: 'Int'")))

(test-case "it fails if the right-hand side of a cons is not a list"
  (check-equal?
    @typecheck{1::2;}
    '(Error "Expected '(App List (Int))' but instead got: 'Int'")))

(test-case "it checks 'not' expressions"
  (check-equal?
    @typecheck{!True;}
    'Bool))

(test-case "it fails to typecheck for non-bool types in a 'not' exp"
  (check-equal?
    @typecheck{!42;} '(Error "Expected 'Bool' but instead got: 'Int'"))
  (check-equal?
    @typecheck{!(1 + 2);} '(Error "Expected 'Bool' but instead got: 'Int'")))

(test-case "it checks if-else expressions"
  (check-equal?
    @typecheck{if (True) { 42; } else { 43; };}
    'Int))

(test-case "it fails to typecheck if an if-else test is not a boolean"
  (check-equal?
    @typecheck{if (0) { 42; } else { 43; };}
    '(Error "Expected 'Bool' but instead got: 'Int'")))

(test-case "it fails to typecheck if an if-else's branch types do not unify"
  (check-equal?
    @typecheck{if (True) { 42; } else { "hello"; };}
    '(Error "Expected 'Int' but instead got: 'String'")))

(test-case "it checks structs"
  (check-equal?
    @typecheck{
      type WeirdPoint = struct { Int X; Bool Y; };
      WeirdPoint { X = 1; Y = False; };
    }
    '(App (Struct (X Y)) (Int Bool))))

(test-case "it fails on undefined-member initializers"
  (check-equal?
    @typecheck{
      type WeirdPoint = struct { Int X; Bool Y; };
      WeirdPoint { X = 1; A = False; };
    }
    '(Error "Undefined member 'A'")))

(test-case "it fails on type mismatches in field initializers"
  (check-equal?
    @typecheck{
      type WeirdPoint = struct { Int X; Bool Y; };
      WeirdPoint { X = 1; Y = 2; };
    }
    '(Error "Expected 'Bool' but instead got: 'Int'")))

(test-case "it fails on attempts to struct-initialize non-struct types"
  (check-equal?
    @typecheck{
      type Foo = Int;
      Foo { X = 1; };
    }
    '(Error "Type 'Int' is not a valid struct type.")))

(test-case "it checks struct-field accesses"
  (check-equal?
    @typecheck{
      type Point = struct { Int X; Int Y; };
      (Point { X = 1; Y = 2; }).Y;
    }
    'Int))
