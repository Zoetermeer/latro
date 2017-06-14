#lang racket
(require racket/runtime-path)
(provide compile!
         interp
         interp-e
         interp-e-sexp
         interp-lines
         interp-lines-with-wrapper-module
         interp-sexp
         interp-sexp-with-wrapper-module
         line
         parse-tree
         alpha-convert
         infix-reordered
         il-gen
         typecheck
         show-typed-ast
         use-core?)

(define (needs-recompile? file depends-on-file)
  (> (file-or-directory-modify-seconds depends-on-file)
     (file-or-directory-modify-seconds file)))


(define lexer-file "./Lex.x")
(define lexer-module "./Lex.hs")
(define parser-file "./Grammar.y")
(define parser-module "./Grammar.hs")
(define main-module "./Main.hs")
(define test-source-file "./last-test.l")


(define (compile!)
  (system "stack build"))

(define use-core? (make-parameter #t))

(define (call-interpreter opts program #:include-core? [include-core? #t])
  (parameterize ([current-directory "."])
    (call-with-output-file
      test-source-file
      (λ (out)
        (fprintf out "~a" program))
      #:mode 'text
      #:exists 'truncate/replace)
    (with-output-to-string
      (λ ()
        (define cmd (format "stack exec -- latroi ~a" (if (use-core?) "../lib/Core.l" "")))
        (system (format "~a ~a ~a" cmd (string-join opts) test-source-file))))))

(define (strip-quotation-marks s) s)

(define (call-and-read opts . s)
  (read
    (open-input-string
      (strip-quotation-marks
        (call-interpreter opts (apply string-append s))))))

(define (line s)
  (format "~a\n" s))

(define (call opts . s)
  (strip-quotation-marks
    (call-interpreter opts (apply string-append s))))

(define (parse-tree . s)
  (call-and-read '("-a parse") (apply string-append s)))

(define (alpha-convert . s)
  (call-and-read '("-a alpha") (apply string-append s)))

(define (infix-reordered . s)
  (call-and-read '("-a infix") (apply string-append s)))

(define (il-gen . s)
  (call-and-read '("-a ilgen") (apply string-append s)))

(define (typecheck . s)
  (call-and-read '("-a type") (apply string-append s)))

(define (show-typed-ast . s)
  (call-and-read '("-a typed") (apply string-append s)))

(define (interp . s)
  (call '() (apply string-append s)))

(define (interp-e . s)
  (call '("-e") (apply string-append s)))

(define (interp-lines . s)
  (string-split (call '() (apply string-append s)) "\n"))

(define (interp-lines-with-wrapper-module . s)
  (define wrapped (format "module Test { import Core import IO  ~a }" (apply string-append s)))
  (string-split (call '() wrapped) "\n"))

(define (interp-sexp . s)
  (call-and-read '("-s") (apply string-append s)))

(define (interp-sexp-with-wrapper-module . s)
  (define wrapped (format "module Test { import Core import IO  ~a }" (apply string-append s)))
  (call-and-read '("-s") wrapped))

(define (interp-e-sexp . s)
  (call-and-read '("-e") (apply string-append s)))

