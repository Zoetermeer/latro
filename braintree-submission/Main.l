import Core

Main := module {
  : Entrypoint {
    Main(_) := {
      ledger := Accounts.Ledger{ }
      while (True) {
        line := IO.ReadLine(IO.Stdin);
        done := ledger.ProcessCommand(line);

        if (done) {
          break;
        }
      }

      0
    }
  }
}
