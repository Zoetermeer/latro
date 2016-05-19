def Core = module {
  type String = Char[];

  type Maybe<a> =
    | Some a
    | None
    ;
};

def Num = module {
  def add = fun(x, y) { x + y; };
  def sub = fun(x, y) { x - y; };
};

def Str = module {
  split => fun(Core.String, Core.String) : Core.String[];
  split(s, "") { [s]; }
  split(s, _) { [s]; };
};

def Map = module {
  type t<k, v> = (k, v)[];

  insert<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  insert(map, key, val) { (key, val) :: map; };

  update<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  update(map, key, val) { insert(map, key, val); };

  find<k, v> => fun(t<k, v>, k) : Core.Maybe<v>;
  find(_, _) { Core.None(); };
};

def Accounts = module {
  type Username = Core.String;
  type CardNumber = Core.String;
  type Amount = Int;

  type Command =
    | Add Username CardNumber Amount
    | Charge Username Amount
    | Credit Username Amount
    | Quit
    ;

  type Account = struct {
    Username Name;
    CardNumber CardNumber;
    Amount Balance;
  };

  type Ledger = Map.t<Username, Account>;

  applyBalanceCharge => fun(Ledger, Username, Amount, fun(Amount, Amount) : Amount) : Ledger;
  applyBalanceCharge(ledger, name, amount, f) {
    switch (Map.find(name)) {
      case Core.Some(account) ->
        Map.update(name, f(0, amount));
      case _ -> ledger;
    };
  };

  executeCommand => fun(Ledger, Command) : Ledger;
  executeCommand(ledger, Add(name, cardNumber, balance)) {
    def acct = Account {
      Name = name;
      CardNumber = cardNumber;
      Balance = amount;
    };

    Map.insert(name, acct);
  }

  executeCommand(ledger, Charge(name, amount)) {
    applyBalanceCharge(ledger, name, amount, Core.sub);
  }

  executeCommand(ledger, Credit(name, amount)) {
    applyBalanceCharge(ledger, name, amount, Core.add);
  }

  executeCommand(ledger, _) { ledger; };


  def parseCommand = fun(s) {
    switch (Str.split(s, " ")) {
      case ["Add", name, cardNumber, amount] -> (Add(name, cardNumber, amount), False);
      case ["Charge", name, amount] -> (Charge(name, amount), False);
      case ["Credit", name, amount] -> (Credit(name, amount), False);
      case _ -> (Quit(), True);
    };
  };


  processCommands => fun(Ledger, Core.String[]) : Ledger;
  processCommands(ledger, []) { ledger; }
  processCommands(ledger, line::lines) {
    def cmd = parseCommand(line);
    processCommands(executeCommand(ledger, cmd), lines);
  };
};

def lines = [
  "Add James 1234 100",
  "Charge James 10"
];

def ledger = [];
def ledger' = processCommands(ledger, lines);
