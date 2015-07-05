(defmodule include-predicates-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "clj/include/predicates.lfe")

(deftest string?
  (is (string? "string data! yaya!"))
  (is-not (string? (list "my" "string" "data"))))

;; XXX add a unit test for (unicode? ...)

(deftest list?
  (is-not (list? "string data! yaya!"))
  (is (list? (list "my" "string" "data"))))

(deftest tuple?
  (is-not (tuple? "string data! yaya!"))
  (is (tuple? (tuple "my" "string" "data"))))

(deftest atom?
  (is-not (atom? "string data! yaya!"))
  (is (atom? 'my-atom))
  (is (atom? '|more atom data|)))

(deftest dict?
  (is-not (dict? "a string"))
  (is-not (dict? '("a" "list")))
  (is-not (dict? #b("a binary")))
  (is-not (dict? #("a" "tuple")))
  (is-not (dict? '(#("a" "tuple"))))
  (is (dict? (dict:from_list '(#("a" "tuple"))))))

(deftest set?
  (is-not (set? '(c a b)))
  (is (set? '(a b c)))
  (is (set? '()))
  (is (set? (sets:new)))
  (is (set? (ordsets:new))))

(deftest proplist?
  (is-not (proplist? 1))
  (is-not (proplist? '(1)))
  (is-not (proplist? '(1 2)))
  (is-not (proplist? '((1 2))))
  (is-not (proplist? '(#(1 2))))
  (is-not (proplist? '(#(a 1) #(2 b) #(c 3))))
  (is (proplist? '(a)))
  (is (proplist? '(a b c)))
  (is (proplist? '(#(a 1) b c)))
  (is (proplist? '(#(a 1) #(b 2) c)))
  (is (proplist? '(#(a 1) #(b 2) #(c 3)))))

(deftest proplist-kv?
  (is (proplist-kv? 'a))
  (is-not (proplist-kv? "a"))
  (is-not (proplist-kv? 1))
  (is (proplist-kv? '#(a b)))
  (is-not (proplist-kv? '(a b))))

(deftest undef?
  (is-not (undef? 42))
  (is-not (undef? 'undef))
  (is (undef? 'undefined)))

(deftest nil?
  (is-not (nil? 32))
  (is-not (nil? 'undefined))
  (is (nil? 'nil))
  (is (nil? '())))

(deftest true?
  (is-not (true? 'false))
  (is (true? 'true)))

(deftest false?
  (is-not (false? 'true))
  (is (false? 'false)))

(deftest in?
  (is-not (in? 0 '(1 2 3 4 5 6)))
  (is (in? 6 '(1 2 3 4 5 6)))
  (is-not (in? "z" '("a" "b" "c" "d" "e")))
  (is (in? "e" '("a" "b" "c" "d" "e")))
  (is-not (in? 'z '(a b c d e)))
  (is (in? 'e '(a b c d e))))

(deftest not-in?
  (is (not-in? 0 '(1 2 3 4 5 6)))
  (is-not (not-in? 6 '(1 2 3 4 5 6)))
  (is (not-in? "z" '("a" "b" "c" "d" "e")))
  (is-not (not-in? "e" '("a" "b" "c" "d" "e")))
  (is (not-in? 'z '(a b c d e)))
  (is-not (not-in? 'e '(a b c d e))))

(defun test-in-with-guard
  ((arg) (when (in? arg '(a b c)))
   'found)
  ((_) 'not-found))

(deftest in?-guard
  (is-equal (test-in-with-guard 'a) 'found)
  (is-equal (test-in-with-guard 'b) 'found)
  (is-equal (test-in-with-guard 'c) 'found)
  (is-equal (test-in-with-guard 'd) 'not-found))

(defun test-not-in-with-guard
  ((arg) (when (not-in? arg '(i j k)))
   'not-found)
  ((_) 'found))

(deftest not-in?-guard
  (is-equal (test-not-in-with-guard 'i) 'found)
  (is-equal (test-not-in-with-guard 'j) 'found)
  (is-equal (test-not-in-with-guard 'k) 'found)
  (is-equal (test-not-in-with-guard 'a) 'not-found))

(deftest identical?
  (is (identical? '(a b c) '(a b c)))
  (is-not (identical? '(a b c) '(a b d))))

(deftest empty?
  (is (empty? '()))
  (is-not (empty? '(1 2 3))))

(deftest every?
  (is (every? #'zero?/1 '(0 0 0 0 0)))
  (is-not (every? #'zero?/1 '(0 0 0 0 1))))

(deftest any?
  (is (any? #'zero?/1 '(0 1 1 1 1)))
  (is-not (any? #'zero?/1 '(1 1 1 1 1))))

(deftest not-any?
  (is-not (not-any? #'zero?/1 '(0 1 1 1 1)))
  (is (not-any? #'zero?/1 '(1 1 1 1 1))))

(deftest element?
  (is (element? 'a '(a b c)))
  (is-not (element? 'z '(a b c)))
  (is (element? 'a (sets:from_list '(a b c))))
  (is-not (element? 'z (sets:from_list '(a b c))))
  (is (element? 'a (ordsets:from_list '(a b c))))
  (is-not (element? 'z (ordsets:from_list '(a b c)))))

