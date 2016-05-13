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
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it fails to typecheck using non-numerics on the LHS of arithmetic exps"
  (check-equal?
    @typecheck{False + 42;}
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it fails to typecheck if no numerics are given in arithmetic"
  (check-equal?
    @typecheck{False + True;}
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it typechecks list expressions"
  (check-equal?
    @typecheck{[1, 2, 3];}
    '(App List (Int))))

(test-case "it makes empty-list expressions polymorphic"
  (check-match
    @typecheck{[];}
    `(Poly (,t) (App List ((Var ,t))))))

(test-case "it fails non-uniformly-typed list expressions"
  (check-equal?
    @typecheck{[1, False];}
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it checks cons expressions"
  (check-equal?
    @typecheck{1::[2, 3];}
    '(App List (Int))))

(test-case "it fails ill-typed conses"
  (check-equal?
    @typecheck{1::[False, True];}
    '(CantUnify (Expected Bool) (Got Int))))

(test-case "it fails if the right-hand side of a cons is not a list"
  (check-equal?
    @typecheck{1::2;}
    '(CantUnify (Expected (App List (Int))) (Got Int))))

(test-case "it checks 'not' expressions"
  (check-equal?
    @typecheck{!True;}
    'Bool))

(test-case "it fails to typecheck for non-bool types in a 'not' exp"
  (check-equal?
    @typecheck{!42;} '(CantUnify (Expected Bool) (Got Int)))
  (check-equal?
    @typecheck{!(1 + 2);} '(CantUnify (Expected Bool) (Got Int))))

(test-case "it checks if-else expressions"
  (check-equal?
    @typecheck{if (True) { 42; } else { 43; };}
    'Int))

(test-case "it fails to typecheck if an if-else test is not a boolean"
  (check-equal?
    @typecheck{if (0) { 42; } else { 43; };}
    '(CantUnify (Expected Bool) (Got Int))))

(test-case "it fails to typecheck if an if-else's branch types do not unify"
  (check-equal?
    @typecheck{if (True) { 42; } else { "hello"; };}
    '(CantUnify (Expected Int) (Got String))))

(test-case "it checks module-value accesses"
  (check-equal?
    @typecheck{
      def M = module {
        def v = 42;
      };

      M.v;
    }
    'Int))

(test-case "it checks expressions with module-binding components"
  (check-equal?
    @typecheck{
      def M = module {
        def v = 42;
      };

      1 + M.v;
    }
    'Int))

(test-case "it infers qualified-reference function application"
  (check-equal?
    @typecheck{
      def M = module {
        def f = fun(x) { x; };
      };

      M.f("hello world");
    }
    'String))

(test-case "it checks tuple patterns"
  (check-equal?
    @typecheck{
      def (x, y) = (1, False);
      y;
    }
    'Bool))

(test-case "it checks compound tuple patterns"
  (check-equal?
    @typecheck{
      def ((x, y), z) = ((1, True), (3, 4));
      z;
    }
    '(App Tuple (Int Int))))

(test-case "it reports an error if inner tuple patterns are ill-typed"
  (check-match
    @typecheck{
      def ((a, b), (c, d)) = ((1, 2), 3);
      b;
    }
    `(CantUnify
       (Expected
         (App Tuple (,t1 ,t2)))
       (Got Int))))

(test-case "it checks simple list patterns"
  (check-equal?
    @typecheck{
      def [x] = [42];
      x;
    }
    'Int))

(test-case "it checks tuple sub-patterns in list patterns"
  (check-equal?
    @typecheck{
      def [(1, x), (2, y)] = [(1, False), (2, True)];
      (x, y);
    }
    '(App Tuple (Bool Bool))))

(test-case "it checks nested list patterns"
  (check-equal?
    @typecheck{
      def [[1, 2], [3, 4, 5], x] = [[1, 2], [3, 4, 5], [7]];
      x;
    }
    '(App List (Int))))

(test-case "it unifies concrete types with the empty list"
  (check-equal?
    @typecheck{
      42 :: [];
    }
    '(App List (Int))))

(test-case "it checks cons patterns"
  (check-equal?
    @typecheck{
      def x::[] = [1];
      x;
    }
    'Int))

(test-case "it unifies concrete types with empty lists in tuples"
  (check-equal?
    @typecheck{
      (42 :: [], False :: []);
    }
    '(App Tuple ((App List (Int)) (App List (Bool))))))

(test-case "it checks list patterns with concrete types against the empty list"
  (check-equal?
    @typecheck{
      def ([1, 2, 3], x) = ([], False);
      x;
    }
    'Bool))

(test-case "it checks list patterns against the empty list"
  (check-match
    @typecheck{
      def [x] = [];
      x;
    }
    `(Poly (,t) (Var ,t))))

(test-case "it checks list patterns against applications returning empty lists"
  (check-match
    @typecheck{
      def mt = fun() { []; };
      def [x] = mt();

      x;
    }
    `(Poly (,t) (Var ,t))))

(test-case "it returns an error for ill-typed list patterns"
  (check-equal?
    @typecheck{
      def [True, 1, x] = [1, 2, 3];
      x;
    }
    '(CantUnify (Expected Bool) (Got Int))))

(test-case "it fails regardless of subexpression order in list pats"
  (check-equal?
    @typecheck{
      def [x, 1] = [True, False];
      x;
    }
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it fails if the right-hand side of a list-pat binding is ill-typed"
  (check-equal?
    @typecheck{
      def [x, y] = [1, "hello"];
      y;
    }
    '(CantUnify (Expected Int) (Got String))))

(test-case "it infers function types"
  (check-equal?
    @typecheck{
      def f = fun() { 42; };
      f();
    }
    'Int))

(test-case "it infers the identity function"
  (check-equal?
    @typecheck{
      def id = fun(x) { x; };
      id(False);
    }
    'Bool))

(test-case "it allows polymorphic behavior for different callsites"
  (check-equal?
    @typecheck{
      def id = fun(x) { x; };
      (id(42), id(False), id("hello"));
    }
    '(App Tuple (Int Bool String))))

(test-case "it infers types for expressions with polymorphic applications"
  (check-equal?
    @typecheck{
      def id = fun(x) { x; };

      id(42) + id(43);
    }
    'Int))

(test-case "it infers type relationships when generalizing"
  (check-match
    @typecheck{
      def randomzap = fun(x) {
        def f = fun(y) {
          if (False) { y; } else { x; };
        };

        f;
      };

      randomzap;
    }
    `(Poly (,t) (App Arrow ((Var ,t) (App Arrow ((Var ,t) (Var ,t))))))))

(test-case "it infers nested function types"
  (check-equal?
    @typecheck{
      def randomzap = fun(x) {
        def f = fun(y) {
          if (False) { y; } else { x; };
        };
        f;
      };
      (randomzap(42)(), randomzap(False)());
    }
    '(App Tuple (Int Bool))))

(test-case "it infers list types in implicitly polymorphic functions"
  (check-equal?
    @typecheck{
      def toList = fun(x) { x::[]; };
      toList(42);
    }
    '(App List (Int))))

(test-case "it can infer empty list element types based on other occurrences"
  (check-equal?
    @typecheck{
      def make = fun(makeTwo, x) {
        if (makeTwo) {
          [x, x];
        } else {
          [];
        };
      };

      make(False, 1);
    }
    '(App List (Int))))

(test-case "it preserves polymorphism for the empty list for function results"
  (check-match
    @typecheck{
      def toList = fun(x) { []; };
      toList(42);
    }
    `(Poly (,t) (App List ((Var ,t))))))

(test-case "it makes the empty list polymorphic in tuple expressions"
  (check-equal?
    @typecheck{
      def toList = fun(x) { x::[]; };
      (toList(42), toList("foo"));
    }
    '(App Tuple ((App List (Int)) (App List (String))))))

(test-case "it checks recursive functions"
  (check-equal?
    @typecheck{
      def inf = fun(x) { 1 + inf(x); };
      inf(3);
    }
    'Int))

(test-case "it checks recursive functions with conditions"
  (check-equal?
    @typecheck{
      def f = fun(x, runForever) {
        if (runForever) {
          f(x, runForever);
        } else {
          x;
        };
      };

      f(3, False);
    }
    'Int))

(test-case "it checks switch expressions"
  (check-equal?
    @typecheck{
      def len = fun(xs) {
        switch (xs) {
          case [] -> 0;
          case a::as -> 1 + len(as);
        };
      };

      len([42]);
    }
    'Int))

(test-case "it fails if switch clauses return different types"
  (check-equal?
    @typecheck{
      switch (42) {
        case 0 -> "hello";
        case 2 -> 43;
        case _ -> 44;
      };
    }
    '(CantUnify (Expected String) (Got Int))))

(test-case "it fails if switch clauses don't unify with the test expression"
  (check-equal?
    @typecheck{
      switch (42) {
        case 0 -> "hello";
        case False -> "world";
      };
    }
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it allows id shadowing in switch pattern bindings"
  (check-equal?
    @typecheck{
      def x = [1, 2];
      switch (x) {
        case x::xs -> x;
      };
    }
    'Int))

(test-case "it binds identifiers introduced in cons patterns in switches"
  (check-equal?
    @typecheck{
      switch ([2]) {
        case [] -> [1];
        case x::xs -> xs;
      };
    }
    '(App List (Int))))

(test-case "it binds identifiers introduced in nested cons patterns (in tuple pats)"
  (check-equal?
    @typecheck{
      switch (([1])) {
        case ([]) -> [];
        case (x::xs) -> xs;
      };
    }
    '(App List (Int))))

(test-case "it checks switches in function bodies"
  (check-equal?
    @typecheck{
      def len = fun(ls) {
        switch (ls) {
          case [] -> 0;
          case x::xs -> 1 + len(xs);
        };
      };

      len([1]);
    }
    'Int))

(test-case "it allows polymorphic behavior of functions with switches at different callsites"
  (check-equal?
    @typecheck{
      def unwrap = fun(x) {
        switch (x) {
          case y -> y;
        };
      };

      (unwrap("hello"), unwrap(42));
    }
    '(App Tuple (String Int))))

(test-case "it checks non-polymorphic annotated function definitions"
  (check-equal?
    @typecheck{
      weird => fun(Int, Int) : Int;
      weird(0, 0) { 100; }
      weird(x, y) { x + y; };

      weird(1, 2);
    }
    'Int))

(test-case "it fails if annotations don't match inferred types (monomorphic)"
  (check-match
    @typecheck{
      add => fun(Int, Int) : Int;
      add(x, y) { False; };
    }
    `(CantUnify
       (Expected Int)
       (Got Bool))))

(test-case "it checks annotated function definitions"
  (check-equal?
    @typecheck{
      f<a> => fun(a) : a;
      f(x) { x; };

      f(42);
    }
    'Int))

(test-case "it checks annotated functions with recursive application"
  (check-equal?
    @typecheck{
      len<a> => fun(a[]) : Int;
      len([]) { 0; }
      len(x::xs) { 1 + len(xs); };

      len([1, 2]);
    }
    'Int))

(test-case "it fails in ill-typed application of annotated functions"
  (check-match
    @typecheck{
      len<a> => fun(a[]) : Int;
      len([]) { 0; }
      len(x::xs) { 1 + len(xs); };

      len(3);
    }
    `(CantUnify (Expected (App List (,t))) (Got Int))))

(test-case "it fails if return values are of different type params"
  (check-equal?
    @typecheck{
      def f = fun(x, y) { if (True) { x; } else { y; }; };
      f(1, False);
    }
    '(CantUnify (Expected Int) (Got Bool))))

(test-case "it unifies different type params if an application matches their types"
  (check-equal?
    @typecheck{
      def f = fun(x, y) { if (True) { x; } else { y; }; };
      f(1, 3);
    }
    'Int))

(test-case "it checks ADT constructors"
  (check-match
    @typecheck{
      type Foo =
        | A Int
        | B String
        ;

      A(42);
    }
    `(App
       (Unique
         (Id Foo ,_)
         (TyFun
           ()
           (App
             (Adt ((Id A ,_) (Id B ,_)))
             ((App Tuple (Int))
              (App Tuple (String))))))
       ())))

(test-case "it fails on ill-typed ADT constructor applications"
  (check-equal?
    @typecheck{
      type Rope =
        | Leaf String
        | Node Int Rope Rope
        ;

      Leaf(False);
    }
    '(CantUnify (Expected String) (Got Bool))))

(test-case "it checks recursive ADT's"
  (check-match
    @typecheck{
      type Foo =
        | A Int String
        | B Bool Foo
        ;

      B(False, A(42, "hello"));
    }
    `(App
       (Unique
         (Id Foo ,foo-ind)
         (TyFun
           ()
           (App
             (Adt ((Id A ,_) (Id B ,_)))
             ((App Tuple (Int String))
              (App Tuple (Bool (App (TyFun () (Ref (Id Foo ,foo-ind))) ())))))))
       ())))

(test-case "it fails to unify different ADT types"
  (check-match
    @typecheck{
      type A = | A Int;
      type B = | B Int;

      def f = fun(x, y) { if (True) { x; } else { y; }; };
      f(A(1), B(2));
    }
    `(CantUnify (Expected (App (Unique (Id A ,_) ,_) ,_)) (Got (App (Unique (Id B ,_) ,_) ,_)))))

(test-case "it checks annotated functions involving ADT types"
  (check-match
    @typecheck{
      type A = | Foo Int | Bar Int Bool;

      f => fun(A) : A;
      f(v) { v; };

      f(Bar(1, False));
    }
    `(App (Unique (Id A ,_) ,_) ,_)))

(test-case "it checks parameterized ADT types"
  (check-match
    @typecheck{
      type Option<a> =
        | Some a
        | None
        ;

      Some(42);
    }
    `(App
       (Unique
         ,Option
         (TyFun
           (,a)
           (App
             (Adt (,Some ,None))
             ((App Tuple ((Var ,a)))
              (App Tuple ())))))
       (Int))))

(test-case "it checks parameterized ADT types with multiple parameters"
  (check-match
    @typecheck{
      type Either<l, r> =
        | Left l
        | Right r
        ;

      (Right("hello"), Left(42), Right(True));
    }
    `(Poly (,t1 ,t2 ,t3)
       (App
         Tuple
         ((App
            (Unique
              ,Either
              (TyFun
                (,l ,r)
                (App (Adt (,Left ,Right)) ((App Tuple ((Var ,l))) (App Tuple ((Var ,r)))))))
            ((Var ,t1) String))
          (App
            (Unique
              ,Either
              (TyFun
                (,l ,r)
                (App (Adt (,Left ,Right)) ((App Tuple ((Var ,l))) (App Tuple ((Var ,r)))))))
            (Int (Var ,t2)))
          (App
            (Unique
              ,Either
              (TyFun
                (,l ,r)
                (App (Adt (,Left ,Right)) ((App Tuple ((Var ,l))) (App Tuple ((Var ,r)))))))
            ((Var ,t3) Bool)))))))


(test-case "it checks parameterized ADT type constructors with no arguments"
  (check-match
    @typecheck{
      type Option<a> =
        | Some a
        | None
        ;

      None();
    }
    `(Poly
       (,t)
       (App
         (Unique
           ,Option
           (TyFun
             (,a)
             (App
               (Adt (,Some ,None))
               ((App Tuple ((Var ,a)))
                (App Tuple ())))))
         ((Var ,t))))))

(test-case "it checks monomorphic ADT patterns"
  (check-equal?
    @typecheck{
      type Val =
        | B Bool
        | I Int
        | S String
        ;

      switch (B(True)) {
        case I(x) -> x;
        case B(b) -> 1;
        case _ -> 0;
      };
    }
    'Int))

(test-case "it checks ADT patterns"
  (check-equal?
    @typecheck{
      type Option<a> =
        | Some a
        | None
        ;

      def Some(v) = Some(42);
      v;
    }
    'Int))

(test-case "it does not allow arbitrary functions in ADT patterns"
  (check-match
    @typecheck{
      type Option<a> =
        | Some a
        | None
        ;

      def MakeOpt = fun() { Some(False); };
      def MakeOpt(v) = Some(42);
      v;
    }
    `(UnboundUniqIdentifier (Id MakeOpt ,_))))

(test-case "it does not allow bindings in a pattern to escape into other clauses"
  (check-match
    @typecheck{
      type Foo =
        | B Bool
        | I Int
        ;

      switch (I(42)) {
        case I(x) -> x;
        case B(b) -> x;
      };
    }
    `(UnboundUniqIdentifier (Id x ,_))))

(test-case "it does not allow pattern bindings to escape modules"
  (check-match
    @typecheck{
      def Opt = module {
        type t<a> = | Some a | None;

        def GetOne = fun() { Some(42); };
      };

      switch (Opt.GetOne()) {
        case Some(43) -> False;
        case _ -> True;
      };
    }
    `(UnboundUniqIdentifier (Id Some ,_))))
;
; Pended until the syntax supports these qualified patterns (trivial)
; (test-case "it checks qualified ADT patterns"
;   (check-equal?
;     @typecheck{
;       def Opt = module {
;         type t<a> = | Some a | None;
;
;         def GetOne = fun() { Some(42); };
;       };
;
;       switch (Opt.GetOne()) {
;         case Opt.Some(43) -> False;
;         case _ -> True;
;       };
;     }
;     'Bool))

(test-case "it checks annotated functions on ADT values"
  (check-equal?
    @typecheck{
      type Opt<a> = | Some a | None;

      isSome<a> => fun(Opt<a>) : Bool;
      isSome(Some(_)) { True; }
      isSome(_) { False; };

      isNone<a> => fun(Opt<a>) : Bool;
      isNone(o) { !isSome(o); };

      (isNone(Some(42)), isSome(Some(True)));
    }
    '(App Tuple (Bool Bool))))

(test-case "it checks the annotated unwrap function on polymorphic ADT's"
  (check-equal?
    @typecheck{
      type Opt<a> = | Some a | None;

      unwrap<a> => fun(Opt<a>) : a;
      unwrap(Some(x)) { x; };

      unwrap(Some("hello"));
      unwrap(Some(42));
    }
    'Int))

(test-case "it checks the unwrap function on polymorphic ADT's"
  (check-equal?
    @typecheck{
      type Opt<a> = | Some a | None;

      def unwrap = fun(o) {
        switch (o) {
          case Some(x) -> x;
        };
      };

      (unwrap(Some("hello")), unwrap(Some(42)));
    }
    '(App Tuple (String Int))))

(test-case "it infers function types on ADT values"
  (check-equal?
    @typecheck{
      type Opt<a> = | Some a | None;

      def isSome = fun(o) {
        switch (o) {
          case Some(_) -> True;
          case _ -> False;
        };
      };

      def isNone = fun(o) {
        !isSome(o);
      };

      (isSome(None()), isSome(Some("hello")));
    }
    '(App Tuple (Bool Bool))))

(test-case "it checks applications involving parameterized recursive types"
  (check-equal?
    @typecheck{
      type BTree<a> =
        | Node a BTree<a> BTree<a>
        | Leaf a
        ;

      def sizeImp = fun(tree) {
        switch (tree) {
          case Leaf(_) -> 1;
          case Node(_, left, right) ->
            1 + sizeImp(left) + sizeImp(right);
        };
      };

      sizeExp<a> => fun(BTree<a>) : Int;
      sizeExp(Leaf(_)) { 1; }
      sizeExp(Node(_, left, right)) {
        1 + sizeImp(left) + sizeImp(right);
      };

      sizeExp(Leaf(0));
    }
    'Int))

(test-case "it checks cond expressions"
  (check-equal?
    @typecheck{
      cond {
        case False -> "hello";
        case _ -> "world";
      };
    }
    'String))

(test-case "checks a module with common list operations"
  (check-equal?
    @typecheck{
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
        IntList.Concat([], []),
        IntList.Concat([1, 2], []),
        IntList.Concat([1, 2], [3, 4, 5]),
        IntList.Map(IsEven, [1, 2, 3, 4])
      ];
    }
    'Int))
