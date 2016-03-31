prims := import Primitives;

IO := module {
  interface InputPort { ... }

  interface OutputPort { ...  }

  fun [InputPort P] ReadLine(P) : String
  ReadLine(port) := {
    prims.ReadLine(port)
  }
}
