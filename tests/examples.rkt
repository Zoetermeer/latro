#lang racket

(module+ test
  (require racket/file
           rackunit)

  (define examples
    '("encoding"
      "json"
      "monads"
      "rope"))

  (for ([example examples])
    (test-case (format "the ~a example works" example)
      (define dir (format "../examples/~a" example))
      (define run-cmd (format "~a/run.sh" dir))
      (define exp-file (format "~a/expected.out.txt" dir))
      (define act-output (with-output-to-string (lambda () (system run-cmd))))
      (define exp-output (file->string exp-file))
      (check-equal? act-output exp-output)))
)
