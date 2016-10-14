//The protocol binds `equal` in the variable environment
//to the following type:
//equal : a -> a -> Bool when a : Eq

//Also binding `Eq` to a dictionary, indexed by identifiers on each
//class method, with values their types (including class constraints):
//`Eq` |--> %{
//  `equal` |--> forall a. (a : Eq) a -> a -> Bool
// or:
//  `equal` |--> forall a. (a : Eq) -> (a : Eq) -> Bool
//
// The former is a much closer approximation of the final
// translated function, which takes the (a : Eq) imp dictionary
// as evidence in the first argument
//}

//For any instance, we need to be able to refer to the class declaration
//to confirm whether the bindings we introduce all correspond to bindings
//declared by the class.  (We can't define a method on an instance that
//isn't declared by the class.)
protocol Eq on a {
  equal{b} : a -> a -> Bool
}


//Rules adopted from Haskell 98:
//1) The implementing type must be a type constructor with arity 0 or greater.
//2) For type constructors with arity > 0, each type argument occurring on the
//   right-hand side (head) must also occur in the left-hand side (context)
//   in assertion form (e.g. `C a`, etc.)

imp Int : Eq {
  equal(x, y) = prim(intEq)(x, y)
}


imp Eq of Bool {
  equal(True, True) = True
  equal(False, False) = True
  equal(_, _) = False
}


imp Eq of a[]
  when a => Eq
  when 
{
  equal([], []) = True
  equal(x::xs, y::ys) =
    equal(x, y) && equal(xs, ys)

  equal(_, _) = False
}


imp %(a, b) : Eq
  when a : Eq
  when b : Eq
{
  equal(%(x1, y1), %(x2, y2)) = equal(x1, x2) && equal(y1, y2)
}


type AssocList{k, v} = | AssocList(%(k, v))

lookup{k, v} : k -> AssocList{k, v} -> Maybe{v}
  when k : Ord
lookup(_, []) = Nothing()
lookup(lookupKey, %(key, value) :: rest) =
  cond {
    lookupKey == key -> Just(value)
    _                -> lookup(lookupKey, rest)
  }


// References to overloaded variables (e.g. `equal`)
// will be rewritten as a dictionary lookup, with an
// application on the result.  The result may itself
// be overloaded, in which case the application will
// pass the dictionaries given as constraints on the
// arguments to the overloaded function.

foo{a} : a -> a -> Bool when a : Eq
foo(x, y) = equal(x, y)

bar{b} : b -> b -> Bool when b : Eq
bar(x, y) = foo(x, y)

// ==>
// foo(aEq, x, y) = ?
//
// bar(bEq, x, y) = foo(bEq, x, y)

main(_) = {
  def areEq = areEqual([1, 2], [3, 4, 5])
  prim(println)(areEq)
}
