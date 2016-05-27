type String = Char[];

type Maybe<a> =
  | Some a
  | None
  ;

module Num {
  fun add(x, y) = x + y;
  fun sub(x, y) = x - y;

  //This is impossible to implement right now in pure Latro
  read => fun(String) : Int;
  fun read(_) = 0;
};

module List {
  fun append([], bs) = bs;
  fun append(as, []) = as;
  fun append(a::as, bs) {
    a :: append(as, bs);
  };

  fun reverse([]) = [];
  fun reverse(x::xs) = append(reverse(xs), [x]);
};

module Chars {
  toString => fun(Char) : String;
  fun toString(c) = [c];
};

module Strings {
  words' => fun(String, String) : String[];
  fun words'("", s) = [List.reverse(s)];
  fun words'(c::cs, s) {
    switch (Chars.toString(c)) {
      case " " -> List.reverse(s) :: words'(cs, "");
      case _ -> words'(cs, c :: s);
    };
  };

  fun words(s) { words'(s, ""); };
};

module Map {
  type t<k, v> = (k, v)[];

  insert<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  fun insert(map, key, val) { (key, val) :: map; };

  update<k, v> => fun(t<k, v>, k, v) : t<k, v>;
  fun update(map, key, val) { insert(map, key, val); };

  find<k, v> => fun(t<k, v>, k) : Maybe<v>;
  fun find(_, _) { None(); };
};

module Accounts {
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
  fun applyBalanceCharge(ledger, name, amount, f) {
    switch (Map.find(ledger, name)) {
      case Some(balance) -> Map.update(ledger, name, f(balance, amount));
      case _ -> ledger;
    };
  };

  executeCommand => fun(Ledger, Command) : Ledger;
  fun executeCommand(ledger, Add(name, cardNumber, balance)) {
    Map.insert(ledger, name, balance);
  };

  fun executeCommand(ledger, Charge(name, amount)) {
    applyBalanceCharge(ledger, name, amount, Num.sub);
  };

  fun executeCommand(ledger, Credit(name, amount)) {
    applyBalanceCharge(ledger, name, amount, Num.add);
  };

  fun executeCommand(ledger, _) { ledger; };


  parseCommand => fun(String) : (Command, Bool);
  fun parseCommand(s) {
    switch (Strings.words(s)) {
      case ["Add", name, cardNumber, amount] -> (Add(name, cardNumber, Num.read(amount)), False);
      case ["Charge", name, amount] -> (Charge(name, Num.read(amount)), False);
      case ["Credit", name, amount] -> (Credit(name, Num.read(amount)), False);
      case _ -> (Quit(), True);
    };
  };


  processCommands => fun(Ledger, String[]) : Ledger;
  fun processCommands(ledger, []) = ledger;
  fun processCommands(ledger, line::lines) {
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



