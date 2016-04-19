.. contents::

Types and interfaces
====================

There are *types* and *interfaces*.  An interface is analogous to a
typeclass in Haskell.

With the examples as written, there are two kinds of types:

  - Data types (scalars, ADT's, structures)
  - Module types

Both kinds of types can have functions/behaviors associated with them
via post-hoc definitions, and both can also implement any number
of interfaces.

The value:

::

  module {
    f = ...
    g = ...
  }

has type ``module { f : <type of f>, g : <type of g> }``.  A value
of module type can also satisfy the type requirement of a function
accepting some interface that exports a subset of the module type's
exports.  So:

::

  def f = fun(x) { x.g; };

Is type-inferred to be this function:

::

  poly<a> (fun(interface { g : a }) : a)

And the expression:

::

  f(module { def g = 42; });

Type-checks, and its type is ``Int``.  Both modules and data type instances
can be 'downcast' to interface types if some subset of their exports
match those defined by the interface type.

Interface types are a bit more generic than either ``module`` or "data" types,
since they cannot define types or have any structure other than a collection
of exported value types.

A data type can also downcast to an interface type.  Post-hoc instance function
declarations add exports to a data type, so those factor into interface-type
downcasting.

For interface downcasting, the rules are the same for both:

  1) a polymorphic module with a single type parameter
  2) a data type with some set of fields and/or instance functions


Example: the ``Show`` interface
---------------------------

An interesting example is the ``Show`` interface.  Its definition is:

::

  interface Show<a> {
    fun show(a) : String;
  };


  ToString<a> => fun (a)(default Show<a>) : String;
  (v).ToString(S) { S.show(v); };

An implementation for user-defined booleans might be:

::

  type Bool = | True | False ;

  ShowBool => default (Show<Bool>);
  def ShowBool = module : Show<Bool> {
    show(True) { "True"; };
    show(False) { "False"; };
  };

However we could also achieve the same effect with:

::

  fun (Bool) show() : String;
  (True).show() { "True"; };
  (False).show() { "False"; };


::

  True.ToString();
  False.ToString();

An important question is how we deal with interfaces on polymorphic
types (what does the Show implementation look like for ``List``?).

Syntax options for polymorphic implicit/default modules
-------------------------------------------------------

::

  def ShowList = Show a => <a> default (<a[]> Show) {
    show([]) { "[]"; };
    show(x::xs) { show(x) :: show(xs); };
  }

Or:

::

  ShowList => default (default Show<a>) : Show<a[]>;
  ShowList = module(AShow) {
    show => fun(a[]) : String;
    show([]) = { "[]"; }
    show(x::xs) { AShow.show(x) :: show(xs); };
  };

How do we express multiple constraints in the option 3 syntax?
Here's a solution for 2-tuples:

::

  module ShowTup<a, b>(default Show<a>, default Show<b>) : default (Show (a, b));
  ShowTup = module(ShowA, ShowB) {
    fun show((a, b)) : String;
    show((x, y)) = { (ShowA.show(a), ShowB.show(b)); };
  };

Modules like ``ShowList`` and ``ShowTup`` require default modules
for ``Show`` implementations on their component types.  How do we explicitly
supply an alternate module?

::

  def AlternateShowList = module {
    [].show() { "it's empty"; };
    (_::_).show() { "it's not empty"; };
  };

  fun <a> UserDefinedToString(a[]) : String;
  UserDefinedToString(vs) {
    v.show(AlternateShowList);
  };

We might want to allow substitution of a default module with an alternate
one in a dynamic scope:

The corresponding "implicit" implementation of ``Show`` for lists using
instance functions would be:

::

  fun Show a => <a> (a[]).show() : String;
  ([]).show() { "[]"; }
  (x::xs).show() { x.show() :: xs.show(); };

Perhaps it would make more sense to require the module-based implementation use
instance functions also:

::

  def ShowList = Show a => <a> default module : <a[]> Show {
    ([]).show() { "[]"; };
    (x::xs).show() { show(x) :: show(xs); };
  }

But then that would probably require the interface definition to explicitly require
instance functions also:

::

  interface <a> Show {
    fun (a).show() : String;
  }

*Maybe we should use the word "implicit" to mean an instance-function implementation of
an interface (we do not explicitly mention the interface, but just implement the requisite
functions), and "default" where in Scala or ML we would use the word "implicit".*

::

  def AlternateShowList = module {
    [].show() { "it's empty"; };
    (_::_).show() { "it's not empty"; };
  };

  fun <a> UserDefinedToString(a[]) : String;
  UserDefinedToString(vs) {
    using <a[]> Show = AlternateShowList;
    v.show();
  };

Open questions
==============

  * Can we define an instance function on a module type?
