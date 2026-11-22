#lang racket/base

; Calculate the length of a list using tail recursion.
(define (my-length lst)
  (let loop ((remaining lst) (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining) (+ count 1)))))

; Reverse a list using tail recursion.
(define (my-reverse lst)
  (let loop ((remaining lst) (result '()))
    (if (null? remaining)
        result
        (loop (cdr remaining)
              (cons (car remaining) result)))))

; Apply a function to every element of a list.
(define (my-map f lst)
  (let loop ((remaining lst) (result '()))
    (if (null? remaining)
        (my-reverse result)
        (loop (cdr remaining)
              (cons (f (car remaining)) result)))))

; Higher-order function that creates a nested-list inserter.
(define (make-inserter x len-ok?)
  (letrec
      ((insert-list
        (lambda (lst)
          (let* ((original-length (my-length lst))
                 (processed
                  (my-map
                   (lambda (item)
                     (if (or (null? item) (pair? item))
                         (insert-list item)
                         item))
                   lst)))
            (if (len-ok? original-length)
                (cons x processed)
                processed)))))
    insert-list))

; Insert x at the front of every list whose original length is less than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

; Read x, lst and n from standard input and print the result.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read))
         (result (insert-if-short x lst n)))
    (display result)
    (newline)))