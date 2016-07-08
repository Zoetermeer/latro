#lang racket
(require racket/runtime-path)
(provide compile!
         interp
         parse-tree
         alpha-convert
         infix-reordered
         il-gen
         typecheck
         show-typed-ast)

(define (needs-recompile? file depends-on-file)
  (> (file-or-directory-modify-seconds depends-on-file)
     (file-or-directory-modify-seconds file)))


(define lexer-file "./Lex.x")
(define lexer-module "./Lex.hs")
(define parser-file "./Parse.y")
(define parser-module "./Parse.hs")
(define main-module "./Main.hs")
(define test-source-file "./last-test.l")


(define (compile!)
  (system "cabal build")
  (system "cabal install"))

(compile!)

(define (call-interpreter opts program)
  (parameterize ([current-directory "."])
    (call-with-output-file
      test-source-file
      (λ (out)
        (fprintf out "~a" program))
      #:mode 'text
      #:exists 'truncate/replace)
    (with-output-to-string
      (λ ()
        (system (format "latro ~a ~a" (string-join opts) test-source-file))))))

(define (strip-quotation-marks s) s)

(define (call-and-read opts . s)
  (read
    (open-input-string
      (strip-quotation-marks
        (call-interpreter opts (apply string-append s))))))


(define (parse-tree . s)
  (call-and-read '("-p") (apply string-append s)))

(define (alpha-convert . s)
  (call-and-read '("-a") (apply string-append s)))

(define (infix-reordered . s)
  (call-and-read '("-r") (apply string-append s)))

(define (il-gen . s)
  (call-and-read '("-il") (apply string-append s)))

(define (typecheck . s)
  (call-and-read '("-tc") (apply string-append s)))

(define (show-typed-ast . s)
  (call-and-read '("-t") (apply string-append s)))

(define (interp . s)
  (call-and-read '() (apply string-append s)))
