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

has type 'module { f : <type of f>, g : <type of g> }'.  A value
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

Type-checks, and its type is 'Int'.  Both modules and data type instances
can be 'downcast' to interface types if some subset of their exports
match those defined by the interface type.

Interface types are a bit more generic than either 'module' or 'data' types,
since they cannot define types or have any structure other than a collection
of exported value types.

A data type can also downcast to an interface type.  Post-hoc instance function
declarations add exports to a data type, so those factor into interface-type
downcasting.

For interface downcasting, the rules are the same for both:

  1) a polymorphic module with a single type parameter
  2) a data type with some set of fields and/or instance functions

An interesting example is the 'Show' interface.  Its definition is:

::

  interface <a> Show {
    fun show(a) : String;
  }

An implementation for user-defined booleans might be:

::

  type Bool = | True | False ;

  def ShowBool = implicit module : <Bool> Show {
    show(True) = { "True"; };
    show(False) = { "False"; };
  }

However we could also achieve the same effect with:

::

  fun (Bool) show() : String;
  (True).show() { "True"; };
  (False).show() { "False"; };

Thus some function which expects a Show instance such as:

::

  (fun(v) { v.show(); })

Could accept either implementation:

::

  True.show()

Implicits for polymorphic types?

Syntax options for implicit/default modules
-------------------------------------------

::

  def ShowList = <a> implicit module : <a[]> Show
      where a : Show {
    show([]) { "[]"; };
    show(x::xs) { show(x) :: show(xs); };
  }

Or:

::

  def ShowList = Show a => <a> default module : <a[]> Show {
    show([]) { "[]"; };
    show(x::xs) { show(x) :: show(xs); };
  }
