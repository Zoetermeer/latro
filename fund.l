namespace AccountsProgram {
  Database := module {
    type Connection = struct { }
    type Row = struct { }

    fun (this Connection) Query(string query) : Row[] {

    }
  }

  type Fund = struct {
    string ShortName;
    string LongName;
    float64 Balance;
    uint AccountID;
    Accounts.Account Account;
    Transaction List Transactions;
  }


  interface [T] Show {
    fun (T) Show() : string
  }


  type [T] Table = interface {
    fun FindAll(Database.Connection) : T[]
    fun Read(Database.Row) : T
  }


  interface [T] Table {
    fun FindAll(Database.Connection) : T[]
    fun Read(Row) : T
  }


  //Modules are first-class, and both data (structs) and
  //modules have types.  Module types are inferred.
  //Module types cannot be polymorphic.

  //Post hoc typeclass instantiation for a (struct) type
  Fund : Show {
    fun (this Fund) Show() : string {
      this.LongName
    }
  }


  Funds := module {
    //Define-site typeclass instantiation
    : Show {
      fun (this typeof(Funds)) Show() : string {
        "the Funds module!"
      }
    }
  }


  fun [Show S] PrintIt(S s) : unit {
    printf("%v\n", s);
  }


  fun PrintAllTheThings() : unit {
    PrintIt(Fund { });
    PrintIt(Funds);
  }


  //Post hoc typeclass instantiation for a module
  Funds : Fund Table {
    fun FindAll(Database.Connection option db) : Fund[] {
      db' := Database.EnsureReady(db);
      rows := db'.Query("SELECT * FROM funds");

      for row : rows {

      }
    }
  }


  type Accounts = module {
    type Account = {
      ...
    }

    FindByShortName(string shortName) : Account option {
      None
    }

    : Account Table {
      fun FindAll(Database.Connection db) : Account[] {

      }
    }
  }
}
