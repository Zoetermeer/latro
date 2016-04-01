import Prims;
import SomethingElse;

ReboundPrims := Prims

m := module {
  type SpecialInt = Int
  type SpecialBool = Bool

  type Custom =
    | Foo Int
    | Bar String
    | Baz SpecialBool Int String

  type WithPaths = | Biz Prims.Int | Fiz SpecialInt Prims.String
}

1 + 2
