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

    while (True) {
      def line = IO.ReadLine(in);
      def done = ledger.ProcessCommand(line);

      if (done) {
        break;
      };
    };

    0;
  };
};
