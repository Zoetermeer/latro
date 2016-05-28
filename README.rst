=====
Latro
=====

:Author: James Swaine <james.swaine@gmail.com>

Latro is a general-purpose functional programming language designed
to make people more productive.  It does not attempt to include every
esoteric language feature, or bury you in cryptic discourse on
bleeding-edge type theory.  The goal is to blend some of the core
ideas of functional programming into a clear, concise syntax that
will appear familiar to people more accustomed to popular languages
like Ruby, Java, and Go -- and bundle it in an easy-to-use 
build/package ecosystem.

.. contents::


Overview
========

Overview here

Quick language guide
====================

This section serves as a guided tour through the features
of the language.  Eventually this material will be moved and 
incorporated into a broader guide, complete with reference material.

Built-in types and literal expressions
--------------------------------------

The language supports five basic types out of the box:
integers, booleans, characters, singly-linked lists,
tuples containing an arbitrary number of components, and functions.  We write
these types in annotations like so:

  - ``Int`` is the integer type
  - ``Bool`` is the boolean type
  - ``Char`` is the Unicode character type
  - ``t[]`` is a list with elements of type ``t``
  - ``Int[]`` is a list of integers
  - ``(Int, Bool)`` is the type of 2-tuples with an ``Int`` and ``Bool`` component
  - ``fun(Int, Bool) : Bool`` is the type of functions accepting an
    ``Int`` and ``Bool`` argument, and returning a ``Bool``

Literal values for each of the built-in types can be written directly, e.g:

  - ``42`` is an ``Int``
  - ``False`` is a ``Bool``
  - ``'m'`` is a ``Char`` representing the character ``m``
  - ``[1, 2, 3]`` is an ``Int[]`` with 3 elements
  - ``(1, True)`` is a ``(Int, Bool)`` tuple

Additionally, we can write string literals using the familiar double-quoted
syntax, e.g. ``"hello world"``.  The type of a string literal is ``Char[]``
(a list of characters).

Latro can infer the types of variables and functions, but we can also "fix"
the type of a value using an annotation:

.. code:: ocaml

  f => fun(Int, Bool) : Bool;
  fun f(i, b) = b;

If we were to omit the annotation from above, like so:

.. code:: ocaml

  fun f(i, b) = b;

Latro would infer the type of this function to be a polymorphic one returning
its second argument: ``fun<a, b>(a, b) : b``.

Sometimes we may want to define _type aliases_ for types to give them special 
meaning; for example, we may want to define a name ``String`` that really
just represents the type ``Char[]``.  We will see how to do this in a
subsequent section.

Basic expressions
-----------------

Latro supports a few primitive operations on built-in types, such as integer
arithmetic: ``1 + 2``, ``1 * 3 - 2 + 4``.

We can yield the negation of a ``Bool`` with the ``!`` operator: ``!False``.

Lists can be constructed using the right-associative cons operator ``::``

.. code:: ocaml

  1 :: 2 :: [3, 4, 5]  // [1, 2, 3, 4, 5]

No language would be complete without variable bindings.  We define these using
``def``:

.. code:: ocaml

  def x = 42;
  def y = 43;
  x + y;

Note that in sequences of expressions, we use the semicolon (``;``) as a delimiter as
in C-family languages.

Conditionals
------------

Latro offers two main forms of conditionals: ``if``/``then``/``else`` and ``cond``.

.. code:: ocaml

  def v = if (True) { 42; } else { 43; };
  v; // 42

The ``else`` is required, and both branches of a conditional must be of the same type.

To avoid the hassle of writing complex sequences of ``if`` expressions, we can use
the ``cond`` form:

.. code:: ocaml

  def b1 = True;
  def b2 = False;
  cond {
    case and(b1, b2) -> 42;
    case or(b1, b2)  -> 43;
    case _           -> 44;
  }; // 43

Note that we can use arbitrary expressions and/or functions in the test
expression for a ``case``.  The compiler will not verify exhaustiveness for a ``cond``,
so we may end up with a runtime exception if we don't include an explicit catch-all case
(e.g. ``case _ -> ...``).

Patterns and ``switch``
-----------------------

In any binding using ``def`` (and also in function arguments, as we will see) we can use
*patterns* to destructure a value and introduce new bindings for its subcomponents.
For example, we may want to bind elements of a list:

.. code:: ocaml

  def ls = [1, 2, 3, 4, 5];
  def [_, _, x, y, z] = ls;
  [x, y, z];

Yields the list ``[3, 4, 5]``.  We can also use the cons operator to destructure:

.. code:: ocaml

  def ls = [1, 2, 3, 4, 5];
  def x::_ = ls;
  x;

Yields the list ``[2, 3, 4, 5]``.  Notice also that we can use the wildcard pattern
(``_``) in places where we wish to ignore certain parts of a value.

Patterns can be used to do arbitrary traversals on a complex value:

.. code:: ocaml

  def ls = [[(1, 2)], [(3, 4), (5, 6)]];
  def [[(x, _)], (_, y) :: _] = ls;
  x + y;

Produces ``5``.

Note that patterns on ``def`` bindings can be unsafe, because the value on the
right-hand side of the binding may not match exactly the pattern used (although
patterns are typechecked to eliminate simple mistakes).  This program:

.. code:: ocaml

  def [x, y, z] = [1, 2];

Results in a runtime exception because the right-hand side only contains two elements,
not three.

Functions
---------

Functions can be defined and used in several different ways.  We can make anonymous ones:

.. code:: ocaml

  (fun(x) = x)(42); // 42

Or bind them to names:

.. code:: ocaml

  fun add1(x) = x + 1;
  add1(2); // 3

They can also use a long-form "block" for the body:

.. code:: ocaml

  fun add1AndMultBy3(x) {
    (x + 1) * 3;
  };

Function definitions also support a powerful "clause" definition style,
in which we can define alternative implementations with patterns on arguments.
For example, here is the Fibonacci sequence in Latro:

.. code:: ocaml

  fun fib(0) = 0;
  fun fib(1) = 1;
  fun fib(n) = fib(n - 1) + fib(n - 2);

As shown above, we can annotate functions with types to avoid over-generalizing
by the type inference engine (or just to be clearer about a function's prototype):

.. code:: ocaml

  fib => fun(Int) : Int;
  fun fib(0) = 0;
  fun fib(1) = 1;
  fun fib(n) = fib(n - 1) + fib(n - 2);

Functions can also be bound using the familiar ``def`` syntax, although functions
defined in this way will not have their names bound in the body (so they cannot
be recursive):

.. code:: ocaml

  def f = fun(x) = x;

The compiler will complain if we try to implement Fibonacci using this form:

.. code:: ocaml

  def fib = fun(x) {
    switch (x) {
      case 0 -> 0;
      case 1 -> 1;
      case n -> fib(n - 1) + fib(n - 2); // ERROR: Unbound identifier 'fib'!
    };
  };

Algebraic data types
--------------------

Latro supports *algebraic data types*, also known as "sum types" or "discriminated
unions" in functional-programming lexicon.  For example, we could define a type
of optionals:

.. code:: ocaml

  type Option<a> =
    | Some a
    | None
    ;

Doing so gives us constructors for each alternative we can use to build values of
type ``Option<a>``:

.. code:: ocaml

  def v = Some(42); // Option<Int>

We can deconstruct ADT values in any place where we can use patterns:

.. code:: ocaml

  type Option<a> =
    | Some a
    | None
    ;
  
  fun or(True, True) = True;
  fun or(True, _) = True;
  fun or(_, _) = False;
  
  fun isSome(Some(_)) = True;
  fun isSome(_) = False;
  
  def a = Some(False);
  def Some(x) = a;
  
  or(x, isSome(a)); // True

Structures
----------

We can define types that are just records containing an
arbitrary number of named fields:

.. code:: ocaml

  type Person = struct {
    Name Char[];
    Age Int;
  };
  
  def p = Person { Name = "john"; Age = 42; };

Like ADT's, structure types can be polymorphic:

.. code:: ocaml

  type Person<a> = struct {
    Name Char[];
    Age Int;
    CustomData a;
  };
  
  def p1 = Person { Name = "john", Age = 42; CustomData = False; };
  def p2 = Person { Name = "jim", Age = 41, CustomData = [1, 2, 3]; };

Modules
-------

Types, values, and functions which are all related in some way can be
grouped into modules like so:

.. code:: scala

  module String {
    type t = Char[];
    
    len => fun(t) : Int;
    fun len("") = 0;
    fun len(c::cs) = 1 + len(cs);
  };
  
  String.len("hello world"); // 11

Note also here we are using a list pattern on strings, which works because
string are really just a list of Unicode characters.

Modules can also be arbitrarily nested:

.. code:: scala

  module StringStuff {
    type t = Char[];
    module ExtraStringStuff {
      append => fun(t, t) : t;
      fun append(c::cs, b) = c :: append(cs, b);
      fun append(_, b) = b;
    };
  };
  
  StringStuff.ExtraStringStuff.append("hello", " world"); // "hello world"

Submodules can refer to all of the types and/or values defined 
in parent modules directly, as the ``ExtraStringStuff`` module
refers directly to the type ``t`` above.

Examples
========

A few more sophisticated examples can be found in the examples directory.
All of the examples work on the latest version of Latro at HEAD.

  - `Braintree code submission`_
  - `Rope data structure implementation`_
  - `Basic string-utilities module implementation`_
  
.. _Braintree code submission: https://github.com/Zoetermeer/L/blob/master/examples/braintree-submission/basic/Accounts.l
.. _Rope data structure implementation: https://github.com/Zoetermeer/L/blob/master/examples/rope/rope.l
.. _Basic string-utilities module implementation: https://github.com/Zoetermeer/L/blob/master/examples/string/string.l


Building/running the interpreter
================================

Latro is a language still in the experimental/pre-alpha stage, and both
syntax and semantics are rapidly evolving.  You can use the prototype
interpreter to execute programs, but a compiler "back end" that generates
machine-code binaries does not exist yet.

The interpreter is implemented in Haskell and can be built using any
modern compiler for that language (GHC, for example).  All code for the
interpreter is in the ``interp`` directory.

Running the interpreter:

::

  $> latro [OPTIONS] <file1> <file2> ...

Runs the interpreter on the program given in the files.

Switches:

--help                Display help information.
-p                    Don't evaluate, just dump a parse tree.
-a                    Don't evaluate, just dump an alpha-converted syntax tree.
-t                    Don't evaluate, just dump a type-annotated syntax tree.
-tc                   Don't evaluate, just display the type of the last expression in the executed module.

Running the tests
=================

Latro already has an extensive test suite.  The tests are built in a slightly unorthodox way: the
interpreter executable prints its answers in an S-expression format, and tests are written in Racket
such that S-expressions are read into a Racket test harness.

For example, here's an example test from the interpreter suite:

.. code:: scheme

  (test-case "it evaluates ADT argument patterns"
    (check-equal?
      @interp{
        type IntOption = | Some Int | None ;
  
        IsSome => fun(IntOption) : Bool;
        fun IsSome(Some(_)) = True;
        fun IsSome(_) = False;
  
        def s = Some(42);
        def Some(v) = s;
        (IsSome(None()), IsSome(s), v);
      }
      '(Tuple (False True 42))))

Here's a full-blown example -- the `test suite for the typechecker`_.

.. _test suite for the typechecker: https://github.com/Zoetermeer/L/blob/master/interp/tests/typechecker.rkt


