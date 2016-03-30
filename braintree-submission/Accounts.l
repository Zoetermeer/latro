import Core

namespace Accounts {
  type Command =
      Add String String Int
    | Charge String Int
    | Credit String Int
    | Quit

  type Ledger = struct {
    [String, Account] Hash Entries;
  }

  fun (this Ledger) ProcessCommand(String line) : Bool {
    parts := line.Split(" ");
    command := match parts with
      | ["Add", name, cardNumber, amount] -> Add name cardNumber amount
      | ["Charge", name, amount] -> Charge name amount
      | ["Credit", name, amount] -> Credit name amount
      | ["Quit"] -> Quit
      ;
  }
}
