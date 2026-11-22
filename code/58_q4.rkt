#lang racket/base

;; ---------- S2.b: own helpers (no length / reverse / map allowed) ----------
(define (my-length lst)
  (let loop ((l lst) (n 0))
    (if (null? l)
        n
        (loop (cdr l) (+ n 1)))))

(define (my-reverse lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        acc
        (loop (cdr l) (cons (car l) acc)))))

;; tail-recursive map, safe for 10,000-element lists
(define (my-map f lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        (my-reverse acc)
        (loop (cdr l) (cons (f (car l)) acc)))))

;; () counts as a list too, since pair? is #f for '()
(define (my-list? e)
  (or (null? e) (pair? e)))

;; ---------- S2.c: higher-order inserter ----------
;; Returns a function that puts x at the front of every list (at every level)
;; whose ORIGINAL length satisfies len-ok?
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (e) (if (my-list? e) (insert e) e))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert))

;; Single definition of insert-if-short, built on make-inserter
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; ---------- S2.a ----------
(define (print-insert-result)
  (let* ((x   (read))
         (lst (read))
         (n   (read)))
    (display (insert-if-short x lst n))
    (newline)))