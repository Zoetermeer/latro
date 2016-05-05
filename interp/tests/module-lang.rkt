#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it checks scalar-type interface implementations"
  (check-equal?
    @typecheck{
      interface Show<a> {
        show => fun(a) : String;
      };

      ToString<a> => fun(default Show<a>) : String;
      ToString(v, S) { S.show(v); };

      ShowBool => module : default Show<Bool>;
      ShowBool = module {
        show => fun(Bool) : String;
        show(True) { "True"; }
        show(False) { "False"; };
      };

      ToString(False);
    }
    'String))

(test-case "it checks polymorphic-type interface implementations"
  (check-equal?
    @typecheck{
      interface Show<a> {
        show => fun(a) : String;
      };

      ToString<a> => fun (a, default Show<a>) : String;
      ToString(v, S) { S.show(v); };

      ShowBool => module : default Show<Bool>;
      ShowBool = module {
        show => fun(Bool) : String;
        show(True) { "True"; }
        show(False) { "False"; };
      };

      ShowList<a> => module (default Show<a>) : default Show<a[]>;
      ShowList = module (AShow) {
        show => fun(a[]) : String;
        show([]) { "[]"; }
        show(x::xs) { AShow.show(x) :: show(xs); };
      };

      ToString([False, True]);
    }
    'String))

(test-case "it checks alternate-use interface implementations on polymorphic types"
  (check-equal?
    @typecheck{
      interface Show<a> {
        show => fun(a) : String;
      };

      ToString<a> => fun(a, default Show<a>) : String;
      ToString(v, S) { S.show(v); };

      ShowBool => module : default Show<Bool>;
      ShowBool = module {
        show => fun(Bool) : String;
        show(True) { "True"; }
        show(False) { "False"; };
      };

      ShowList<a> => module (default Show<a>) : default Show<a[]>;
      ShowList = module (AShow) {
        show => fun(a[]) : String;
        show([]) { "[]"; }
        show(x::xs) { AShow.show(x) :: show(xs); };
      };

      OtherShowList<a> => module (default Show<a>) : Show<a[]>;
      OtherShowList = module (AShow) {
        show => fun(a[]) : String;
        show([]) { "it's empty"; }
        show(_::_) { "it's not empty"; };
      };

      ToString([False, True], OtherShowList);
    }
    'String))
