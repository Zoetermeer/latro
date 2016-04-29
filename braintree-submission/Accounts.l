import Core

def Accounts = module {
  type Command =
    | Add String String Int
    | Charge String Int
    | Credit String Int
    | Quit
    ;

  type Account = struct {
    String Name;
    String CardNumber;
    Float Balance;
  };

  type Ledger = struct {
    Hash<String, Account> Entries;
  };

  ApplyBalanceCharge => fun(Ledger)(String, Float, fun (Float, Float) : Float) : Unit;
  (ledger).ApplyBalanceChange(name, amount, f) {
    switch (ledger.Entries.Find(name)) {
      case Some acct ->
        acct.Balance = f(acct.Balance, amount);
      case _ -> ()
    };
  };

  fun (Ledger) ApplyBalanceChange(String, Float, (fun (Float, Float) : Float)) : Unit;
  (ledger).ApplyBalanceChange(name, amount, f) = {
    switch (ledger.Entries.Find(name)) {
      case Some acct ->
        acct.Balance = f(acct.Balance, amount);
      case _ -> ()
    };
  };

  fun (Ledger) ExecuteCommand(Command) : Unit;
  (ledger).ExecuteCommand(Add(name, cardNumber, amount)) = {
    def acct = Account {
      Name = name,
      CardNumber = cardNumber,
      Balance = amount
    };

    ledger.Entries.Insert(name, acct);
  }

  (ledger).ExecuteCommand(Charge(name, amount)) = {
    ledger.ApplyBalanceCharge(name, amount, (-));
  }

  (ledger).ExecuteCommand(Credit(name, amount)) = {
    ledger.ApplyBalanceCharge(name, amount, (+));
  }

  (_).ExecuteCommand(_) { () };


  << Pure >>
  fun ParseCommand(String) : (Command, Bool);
  ParseCommand(commandString) = {
    switch (line.Split(" ")) {
      case ["Add", name, cardNumber, amount] -> (Add name cardNumber amount, False)
      case ["Charge", name, amount] -> (Charge name amount, False)
      case ["Credit", name, amount] -> (Credit name amount, False)
      case _ -> (Quit, True)
    };
  };


  fun (Ledger) ProcessCommand(String) : Bool;
  (ledger).ProcessCommand(line) = {
    def (command, shouldExit) = ParseCommand(line);
    ledger.ExecuteCommand(command);

    shouldExit;
  };
}
