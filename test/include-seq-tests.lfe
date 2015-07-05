(defmodule include-seq-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "clj/include/seq.lfe")

(deftest seq
  (is-equal '(1 2 3 4) (seq 4))
  (is-equal '(2 3 4) (seq 2 4))
  (is-equal '(2 4 6 8 10) (seq 2 10 2)))

(deftest drop
  (is-equal '(6 7 8 9 10 11 12) (drop 5 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal '() (drop 'all '(1 2 3 4 5 6 7 8 9 10 11 12))))

(deftest take
  (is-equal '(1 2 3 4) (take 4 (range)))
  (is-equal '(1 2 3 4 5) (take 5 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-error function_clause (take -1 (range)))
  (is-equal '(1 2 3 4 5 6 7 8 9 10 11 12) (take 'all '(1 2 3 4 5 6 7 8 9 10 11 12))))

(deftest next-and-take
  (is-equal
    '(1 6 21 66 201 606 1821 5466 16401 49206)
    (take 10 (next (lambda (x y) (* 3 (+ x y))) 1 1)))
  (is-equal
    '(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536)
    (take 17 (next (lambda (x _) (* 2 x)) 1 1)))
  (is-equal
    '(1 4.0 25.0 676.0 458329.0 210066388900.0 4.4127887745906175e22)
    (take 7 (next (lambda (x _) (math:pow (+ x 1) 2)) 1 1))))

(deftest range
  (is-equal 1 (car (funcall (range))))
  (is-equal 2 (car (funcall (cdr (funcall (range))))))
  (is-equal 3 (car (funcall (cdr (funcall (cdr (funcall (range))))))))
  (is-equal 4 (car (funcall (cdr (funcall (cdr (funcall (cdr (funcall (range)))))))))))

(deftest split-at
  (is-equal
    '((1 2 3) (4 5 6 7 8 9 10 11 12))
    (split-at 3 '(1 2 3 4 5 6 7 8 9 10 11 12))))

(deftest split-by
  (is-equal
    '()
    (split-by 0 '()))
  (is-equal
    '()
    (split-by 1 '()))
  (is-equal
    '()
    (split-by 100 '()))
  (is-equal
    '(1 2 3 4 5 6 7 8 9 10 11 12)
    (split-by 0 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal
    '((1) (2) (3) (4) (5) (6) (7) (8) (9) (10) (11) (12))
    (split-by 1 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal
    '((1 2) (3 4) (5 6) (7 8) (9 10) (11 12))
    (split-by 2 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal
    '((1 2 3 4 5) (6 7 8 9 10) (11 12))
    (split-by 5 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal
    '((1 2 3 4 5 6 7) (8 9 10 11 12))
    (split-by 7 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal
    '((1 2 3 4 5 6 7 8 9 10 11) (12))
    (split-by 11 '(1 2 3 4 5 6 7 8 9 10 11 12)))
  (is-equal
    '((1 2 3 4 5 6 7 8 9 10 11 12))
    (split-by 12 '(1 2 3 4 5 6 7 8 9 10 11 12))))

(deftest interleave
  (is-equal '(a 1 b 2 c 3) (interleave '(a b c) '(1 2 3))))

(defun get-in-data-1 ()
  '((1)
    (1 2 3)
    (1 2 (3 4 (5 6 (7 8 9))))))

(deftest get-in-nth
  (is-equal 1 (get-in 1 1 (get-in-data-1)))
  (is-equal 3 (get-in 2 3 (get-in-data-1)))
  (is-equal 9 (get-in 3 3 3 3 3 (get-in-data-1)))
  (is-equal 'undefined (get-in 4 (get-in-data-1)))
  (is-equal 'undefined (get-in 4 3 3 3 (get-in-data-1))))

(defun get-in-data-2 ()
  '(#(key-1 val-1)
    #(key-2 val-2)
    #(key-3 (#(key-4 val-4)
             #(key-5 val-5)
             #(key-6 (#(key-7 val-7)
                      #(key-8 val-8)
                      #(key-9 val-9)))))))

(deftest get-in-keys
  (is-equal 'val-1 (get-in 'key-1 (get-in-data-2)))
  (is-equal 'val-5 (get-in 'key-3 'key-5 (get-in-data-2)))
  (is-equal 'val-9 (get-in 'key-3 'key-6 'key-9 (get-in-data-2)))
  (is-equal 'undefined (get-in 'key-18 (get-in-data-2)))
  (is-equal 'undefined (get-in 'key-3 'key-6 'key-89 (get-in-data-2)))
  (is-equal 'undefined (get-in 'key-3 'key-6 'key-89 'key-100(get-in-data-2))))

(deftest reduce
  (is-equal 6 (reduce (lambda (x acc) (+ x acc)) '(1 2 3)))
  (is-equal 6 (reduce #'+/2 '(1 2 3)))
  (is-equal 6 (reduce (fun + 2) '(1 2 3)))
  (is-equal 6 (reduce (lambda (x acc) (+ x acc)) 0 '(1 2 3)))
  (is-equal 6 (reduce #'+/2 0 '(1 2 3)))
  (is-equal 6 (reduce (fun + 2) 0 '(1 2 3))))

(deftest repeat
  (is-equal '(1 1 1) (repeat 3 1))
  (is-equal '("xo" "xo") (repeat 2 "xo"))
  (is-equal '() (repeat 0 "oh noes"))
  (is-equal '(ok ok ok ok) (repeat 4 'ok))
  (is-error function_clause (repeat -1 0))
  (is-equal '(1 1 1) (repeat 3 (lambda () 1)))
  (is-error function_clause (repeat -1 (lambda () 1)))
  (is-equal 2 (length (repeat 2 #'random:uniform/0))))
