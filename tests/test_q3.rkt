; Test 1: Full binary tree (from assignment)
(define t1
  '(4 (2 (1 () ()) (3 () ()))
      (6 (5 () ()) (7 () ()))))
(display 'TEST-1-FULL) (newline)
; Expected: (1 2 3 4 5 6 7) | (4 2 1 3 6 5 7) | (1 3 2 5 7 6 4) | (3 4)
(print-inorder t1)
(print-all-traversals t1)
(print-height-and-leaves t1)

; Test 2: Right-skewed tree (from assignment)
(define t2 '(1 () (2 () (3 () ()))))
(display 'TEST-2-RIGHT-SKEWED) (newline)
; Expected: (1 2 3) | (1 2 3) | (3 2 1) | (3 1)
(print-all-traversals t2)
(print-height-and-leaves t2)

; Test 3: Symbol tree (from assignment)
(define t3 '(a (b () ()) (c () ())))
(display 'TEST-3-SYMBOLS) (newline)
; Expected: (b a c) | (a b c) | (b c a) | (2 2)
(print-all-traversals t3)
(print-height-and-leaves t3)

; Test 4: Empty tree (from assignment)
(display 'TEST-4-EMPTY) (newline)
; Expected: () | () | () | () | (0 0)
(print-inorder '())
(print-all-traversals '())
(print-height-and-leaves '())

; Test 5: Single-node tree
(display 'TEST-5-SINGLE-NODE) (newline)
; Expected: (9) | (9) | (9) | (9) | (1 1)
(print-inorder '(9 () ()))
(print-all-traversals '(9 () ()))
(print-height-and-leaves '(9 () ()))

; Test 6: Left-skewed tree
(define t6 '(1 (2 (3 () ()) ()) ()))
(display 'TEST-6-LEFT-SKEWED) (newline)
; Expected: (3 2 1) | (1 2 3) | (3 2 1) | (3 1)
(print-all-traversals t6)
(print-height-and-leaves t6)

; Test 7: Asymmetric / zig-zag tree
(define t7 '(1 (2 () (3 (4 () ()) ())) (5 () ())))
(display 'TEST-7-ZIGZAG) (newline)
; Expected: (2 4 3 1 5) | (1 2 3 4 5) | (4 3 2 5 1) | (4 2)
(print-all-traversals t7)
(print-height-and-leaves t7)

; Test 8: Negative, zero, and duplicate values
(define t8 '(0 (-1 (-1 () ()) ()) (0 () (2 () ()))))
(display 'TEST-8-NEG-DUP) (newline)
; Expected: (-1 -1 0 0 2) | (0 -1 -1 0 2) | (-1 -1 2 0 0) | (3 2)
(print-all-traversals t8)
(print-height-and-leaves t8)