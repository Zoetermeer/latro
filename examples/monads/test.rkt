#lang racket

(module+ test
  (require racket/file
           rackunit)

  (test-case "the monads example works"
    (define act-output (with-output-to-string (lambda () (system "./run.sh"))))
    (define exp-output (file->string "./expected.out.txt"))
    (check-equal? act-output exp-output)))
