#lang racket/base

(require "../code/58_q3.rkt")

; Test tree 1: Full binary tree
(define t1
  '(4
     (2 (1 () ()) (3 () ()))
     (6 (5 () ()) (7 () ()))))

; Test tree 2: Right-skewed tree
(define t2
  '(1 () (2 () (3 () ()))))

; Test tree 3: Symbol tree
(define t3
  '(a (b () ()) (c () ())))

; Test 1: Full binary tree
(display "TEST 1: Full binary tree")
(newline)
(print-inorder t1)
(print-all-traversals t1)
(print-height-and-leaves t1)

; Test 2: Right-skewed tree
(display "TEST 2: Right-skewed tree")
(newline)
(print-all-traversals t2)
(print-height-and-leaves t2)

; Test 3: Symbol tree
(display "TEST 3: Symbol tree")
(newline)
(print-all-traversals t3)
(print-height-and-leaves t3)

; Test 4: Empty tree
(display "TEST 4: Empty tree")
(newline)
(print-inorder '())
(print-all-traversals '())
(print-height-and-leaves '())

; Test 5: Single-node tree
(display "TEST 5: Single-node tree")
(newline)
(print-inorder '(9 () ()))
(print-all-traversals '(9 () ()))
(print-height-and-leaves '(9 () ()))