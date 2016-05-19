def Prims = module {
  type Char = Byte;
  type String = Char[];

  interface Eq<A> {
    (==) => fun(A, A) : Bool;
    (!=) => fun(A, A) : Bool;
  };

  interface Ord<A> {
    (<) => fun(A, A) : Bool;
    (>) => fun(A, A) : Bool;
    (<=) => fun(A, A) : Bool;
    (>=) => fun(A, A) : Bool;
  };

  interface Show<A> {
    Show => fun(A) : String;
  };


  Split => fun(String)(String) : String[];
  ("").Split(sep) := { [] }
  (str).Split(sep) := {

  };


  type Option<T> = Some T | None;

  ShowOpt<T> => default Show<Option<T>>(default Show<T>);
  module(ShowT) {
    (Some(t)).Show() { "Some #{t.Show()}"; }
    (None).Show() { "None"; };
  };


  EqOpt<T> => default Eq<Option<T>>(default Eq<T>);
  module(EqT) {
    (==)(Some(a), Some(b)) { a == b; }
    (==)(None(), None()) { True; }
    (==)(_, _) { False; };

    (!=)(a, b) { !(a == b); };
  };
}

def `Prims Tests` = test module {
  def `Option Tests` = test module {
    def `IsSome/None` = test module {
      def `it returns true for Somes` = fun() {
        Check((Some 42).IsSome() == True);
      };

      def `it returns false for Nones` = fun() {
        Check((None).IsSome() == False);
      };
    };
  };
};

def Hash = module {
  /*

    Functions with patterns are desugared using the following rule:

    (<instance-pat1>).Id(<arg-pat1> ...) := body1
    (<instance-pat2>).Id(<arg-pat2> ...) := body2

    -->

    Id(instance, arg1, ...) := {
      match (instance, arg1, ...) with
        | (<instance-pat1>, <arg-pat1>, ...) -> body1
        | (<instance-pat2>, <arg-pat2>, ...) -> body2
    }

  */

  type Hash<K, V> = struct {

  };

  Find<K, V> => fun(Hash<K, V>)(K) : Option<V>;
  (hash) Find(key) {
    None();
  };


  Insert<K, V> => fun(Hash<K, V>)(K, V) : Unit;
  (hash).Insert(key, value) {
    ();
  };


  Update<K, V> => fun(Hash<K, V>)(K, V, fun(V) : V) : Unit;
  (this).Update(key, value, updateExisting) {
    ();
  };
}

def Executables = module {
  interface Entrypoint {
    Main => fun(String[]) : Int;
  };
};

def Core = module {
  include Prims;
  include Hash;
  include Executables;
};
