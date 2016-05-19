import Core

Program => default Entrypoint;
Program = module {
  Main => fun(String[]) : Int;
  Main(args) {
    def ledger = Accounts.Ledger{ };
    def in = switch (args) {
      case [filePath] -> IO.OpenFile(filePath);
      case _ -> IO.Stdin;
    };

    def loop = fun(line) {
      def done = ledger.ProcessCommand(line);

      if (!done) {
        loop(IO.ReadLine(in));
      } else {
        ();
      }
    }

    loop(IO.ReadLine(in));
    0;
  };
};
