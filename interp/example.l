import Prims;
import SomethingElse;

def ReboundPrims = Prims;

def m = module {
  type SpecialInt = Int;
  type SpecialBool = Bool;

  type Custom =
    | Foo Int
    | Bar String
    | Baz SpecialBool Int String
    ;

  type WithPaths = | Biz Prims.Int | Fiz SpecialInt Prims.String;

  def f = fun() {
    m'.g();
  };
};

def m' = module {
  def g = fun() {
    42;
  };
};

m.v();
