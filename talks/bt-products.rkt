#lang slideshow
(require "../tests/common.rkt"
         java-lexer
         pict/code
         pict/tree-layout
         racket/draw
         racket/file
         (only-in scribble/manual racketblock racketblock0)
         unstable/gui/scribble)

(define (wrap-with-main code)
  (format "main(_) = ~a" code))

(define (wrap-with-print code)
  (format "main(_) = IO.println(~a)" code))

(define (lines . exprs)
  (string-join exprs "\n"))

(define (interp-print code)
  (interp (wrap-with-print code)))

(define (code-eval-slide title eval-fn code)
  (slide
    #:title title
    (codeblock->pict (java-block code))
    'next
    (text (format "⇒  ~a" (eval-fn code)))))

(define (code-display-slide title . snippets)
  (define code-blocks (map (lambda (code) (codeblock->pict (java-block code))) snippets))
  (apply slide (add-between code-blocks 'next) #:title title))

(define (cblock #:color [color #f] str)
  (define cb (codeblock->pict (java-block str)))
  (if color
    (colorize cb color)
    cb))

(define (box #:color [color "white"])
  (filled-rectangle #:color color 100 100))

(define (small-box #:color [color "white"])
  (filled-rectangle #:color color 50 50))

#| Code in the following (commented) slides
 | is going to be demo'ed via the REPL and/or
 | full-program interpreter
 |
 | The following will use the REPL:
(code-display-slide
  "Literals"
  "42"
  "True"
  "\"hello world\""
  "'c'")

(code-display-slide "Lists" "[2, 3, 4, 5]")
(code-display-slide
  "Lists"
  "def twoToFive = [2, 3, 4, 5]"
  "def oneToFive = 1 :: twoToFive"
  "def zeroToFive = [0, 1] ++ twoToFive")

(code-display-slide
  "Tuples"
  "%(2, \"hello\")"
  "%(\"hello\", 3, \"world\")")

(code-display-slide "Functions" "identity(x) = x")

; The following will use the full-program interpreter:

; 5-function-clauses.l
(code-display-slide
  "Function Clauses"
  (lines
    "fib(0) = 0"
    "fib(1) = 1"
    "fib(n) = fib(n - 1) + fib(n - 2)"))

; 6-type-annotations.l
(code-display-slide
  "Type Annotations"
  (lines
    "fib : Int -> Int"
    "fib(0) = 0"
    "fib(1) = 1"
    "fib(n) = fib(n - 1) + fib(n - 2)"))

; 7-higher-order.l
(code-display-slide
  "Higher-Order Functions"
  (lines
    "square : Int -> Int"
    "square(x) = x * x"
    ""
    "squareEm : Int[] -> Int[]"
    "squareEm(xs) = List.map(square, xs)"))

(code-display-slide
  "Lambdas"
  (lines
    "squareEm : Int[] -> Int[]"
    "squareEm(xs) = List.map(fun(x) = x * x, xs)"))

(code-display-slide
  "Closures"
  (lines
    "adder(x) = fun(y) = x + y"
    ""
    "add5 = adder(5)"))

(code-display-slide
  "Patterns and Recursion"
  (lines
    "length{t} : t[] -> Int"
    "length([]) = 0"
    "length(x::xs) = 1 + length(xs)"))

(code-display-slide
  "Patterns and Definitions"
  (lines
    "isEven(x) = mod(x, 2) == 0"
    ""
    "sumEvens([]) = 0"
    "sumEvens(xs) {"
    "  def %(evens, _) = List.partition(isEven, xs)"
    "  List.foldl((+), 0, evens)"
    "}"))

(code-display-slide
  "Switch"
  (lines
    "fib : Int -> Int"
    "fib(x) = switch(x) {"
    "  case 0 -> 0"
    "  case 1 -> 1"
    "  case n -> fib(n - 1) + fib(n - 2)"
    "}"))

(code-display-slide
  "Conditionals"
  (lines
    "aboutThisNumber(x) ="
    "  if (x < 5) {"
    "    \"it's less than 5\""
    "  } else {"
    "    \"it's greater than or equal to 5\""
    "  }"))

(code-display-slide
  "Conditionals"
  (lines
    "moreAboutThisNumber(x) ="
    "  cond {"
    "    case x < 5 -> \"it's less than 5\""
    "    case x > 5 -> \"it's greater than 5\""
    "    case _     -> \"it's 5\""
    "  }"))

(code-display-slide
  "Custom Infix Operators"
  (lines
    "@(&&)(True, True) = True"
    "@(&&)(_, _)       = False"
    ""
    "and(a, b) = a && b"))

(code-display-slide
  "Algebraic Data Types (ADT's)"
  (lines
    "type Optional{a} ="
    "  | Present(a)"
    "  | Absent"))

(code-display-slide
  "ADT Patterns"
  (file->string "./optional.l"))

|#

(define (phase-box name)
  (define txt (text name))
  (cc-superimpose (box) txt))

(define lex-box (phase-box "Lex"))
(define parse-box (phase-box "Parse"))
(define clause-collapse-box (phase-box "Clause Collapse"))
(define alpha-box (phase-box "Alpha-convert"))
(define infix-box (phase-box "Infix Reorder"))
(define il-box (phase-box "IL Generate"))
(define tc-box (phase-box "Typecheck"))
(define interp-box (phase-box "Evaluate"))

(define top-boxes
  (hc-append
    50.0
    lex-box
    parse-box
    clause-collapse-box
    alpha-box))

(define bot-boxes
  (hc-append
    50.0
    interp-box
    tc-box
    il-box
    infix-box))

(define boxes (vc-append 50.0 top-boxes bot-boxes))

(define (pointing-to a a-find b b-find)
  (set! boxes
    (pin-arrow-line
      20
      boxes
      a a-find
      b b-find)))

(pointing-to lex-box rc-find parse-box lc-find)
(pointing-to parse-box rc-find clause-collapse-box lc-find)
(pointing-to clause-collapse-box rc-find alpha-box lc-find)
(pointing-to alpha-box cb-find infix-box ct-find)
(pointing-to infix-box lc-find il-box rc-find)
(pointing-to il-box lc-find tc-box rc-find)
(pointing-to tc-box lc-find interp-box rc-find)

(slide
  #:title "Compiler Phases"
  boxes)

(slide
  #:title "Lexing"
  (item "Translate source text into a stream of tokens")
  'next
  (codeblock->pict (java-block "def x = 1 + 2 * 3"))
  'next
  (text "⇓")
  (codeblock->pict (java-block "[KwDef, Id(\"x\"), OpEq,\n NumLit(\"1\"), Id(\"+\"),\n NumLit(\"2\"), Id(\"*\"), NumLit(\"3\")]")))

(slide
  #:title "Parsing"
  (item "Translate token stream into a syntax tree")
  'next
  (codeblock->pict (java-block "[KwDef, Id(\"x\"), OpEq,\n NumLit(\"1\"), Id(\"+\"),\n NumLit(\"2\"), Id(\"*\"), NumLit(\"3\")]"))
  (text "⇓")
  (codeblock->pict
    (racketblock
      (ExpAssign
        (PatExpId "x")
        (ExpInfixApp
          (Id "*")
          (ExpInfixApp
            (Id "+")
            (ExpNumLit 1)
            (ExpNumLit 2))
          (ExpNumLit 3))))))

(slide
  #:title "Clause Collapsing"
  (item "Combine function clauses into single functions")
  'next
  (codeblock->pict (java-block "and(True, True) = True\nand(_, _) = False"))
  'next
  (text "⇓")
  (cblock
    (lines
      "and(a, b) {"
      "  def args = %(a, b)"
      "  switch (args) {"
      "    case %(True, True) -> True"
      "    case %(_, _)       -> False"
      "    case _             -> fail(\"Match fail!\")"
      "  }"
      "}")))

(slide
  #:title "Alpha Conversion"
  (item "Rewrite the syntax tree such that all identifiers are unique")
  'next
  (item "Flatten modules into top-level sequences of bindings")
  'next
  (item "Rewrite all qualified identifiers as simple ones"))

(slide
  #:title "Alpha Conversion"
  (item "Two passes")
  'next
  (subitem "Build an environment mapping raw id's to either unique id's or sub-environments")
  'next
  (subitem "Rewrite all raw id references into unique-id references (using the environment)"))

(slide
  #:title "Alpha Conversion"
  (hc-append
    200.0
    (cblock
      (lines
        "module Foo {"
        "  x = 42"
        "  y = x"
        "  z = Bar.x"
        "}"
        "module Bar {"
        "  x = 43"
        "  y = x"
        "}"))
    (cblock
      (lines
        "x@1 = 42"
        "y@2 = x@1"
        "z@3 = x@4"
        ""
        "x@4 = 43"
        "y@5 = x@4"))))

(slide
  #:title "Infix Reordering"
  (item "Rewrite infix applications according to user-defined precedence levels"))

(define white (send the-color-database find-color "White"))
(define black (send the-color-database find-color "Black"))
(define light-red (make-color 255 153 153))
(define light-green (make-color 153 255 153))
(define light-blue (make-color 153 153 255))
(define orange (make-color 255 153 51))
(define purple (make-color 204 153 255))
(define gray (make-color 224 224 224))
(define yellow (make-color 255 255 102))
(define aqua (make-color 204 255 229))

(define (node-box #:color [color "white"] txt)
  (cc-superimpose (small-box #:color color) (cblock #:color "red" txt)))

(define div-node (node-box "/"))
(define sub-node (node-box "-"))
(define mult-node (node-box "*"))
(define plus-node (node-box "+"))
(define one-node (node-box "1"))
(define two-node (node-box "2"))
(define thr-node (node-box "3"))
(define four-node (node-box "4"))
(define five-node (node-box "5"))

(define (infix-slide expr-block desc tree1 tree2)
  (slide
    #:title "Infix Reordering"
    expr-block
    desc
    (hc-append 20.0 tree1 tree2)))

(slide
  #:title "Infix Reordering"
  (cblock "1 + 2 * 3 - 4 / 5")
  'next
  (text "⇓")
  (cblock "(((1 + 2) * 3) - 4) / 5"))

(slide
  #:title "Infix Reordering"
  (cblock "(((1 + 2) * 3) - 4) / 5")
  'next
  (naive-layered
    (tree-layout
       #:pict div-node
       (tree-layout
         #:pict sub-node
         (tree-layout
           #:pict mult-node
           (tree-layout
             #:pict plus-node
             (tree-layout #:pict one-node #f)
             (tree-layout #:pict two-node #f))
           (tree-layout #:pict thr-node #f))
         (tree-layout #:pict four-node #f))
       (tree-layout #:pict five-node #f))))

(define (reset-box-colors!)
  (set! div-node (node-box #:color orange "/"))
  (set! sub-node (node-box #:color purple "-"))
  (set! mult-node (node-box #:color light-red "*"))
  (set! plus-node (node-box #:color light-green "+"))
  (set! one-node (node-box #:color gray "1"))
  (set! two-node (node-box #:color orange "2"))
  (set! thr-node (node-box #:color light-blue "3"))
  (set! four-node (node-box #:color yellow "4"))
  (set! five-node (node-box #:color aqua "5")))

(define (highlight #:color [color "red"] pct)
  (frame pct #:line-width 10 #:color color))

; Swap the + and *
(reset-box-colors!)
(infix-slide
  (cblock "(((1 + 2) * 3) - 4) / 5")
  (cblock "precedence(*) > precedence(+)")
  (naive-layered
    (tree-layout
       #:pict div-node
       (tree-layout
         #:pict sub-node
         (tree-layout
           #:pict (highlight #:color "blue" mult-node)
           (tree-layout
             #:pict (highlight #:color "blue" plus-node)
             (tree-layout #:pict one-node #f)
             (tree-layout #:pict (highlight two-node) #f))
           (tree-layout #:pict (highlight thr-node) #f))
         (tree-layout #:pict four-node #f))
       (tree-layout #:pict five-node #f)))
  (naive-layered
      (tree-layout
         #:pict div-node
         (tree-layout
           #:pict sub-node
           (tree-layout
             #:pict (highlight #:color "blue" plus-node)
             (tree-layout #:pict one-node #f)
             (tree-layout
               #:pict (highlight #:color "blue" mult-node)
               (tree-layout #:pict (highlight two-node) #f)
               (tree-layout #:pict (highlight thr-node) #f)))
           (tree-layout #:pict four-node #f))
         (tree-layout #:pict five-node #f))))

(reset-box-colors!)
(infix-slide
  (cblock "((1 + (2 * 3)) - 4) / 5")
  (cblock "precedence(+) == precedence(-)")
  (naive-layered
      (tree-layout
         #:pict div-node
         (tree-layout
           #:pict (highlight #:color "blue" sub-node)
           (tree-layout
             #:pict (highlight #:color "blue" plus-node)
             (tree-layout #:pict one-node #f)
             (tree-layout
               #:pict mult-node
               (tree-layout #:pict two-node #f)
               (tree-layout #:pict thr-node #f)))
           (tree-layout #:pict four-node #f))
         (tree-layout #:pict five-node #f)))
  (naive-layered
      (tree-layout
         #:pict div-node
         (tree-layout
           #:pict (highlight #:color "blue" sub-node)
           (tree-layout
             #:pict (highlight #:color "blue" plus-node)
             (tree-layout #:pict one-node #f)
             (tree-layout
               #:pict mult-node
               (tree-layout #:pict two-node #f)
               (tree-layout #:pict thr-node #f)))
           (tree-layout #:pict four-node #f))
         (tree-layout #:pict five-node #f))))

(reset-box-colors!)
(infix-slide
  (cblock "((1 + (2 * 3)) - 4) / 5")
  (cblock "precedence(/) > precedence(-)")
  (naive-layered
      (tree-layout
         #:pict (highlight #:color "blue" div-node)
         (tree-layout
           #:pict (highlight #:color "blue" sub-node)
           (tree-layout
             #:pict plus-node
             (tree-layout #:pict one-node #f)
             (tree-layout
               #:pict mult-node
               (tree-layout #:pict two-node #f)
               (tree-layout #:pict thr-node #f)))
           (tree-layout #:pict (highlight four-node) #f))
         (tree-layout #:pict (highlight five-node) #f)))
  (naive-layered
      (tree-layout
         #:pict (highlight #:color "blue" sub-node)
         (tree-layout
           #:pict plus-node
           (tree-layout #:pict one-node #f)
           (tree-layout
             #:pict mult-node
             (tree-layout #:pict two-node #f)
             (tree-layout #:pict thr-node #f)))
         (tree-layout
           #:pict (highlight #:color "blue" div-node)
           (tree-layout #:pict (highlight four-node) #f)
           (tree-layout #:pict (highlight five-node) #f)))))

(slide
  #:title "Infix Reordering"
  (cblock "(1 + (2 * 3)) - (4 / 5)")
  (naive-layered
      (tree-layout
         #:pict sub-node
         (tree-layout
           #:pict plus-node
           (tree-layout #:pict one-node #f)
           (tree-layout
             #:pict mult-node
             (tree-layout #:pict two-node #f)
             (tree-layout #:pict thr-node #f)))
         (tree-layout
           #:pict div-node
           (tree-layout #:pict four-node #f)
           (tree-layout #:pict five-node #f)))))

(slide
  #:title "IL Generation"
  (item "Translate high-level AST into slightly-lower-level AST")
  (codeblock->pict
    (racketblock
      (ExpAssign
        (PatExpId "x@1")
        (ExpInfixApp
          (Id "+")
          (ExpNumLit 1)
          (ExpNumLit 2)))))
  'next
  (text "⇓")
  (codeblock->pict
    (racketblock
      (ILAssign
        "x@1"
        (ILApp
          (ILRef "+")
          (ILNumLit 1)
          (ILNumLit 2))))))

(slide
  #:title "Typechecking"
  (item "Verify that the program is well-typed")
  'next
  (item "Annotate the syntax tree with type information"))

(slide
  #:title "Typechecking"
  (codeblock->pict
    (racketblock
      (ILAssign
        "x@1"
        (ILApp
          (ILRef "+")
          (ILNumLit 1)
          (ILNumLit 2)))))
  (text "⇓")
  (codeblock->pict
    (racketblock
      (ILAssign
        TyUnit
        "x@1"
        (ILApp
          TyInt
          (ILRef (TyArrow (TyInt TyInt TyInt)) "+")
          (ILNumLit TyInt 1)
          (ILNumLit TyInt 2))))))

(slide
  #:title "Evaluation"
  (item "Run the program!")
  'next
  (codeblock->pict
    (racketblock
      (ILApp
        TyInt
        (ILRef (TyArrow (TyInt TyInt TyInt)) "+")
        (ILNumLit TyInt 1)
        (ILNumLit TyInt 2))))
  (text "⇓")
  (cblock "(ValueInt 3)"))






