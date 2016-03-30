import Core

namespace Accounts {
  type Command =
      Add String String Int
    | Charge String Int
    | Credit String Int
    | Quit

  type Account = struct {
    String Name;
    String CardNumber;
    Float Balance;
  }

  type Ledger = struct {
    [String, Account] Hash Entries;
  }

  fun (Ledger) ApplyBalanceChange(String, Float, (fun (Float, Float) : Float)) : Unit
  (this).ApplyBalanceChange(name, amount, f) := {
    match (this.Entries.Find(name)) with
      | Some acct ->
        acct.Balance = f(acct.Balance, amount);
      | _ -> ()
  }

  fun (Ledger) ExecuteCommand(Command) : Unit
  (this).ExecuteCommand(Add name cardNumber amount) := {
    acct := Account {
      Name = name,
      CardNumber = cardNumber,
      Balance = amount
    };

    this.Entries.Insert(name, acct);
  }

  (this).ExecuteCommand(Charge name amount) {
    match (this.Entries.Find(name)) with
      | Some acct ->
        acct.Balance -= amount;
      | _ -> ()
  }

  (this).ExecuteCommand(Credit name amount) {
    match (this.Entries.Find(name)) with
      | Some acct ->
        acct.Balance += amount;
      | _ -> ()
  }

  (this).ExecuteCommand(_) { () }

  fun (Ledger) ProcessCommand(String) : Bool
  (this).ProcessCommand(line) := {
    parts := line.Split(" ");
    command := match parts with
      | ["Add", name, cardNumber, amount] -> Add name cardNumber amount
      | ["Charge", name, amount] -> Charge name amount
      | ["Credit", name, amount] -> Credit name amount
      | ["Quit"] -> Quit
      ;

    shouldExit := false
    match command with
      | Add name cardNumber amount ->
        
  }
}
