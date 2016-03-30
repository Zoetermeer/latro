import Core

Main := module {
  : Entrypoint {
    fun Main(String[] _) : Int {
      ledger := Accounts.Ledger{ }
      while (true) {
        line := IO.ReadLine(IO.Stdin);
        shouldExit := ledger.ProcessCommand(line);

        if (shouldExit) {
          break;
        }
      }

      0
    }
  }
}
