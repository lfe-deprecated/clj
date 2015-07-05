(defmodule clj-comp-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "clj/include/seq.lfe")
(include-lib "clj/include/compose.lfe")

(deftest ->
  (is-equal '(#(a 1) #(b 2) #(c 3) #(d 4) #(e 5) #(f 6))
            (-> '(#(a 1) #(b 2) #(c 3))
                 (++ '(#(d 4)))
                 (++ '(#(e 5)))
                 (++ '(#(f 6)))))
  (is-equal '("L" "F" "E")
            (-> "a b c d e"
                (string:to_upper)
                (string:tokens " ")
                (lists:merge '("X" "F" "L"))
                (lists:sort)
                (lists:reverse)
                (lists:sublist 2 3))))

(deftest ->>
  (is-equal '(#(f 6) #(e 5) #(d 4) #(a 1) #(b 2) #(c 3))
            (->> '(#(a 1) #(b 2) #(c 3))
                 (++ '(#(d 4)))
                 (++ '(#(e 5)))
                 (++ '(#(f 6)))))
  (is-equal 1540.0
           (->> (clj-seq:seq 42)
                (lists:map (lambda (x) (math:pow x 2)))
                (lists:filter (clj-comp:compose #'clj-p:even?/1 #'round/1))
                (clj-seq:take 10)
                (lists:foldl #'+/2 0))))

(deftest compose
  (is-equal 0.49999999999999994
            (funcall (clj-comp:compose #'math:sin/1 #'math:asin/1) 0.5))
  (is-equal 1.5
            (funcall (clj-comp:compose `(,#'math:sin/1
                                   ,#'math:asin/1
                                   ,(lambda (x) (+ x 1)))) 0.5))
  (is-equal '(1 2 3 4)
            (lists:filter (clj-comp:compose #'not/1 #'clj-p:zero?/1)
                          '(0 1 0 2 0 3 0 4)))
  (is-equal 0.49999999999999994
            (clj-comp:compose #'math:sin/1 #'math:asin/1 0.5)))

(deftest partial
  (is-equal 3 (funcall (clj-comp:partial #'+/2 1) 2))
  (is-equal 6 (funcall (clj-comp:partial #'+/3 1) '(2 3))))
