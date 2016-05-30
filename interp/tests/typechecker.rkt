#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it typechecks scalar literals"
  (check-equal? @typecheck{42;} 'Int)
  (check-equal? @typecheck{True;} 'Bool)
  (check-equal? @typecheck{"hello";} '(App List (Char)))
  (check-equal? @typecheck{'a';} 'Char))

(test-case "it typechecks tuples"
  (check-equal?
    @typecheck{(1, False);}
    '(App Tuple (Int Bool))))

(test-case "it typechecks tuples of tuples"
  (check-equal?
    @typecheck{(42, ("hello", True));}
    '(App Tuple (Int (App Tuple ((App List (Char)) Bool))))))

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
  (check-match
    @typecheck{[1, False];}
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

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
    '(CantUnify (Expected Int) (Got (App List (Char))))))

(test-case "it checks module-value accesses"
  (check-equal?
    @typecheck{
      module M {
        def v = 42;
      };

      M.v;
    }
    'Int))

(test-case "it searches the module closure for type names"
  (check-equal?
    @typecheck{
      type Foo = Int;
      module M {
        add => fun(Foo, Int) : Int;
        fun add(x, y) = x + y;
      };

      M.add(1, 2);
    }
    'Int))

(test-case "it can resolve submodule members of modules in the closure"
  (check-equal?
    @typecheck{
      module M {
        def foo = 42;
      };

      module M' {
        def bar = M.foo;
      };

      M'.bar;
    }
    'Int))

(test-case "it fails on incorrect qualified paths"
  (check-match
    @typecheck{
      module M {
        module N {
          def foo = 42;
        };
      };

      module M' {
        def bar = N.foo;
      };

      M'.bar;
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id N ,_)))))

(test-case "it does not extend type name resolution to closures of closed modules"
  (check-match
    @typecheck{
      type String = Char[];

      module M { };

      f => fun(M.String) : M.String;
      fun f(s) { s; };
    }
    `(AtPos (SourcePos ,_ 5 ,_) (CompilerModule Types) (UnboundUniqIdentifier (Id String ,_)))))

(test-case "it does not extend variable name resolution to closures of closed modules"
  (check-match
    @typecheck{
      def foo = 42;

      module M {
        def bar = foo;
      };

      M.foo + M.bar;
    }
    `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule Types) (UnboundUniqIdentifier (Id foo ,_)))))

(test-case "it can resolve pattern names in the module closure"
  (check-equal?
    @typecheck{
      type A = | Foo Int | Bar Int;

      module M {
        def f = fun(a) {
          switch (a) {
            case Foo(x) -> x;
            case _ -> 0;
          };
        };
      };

      M.f(Foo(43));
    }
    'Int))

(test-case "does not re-export pattern names from the module closure"
  (check-match
    @typecheck{
      type A = | Foo Int | Bar Int;

      module M { };

      switch (Foo(42)) {
        case M.Foo(x) -> x;
        case _ -> 0;
      };
    }
    `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule Types) (UnboundUniqIdentifier (Id Foo ,_)))))

(test-case "it does not allow module-exported type bindings to escape"
  (check-match
    @typecheck{
      module Geometry {
        type Point = struct {
          Int X;
          Int Y;
        };
      };

      def p = Point { X = 0; Y = 0; };
      p;
    }
    `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule Types) (UnboundUniqIdentifier (Id Point ,_)))))

(test-case "it checks expressions with module-binding components"
  (check-equal?
    @typecheck{
      module M {
        def v = 42;
      };

      1 + M.v;
    }
    'Int))

(test-case "it infers qualified-reference function application"
  (check-equal?
    @typecheck{
      module M {
        def f = fun(x) { x; };
      };

      M.f("hello world");
    }
    '(App List (Char))))

(test-case "it checks string patterns"
  (check-equal?
    @typecheck{
      switch ("hello") {
        case "foo" -> "bar";
        case "hello" -> "world";
        case _ -> "no match";
      };
    }
    '(App List (Char))))

(test-case "it checks tuple patterns"
  (check-equal?
    @typecheck{
      def (x, y) = (1, False);
      y;
    }
    'Bool))

(test-case "it reports an error for tuple patterns with non-tuple right-hand exps"
  (check-match
    @interp{
      def (a, b) = 42;
      a;
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected (App Tuple (,_ ,_))) (Got Int)))))

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
    `(AtPos
       ,_
       (CompilerModule Types)
       (CantUnify
         (Expected
           (App Tuple (,t1 ,t2)))
         (Got Int)))))

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
    `(Meta ,_)))

(test-case "it checks list patterns against applications returning empty lists"
  (check-match
    @typecheck{
      def mt = fun() { []; };
      def [x] = mt();

      x;
    }
    `(Meta ,_)))

(test-case "it returns an error for ill-typed list patterns"
  (check-match
    @typecheck{
      def [True, 1, x] = [1, 2, 3];
      x;
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Bool) (Got Int)))))

(test-case "it fails regardless of subexpression order in list pats"
  (check-match
    @typecheck{
      def [x, 1] = [True, False];
      x;
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

(test-case "it fails if the right-hand side of a list-pat binding is ill-typed"
  (check-match
    @typecheck{
      def [x, y] = [1, "hello"];
      y;
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got (App List (Char)))))))

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
    '(App Tuple (Int Bool (App List (Char))))))

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
      (randomzap(42)(43), randomzap(False)(True));
    }
    '(App Tuple (Int Bool))))

(test-case "it fails to unify if we apply the nested function with a different type"
  (check-match
    @typecheck{
      def randomzap = fun(x) {
        def f = fun(y) {
          if (False) { y; } else { x; };
        };
        f;
      };

      randomzap(42)(False);
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

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
    '(App Tuple ((App List (Int)) (App List ((App List (Char))))))))

(test-case "it checks recursive functions"
  (check-equal?
    @typecheck{
      fun inf(x) { 1 + inf(x); };
      inf(3);
    }
    'Int))

(test-case "it checks recursive functions with conditions"
  (check-equal?
    @typecheck{
      fun f(x, runForever) {
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
      fun len(xs) {
        switch (xs) {
          case [] -> 0;
          case a::as -> 1 + len(as);
        };
      };

      len([42]);
    }
    'Int))

(test-case "it fails if switch clauses return different types"
  (check-match
    @typecheck{
      switch (42) {
        case 0 -> "hello";
        case 2 -> 43;
        case _ -> 44;
      };
    }
    `(AtPos
       ,_
       (CompilerModule Types)
       (CantUnify (Expected (App List (Char))) (Got Int)))))

(test-case "it fails if switch clauses don't unify with the test expression"
  (check-match
    @typecheck{
      switch (42) {
        case 0 -> "hello";
        case False -> "world";
      };
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

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
      fun len(ls) {
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
    '(App Tuple ((App List (Char)) Int))))

(test-case "it checks non-polymorphic annotated function definitions"
  (check-equal?
    @typecheck{
      weird => fun(Int, Int) : Int;
      fun weird(0, 0) = 100;
      fun weird(x, y) { x + y; };

      weird(1, 2);
    }
    'Int))

(test-case "it checks annotations on variable bindings"
  (check-equal?
    @typecheck{
      v => Int;
      def v = 42;

      v;
    }
    'Int))

(test-case "it checks annotations on variable bindings involving custom type aliases"
  (check-equal?
    @typecheck{
      type String = Char[];
      s => String;
      def s = "hello world";

      s;
    }
    '(App List (Char))))

(test-case "it checks annotations on variable bindings in functions"
  (check-equal?
    @typecheck{
      fun f() {
        x => Int;
        def x = 1;
        x + 2;
      };

      f();
    }
    'Int))

(test-case "it fails if annotations don't match inferred types (monomorphic)"
  (check-match
    @typecheck{
      add => fun(Int, Int) : Int;
      fun add(x, y) = False;
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

(test-case "it checks annotated function definitions"
  (check-equal?
    @typecheck{
      f<a> => fun(a) : a;
      fun f(x) = x;

      f(42);
    }
    'Int))

(test-case "it checks annotated functions with recursive application"
  (check-equal?
    @typecheck{
      len<a> => fun(a[]) : Int;
      fun len([]) = 0;
      fun len(x::xs) { 1 + len(xs); };

      len([1, 2]);
    }
    'Int))

(test-case "it fails in ill-typed application of annotated functions"
  (check-match
    @typecheck{
      len<a> => fun(a[]) : Int;
      fun len([]) = 0;
      fun len(x::xs) { 1 + len(xs); };

      len(3);
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected (App List (,t))) (Got Int)))))

(test-case "it fails if return values are of different type params"
  (check-match
    @typecheck{
      def f = fun(x, y) { if (True) { x; } else { y; }; };
      f(1, False);
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

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
      type String = Char[];
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
              (App Tuple ((App (TyFun () (App List (Char))) ())))))))
       ())))

(test-case "it fails on ill-typed ADT constructor applications"
  (check-match
    @typecheck{
      type String = Char[];
      type Rope =
        | Leaf String
        | Node Int Rope Rope
        ;

      Leaf(False);
    }
    `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected (App List (Char))) (Got Bool)))))

(test-case "it checks recursive ADT's"
  (check-match
    @typecheck{
      type String = Char[];
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
             ((App Tuple (Int (App (TyFun () (App List (Char))) ())))
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
    `(AtPos
       ,_
       (CompilerModule Types)
       (CantUnify
         (Expected (App (Unique (Id A ,_) ,_) ,_))
         (Got (App (Unique (Id B ,_) ,_) ,_))))))

(test-case "it checks annotated functions involving ADT types"
  (check-match
    @typecheck{
      type A = | Foo Int | Bar Int Bool;

      f => fun(A) : A;
      fun f(v) = v;

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
            ((Var ,t1) (App List (Char))))
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
      type String = Char[];
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
    `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule Types) (UnboundUniqIdentifier (Id MakeOpt ,_)))))

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
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id x ,_)))))

(test-case "it does not allow pattern bindings to escape modules"
  (check-match
    @typecheck{
      module Opt {
        type t<a> = | Some a | None;

        def GetOne = fun() { Some(42); };
      };

      switch (Opt.GetOne()) {
        case Some(43) -> False;
        case _ -> True;
      };
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id Some ,_)))))

(test-case "it checks qualified ADT patterns"
  (check-equal?
    @typecheck{
      module Opt {
        type t<a> = | Some a | None;

        def GetOne = fun() { Some(42); };
      };

      switch (Opt.GetOne()) {
        case Opt.Some(43) -> False;
        case _ -> True;
      };
    }
    'Bool))

(test-case "it checks annotated functions on ADT values"
  (check-equal?
    @typecheck{
      type Opt<a> = | Some a | None;

      isSome<a> => fun(Opt<a>) : Bool;
      fun isSome(Some(_)) = True;
      fun isSome(_) = False;

      isNone<a> => fun(Opt<a>) : Bool;
      fun isNone(o) { !isSome(o); };

      (isNone(Some(42)), isSome(Some(True)));
    }
    '(App Tuple (Bool Bool))))

(test-case "it checks the annotated unwrap function on polymorphic ADT's"
  (check-equal?
    @typecheck{
      type Opt<a> = | Some a | None;

      unwrap<a> => fun(Opt<a>) : a;
      fun unwrap(Some(x)) = x;

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
    '(App Tuple ((App List (Char)) Int))))

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

      fun sizeImp(tree) {
        switch (tree) {
          case Leaf(_) -> 1;
          case Node(_, left, right) ->
            1 + sizeImp(left) + sizeImp(right);
        };
      };

      sizeExp<a> => fun(BTree<a>) : Int;
      fun sizeExp(Leaf(_)) = 1;
      fun sizeExp(Node(_, left, right)) {
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
    '(App List (Char))))

(test-case "checks a module with common list operations"
  (check-equal?
    @typecheck{
      module IntList {
        type t = Int[];
        type BoolList = Bool[];


        Concat => fun(t, t) : t;
        fun Concat(xs, []) { xs; };
        fun Concat([], ys) { ys; };
        fun Concat(x::xs, ys) {
          x :: Concat(xs, ys);
        };

        Map => fun(fun(Int) : Bool, t) : BoolList;
        fun Map(f, []) { []; };
        fun Map(f, x::xs) {
          f(x) :: Map(f, xs);
        };
      };

      [
        IntList.Concat([], []),
        IntList.Concat([1, 2], []),
        IntList.Concat([1, 2], [3, 4, 5])
      ];
    }
    '(App List ((App List (Int))))))

(test-case "it checks functions with argument types accepting multiple type params"
  (check-match
    @typecheck{
      type t<k, v> = (k, v)[];

      insert<k, v> => fun(t<k, v>, k, v) : t<k, v>;
      fun insert(map, key, val) { (key, val) :: map; };

      present<k, v> => fun(t<k, v>, k) : Bool;
      fun present(_, _) = False;

      def m = [(1, "hello")];
      present(m, 3);
    }
    'Bool))

(test-case "it checks implicit functions with argument types accepting multiple type params"
  (check-match
    @typecheck{
      type t<k, v> = (k, v)[];

      fun insert(map, key, val) { (key, val) :: map; };
      fun present(m, k) = False;

      def m = [(1, "hello")];
      present(m, 3);
    }
    'Bool))

(test-case "it checks instance function application"
  (check-equal?
    @typecheck{
      fun (True).isTrue() = True;
      fun (_).isFalse() = False;

      True.isFalse();
    }
    'Bool))

(test-case "it checks instance functions on polymorphic types"
  (check-equal?
    @typecheck{
      fun ([]).isEmpty() = True;
      fun (x::xs).isEmpty() = False;

      ([].isEmpty(), [1, 2].isEmpty(), "hello".isEmpty());
    }
    '(App Tuple (Bool Bool Bool))))

(test-case "it rejects instance function application on incorrect instance types"
  (check-match
    @typecheck{
      fun ([]).isEmpty() = True;
      fun (x::xs).isEmpty() = False;

      23.isEmpty();
    }
    `(CantUnify (Expected (App List ,_)) (Got Int))))
