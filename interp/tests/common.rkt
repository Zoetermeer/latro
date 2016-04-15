#lang racket
(provide interp
         parse-tree
         alpha-convert
         typecheck)

(define (needs-recompile? file depends-on-file)
  (> (file-or-directory-modify-seconds depends-on-file)
     (file-or-directory-modify-seconds file)))


(define lexer-file "./Lex.x")
(define lexer-module "./Lex.hs")
(define parser-file "./Parse.y")
(define parser-module "./Parse.hs")
(define main-module "./Main.hs")


(define (compile!)
  (parameterize ([current-directory "../"])
    (when (needs-recompile? lexer-module lexer-file)
      (system (format "alex ~a" lexer-file)))

    (when (needs-recompile? parser-module parser-file)
      (system (format "happy ~a" parser-file)))

    (system (format "ghc -o interp ~a" main-module))))

(compile!)

(define (call-interpreter opts program)
  (parameterize ([current-directory "../"])
    (call-with-output-file
      "./test.spar"
      (λ (out)
        (fprintf out "~a" program))
      #:mode 'text
      #:exists 'truncate/replace)
    (with-output-to-string
      (λ ()
        (system (format "./interp ~a ./test.spar" (string-join opts)))))))

(define (interp . s)
  (call-interpreter '() (apply string-append s)))

; (define (strip-quotation-marks s)
;   (case s
;     [("") s]
;     [else
;       (define cs (string->list s))
;       (list->string (drop (take cs (string-length s)) 1))]))
;
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

(define (typecheck . s)
  (call-and-read '("-t") (apply string-append s)))
