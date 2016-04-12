import Core

def Main := module {
  : Entrypoint {
    Main(_) := {
      def ledger := Accounts.Ledger{ };
      while (True) {
        def line := IO.ReadLine(IO.Stdin);
        def done := ledger.ProcessCommand(line);

        if (done) {
          break;
        };
      };

      0;
    };
  };
};
