type String = Char[];

type Maybe<a> =
  | Some a
  | None
  ;

def Num = module {
  def add = fun(x, y) { x + y; };
  def sub = fun(x, y) { x - y; };

  read => fun(String) : Int;
  read(_) { 0; };
};

def List = module {
  append<a> => fun(a[], a[]) : a[];
  append([], bs) { bs; }
  append(as, []) { as; }
  append(a::as, bs) {
    a :: append(as, bs);
  };

  reverse<a> => fun(a[]) : a[];
  reverse([]) { []; }
  reverse(x::xs) {
    append(reverse(xs), [x]);
  };
};

def Str = module {
  words' => fun(String, String) : String[];
  words'("", s) { [List.reverse(s)]; }
  words'(c::cs, s) {
    switch ([c]) {
      case " " -> List.reverse(s) :: words'(cs, "");
      case _ -> words'(cs, c :: s);
    };
  };

  def words = fun(s) { words'(s, ""); };
};

def Map = module {
  type t<k, v> = (k, v)[];

  insert<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  insert(map, key, val) { (key, val) :: map; };

  update<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  update(map, key, val) { insert(map, key, val); };

  find<k, v> => fun(t<k, v>, k) : Maybe<v>;
  find(_, _) { None(); };
};

def Accounts = module {
  type Username = String;
  type CardNumber = String;
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

  type Ledger = Map.t<Username, Amount>;

  applyBalanceCharge => fun(Ledger, Username, Amount, fun(Amount, Amount) : Amount) : Ledger;
  applyBalanceCharge(ledger, name, amount, f) {
    switch (Map.find(ledger, name)) {
      case Some(balance) -> Map.update(ledger, name, f(balance, amount));
      case _ -> ledger;
    };
  };

  executeCommand => fun(Ledger, Command) : Ledger;
  executeCommand(ledger, Add(name, cardNumber, balance)) {
    Map.insert(ledger, name, balance);
  }

  executeCommand(ledger, Charge(name, amount)) {
    applyBalanceCharge(ledger, name, amount, Num.sub);
  }

  executeCommand(ledger, Credit(name, amount)) {
    applyBalanceCharge(ledger, name, amount, Num.add);
  }

  executeCommand(ledger, _) { ledger; };


  parseCommand => fun(String) : (Command, Bool);
  parseCommand(s) {
    switch (Str.words(s)) {
      case ["Add", name, cardNumber, amount] -> (Add(name, cardNumber, Num.read(amount)), False);
      case ["Charge", name, amount] -> (Charge(name, Num.read(amount)), False);
      case ["Credit", name, amount] -> (Credit(name, Num.read(amount)), False);
      case _ -> (Quit(), True);
    };
  };


  processCommands => fun(Ledger, String[]) : Ledger;
  processCommands(ledger, []) { ledger; }
  processCommands(ledger, line::lines) {
    def (cmd, shouldQuit) = parseCommand(line);
    processCommands(executeCommand(ledger, cmd), lines);
  };
};

def lines = [
  "Add James 1234 100",
  "Charge James 10",
  "Add John 1 2"
];

def ledger = [];
Accounts.processCommands(ledger, lines);



