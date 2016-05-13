.. contents::

IL translation
==============

The typechecker should produce an IL tree as
part of its typecheck/transform process, to keep the
evaluator simple.  We want to produce as output from the TC
something that holds as much information as we can determine
statically as possible.


Demodularization
----------------

I think we can replace all qualified id's with
unique-id references, since all of these references are resolved
statically anyway.  Unbound-id errors are not possible by the
time we get to the evaluator.

Type declarations can be thrown out completely by the TC.


Pattern desugaring
------------------

switch (E1) { ... } --> def x = E1; switch (x) { ... };

DESUGAR(E, _ -> ES) --> ES
DESUGAR(E, x -> ES) --> def x = E;
DESUGAR(E, (P1, ..., PN) -> ES
  -->
  if (DESUGAR(get(E, 0), P1)) {

  } else 
