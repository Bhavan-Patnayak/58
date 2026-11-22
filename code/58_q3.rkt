#lang racket/base

(provide print-inorder
         print-all-traversals
         print-height-and-leaves)
; Helper: append two lists without using the built-in append.
(define (my-append lst1 lst2)
  (if (null? lst1)
      lst2
      (cons (car lst1)
            (my-append (cdr lst1) lst2))))

; Inorder traversal: left, root, right.
(define (inorder tree)
  (if (null? tree)
      '()
      (my-append
       (inorder (cadr tree))
       (cons (car tree)
             (inorder (caddr tree))))))

; Preorder traversal: root, left, right.
(define (preorder tree)
  (if (null? tree)
      '()
      (cons (car tree)
            (my-append
             (preorder (cadr tree))
             (preorder (caddr tree))))))

; Postorder traversal: left, right, root.
(define (postorder tree)
  (if (null? tree)
      '()
      (my-append
       (postorder (cadr tree))
       (my-append
        (postorder (caddr tree))
        (list (car tree))))))

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

; Helper: calculate height and leaf count.
; Returns a list containing (height leaf-count).
(define (height-and-leaves tree)
  (if (null? tree)
      '(0 0)
      (let* ((left-result (height-and-leaves (cadr tree)))
             (right-result (height-and-leaves (caddr tree)))
             (left-height (car left-result))
             (right-height (car right-result))
             (left-leaves (cadr left-result))
             (right-leaves (cadr right-result))
             (height (+ 1 (max left-height right-height)))
             (leaves
              (if (and (null? (cadr tree))
                       (null? (caddr tree)))
                  1
                  (+ left-leaves right-leaves))))
        (list height leaves))))

; S1.c: Print height and leaf count.
(define (print-height-and-leaves tree)
  (display (height-and-leaves tree))
  (newline))