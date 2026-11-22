;; test-only helpers
(define (show v) (display v) (newline))
(define (make-flat k)
  (let loop ((i 0) (acc '()))
    (if (= i k) acc (loop (+ i 1) (cons i acc)))))
(define (make-empties k)
  (let loop ((i 0) (acc '()))
    (if (= i k) acc (loop (+ i 1) (cons '() acc)))))
(define (nest d)
  (let loop ((i 0) (acc '()))
    (if (= i d) acc (loop (+ i 1) (list acc)))))
(define (count-x t)
  (if (null? t) 0
      (if (pair? (cdr t)) (+ 1 (count-x (cadr t))) 1)))

;; examples from the PDF
(show (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
(show (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
(show (insert-if-short 7 '() 3))
(show (insert-if-short 7 '() 0))

;; edge cases
(show (insert-if-short 'a '(1 (2) ()) 0))
(show (insert-if-short 'z '(a (b c) ()) 3))
(show (insert-if-short 9 '(1 (2 (3))) 10))
(show (insert-if-short 0 '((1 2)) 3))
(show (insert-if-short 0 '(1 2 3) 3))
(show (insert-if-short 5 '(()) 2))
(show (insert-if-short 1 '(((()))) 1))

;; make-inserter with other predicates
(show ((make-inserter 'x (lambda (k) (= k 2))) '((1 2) (3) (4 5 6) (7 8))))
(show ((make-inserter 'e (lambda (k) (= k 0))) '(() (1) ())))

;; helpers
(show (my-length '(a b c)))
(show (my-length '()))
(show (my-map (lambda (v) (* v v)) '(1 2 3)))
(show (my-map car '()))

;; stress: 10,000 elements and depth 100
(show (my-length (insert-if-short 'x (make-flat 10000) 10001)))
(show (my-length (insert-if-short 'x (make-flat 10000) 10000)))
(show (my-length (insert-if-short 'x (make-empties 10000) 1)))
(show (car (insert-if-short 'x (make-empties 10000) 1)))
(show (count-x (insert-if-short 'x (nest 100) 2)))