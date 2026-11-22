#lang racket/base

; Accumulator-based inorder traversal (left, root, right) -> O(N), no append.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) acc)))))

(define (inorder tree)
  (inorder-acc tree '()))

; Accumulator-based preorder traversal (root, left, right) -> O(N), no append.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc (cadr tree)
                          (preorder-acc (caddr tree) acc)))))

(define (preorder tree)
  (preorder-acc tree '()))

; Accumulator-based postorder traversal (left, right, root) -> O(N), no append.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree)
                                    (cons (car tree) acc)))))

(define (postorder tree)
  (postorder-acc tree '()))

; S1.a: Print inorder traversal.
(define (print-inorder tree)
  (display (inorder tree))
  (newline))

; S1.b: Print all three traversals.
(define (print-all-traversals tree)
  (display (inorder tree))
  (newline)
  (display (preorder tree))
  (newline)
  (display (postorder tree))
  (newline))

; Helper: calculate height and leaf count in a single pass.
; Returns (height leaf-count).
(define (height-and-leaves tree)
  (if (null? tree)
      '(0 0)
      (let* ((left-res (height-and-leaves (cadr tree)))
             (right-res (height-and-leaves (caddr tree)))
             (lh (car left-res))
             (rh (car right-res))
             (ll (cadr left-res))
             (rl (cadr right-res))
             (h (+ 1 (max lh rh)))
             (leaves (if (and (null? (cadr tree))
                              (null? (caddr tree)))
                         1
                         (+ ll rl))))
        (list h leaves))))

; S1.c: Print height and leaf count.
(define (print-height-and-leaves tree)
  (display (height-and-leaves tree))
  (newline))