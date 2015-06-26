(defmodule clj-p-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "clj/include/predicates.lfe")

(deftest string?
  (is (clj-p:string? "string data! yaya!"))
  (is-not (clj-p:string? (list "my" "string" "data"))))

;; XXX add a unit test for (unicode? ...)

(deftest list?
  (is-not (clj-p:list? "string data! yaya!"))
  (is (clj-p:list? (list "my" "string" "data"))))

(deftest tuple?
  (is-not (clj-p:tuple? "string data! yaya!"))
  (is (clj-p:tuple? (tuple "my" "string" "data"))))

(deftest atom?
  (is-not (clj-p:atom? "string data! yaya!"))
  (is (clj-p:atom? 'my-atom))
  (is (clj-p:atom? '|more atom data|)))

(deftest dict?
  (is-not (clj-p:dict? "a string"))
  (is-not (clj-p:dict? '("a" "list")))
  (is-not (clj-p:dict? #b("a binary")))
  (is-not (clj-p:dict? #("a" "tuple")))
  (is-not (clj-p:dict? '(#("a" "tuple"))))
  (is (clj-p:dict? (dict:from_list '(#("a" "tuple"))))))

(deftest set?
  (is-not (clj-p:set? '(c a b)))
  (is (clj-p:set? '(a b c)))
  (is (clj-p:set? '()))
  (is (clj-p:set? (sets:new)))
  (is (clj-p:set? (ordsets:new))))

(deftest proplist?
  (is-not (clj-p:proplist? 1))
  (is-not (clj-p:proplist? '(1)))
  (is-not (clj-p:proplist? '(1 2)))
  (is-not (clj-p:proplist? '((1 2))))
  (is-not (clj-p:proplist? '(#(1 2))))
  (is-not (clj-p:proplist? '(#(a 1) #(2 b) #(c 3))))
  (is (clj-p:proplist? '(a)))
  (is (clj-p:proplist? '(a b c)))
  (is (clj-p:proplist? '(#(a 1) b c)))
  (is (clj-p:proplist? '(#(a 1) #(b 2) c)))
  (is (clj-p:proplist? '(#(a 1) #(b 2) #(c 3)))))

(deftest proplist-kv?
  (is (clj-p:proplist-kv? 'a))
  (is-not (clj-p:proplist-kv? "a"))
  (is-not (clj-p:proplist-kv? 1))
  (is (clj-p:proplist-kv? '#(a b)))
  (is-not (clj-p:proplist-kv? '(a b))))

(deftest undef?
  (is-not (clj-p:undef? 42))
  (is-not (clj-p:undef? 'undef))
  (is (clj-p:undef? 'undefined)))

(deftest nil?
  (is-not (clj-p:nil? 32))
  (is-not (clj-p:nil? 'undefined))
  (is (clj-p:nil? 'nil))
  (is (clj-p:nil? '())))

(deftest true?
  (is-not (clj-p:true? 'false))
  (is (clj-p:true? 'true)))

(deftest false?
  (is-not (clj-p:false? 'true))
  (is (clj-p:false? 'false)))

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
  (is (clj-p:identical? '(a b c) '(a b c)))
  (is-not (clj-p:identical? '(a b c) '(a b d))))

(deftest empty?
  (is (clj-p:empty? '()))
  (is-not (clj-p:empty? '(1 2 3))))

(deftest every?
  (is (clj-p:every? #'clj-p:zero?/1 '(0 0 0 0 0)))
  (is-not (clj-p:every? #'clj-p:zero?/1 '(0 0 0 0 1))))

(deftest any?
  (is (clj-p:any? #'clj-p:zero?/1 '(0 1 1 1 1)))
  (is-not (clj-p:any? #'clj-p:zero?/1 '(1 1 1 1 1))))

(deftest not-any?
  (is-not (clj-p:not-any? #'clj-p:zero?/1 '(0 1 1 1 1)))
  (is (clj-p:not-any? #'clj-p:zero?/1 '(1 1 1 1 1))))

(deftest element?
  (is (clj-p:element? 'a '(a b c)))
  (is-not (clj-p:element? 'z '(a b c)))
  (is (clj-p:element? 'a (sets:from_list '(a b c))))
  (is-not (clj-p:element? 'z (sets:from_list '(a b c))))
  (is (clj-p:element? 'a (ordsets:from_list '(a b c))))
  (is-not (clj-p:element? 'z (ordsets:from_list '(a b c)))))

