;; Threads the sexp through the sexps. Inserts x as the second item in
;; the first sexp, making a list of it if it is not a list already. If
;; there are more sexps, inserts the first sexp as the second item in
;; second sexp, etc.
;;
;; Copied from Tim Dysinger's lfesl repo here:
;;   https://github.com/lfex/lfesl/blob/master/include/thread.lfe
;;
;; Example usage, demonstrating ordering:
;;
;; > (set o '(#(a 1) #(b 2) #(c 3)))
;; (#(a 1) #(b 2) #(c 3))
;; > (-> o
;;       (++ `(#(d 4)))
;;       (++ `(#(e 5)))
;;       (++ `(#(f 6))))
;; (#(a 1) #(b 2) #(c 3) #(d 4) #(e 5) #(f 6))
;;
;; Note that usage of this macro with this examples results in each successive
;; value being APPENDED to the input list.
;;
;; Another example showing how this:
;;
;; > (lists:sublist
;;     (lists:reverse
;;       (lists:sort
;;         (lists:merge
;;           (string:tokens
;;             (string:to_upper "a b c d e")
;;             " ")
;;           '("X" "F" "L"))))
;;     2 3)
;; ("L" "F" "E")
;;
;; Can be rewritten as this:
;;
;; > (-> "a b c d e"
;;       (string:to_upper)
;;       (string:tokens " ")
;;       (lists:merge '("X" "F" "L"))
;;       (lists:sort)
;;       (lists:reverse)
;;       (lists:sublist 2 3))
;; ("L" "F" "E")
;;
(defmacro ->
  ((x) x)
  ((x sexp) (when (is_list sexp))
   `(,(car sexp) ,x ,@(cdr sexp)))
  ((x sexp)
   `(list ,sexp ,x))
  ((x sexp . sexps)
   `(-> (-> ,x ,sexp) ,@sexps)))

;; Threads the sexp through the sexps. Inserts x as the last item in
;; the first sexp, making a list of it if it is not a list already. If
;; there are more sexps, inserts the first sexp as the last item in
;; second sexp, etc.
;;
;; Copied from Tim Dysinger's lfesl repo here:
;;   https://github.com/lfex/lfesl/blob/master/include/thread.lfe
;;
;; Example usage, demonstrating ordering:
;;
;; > (set o '(#(a 1) #(b 2) #(c 3)))
;; (#(a 1) #(b 2) #(c 3))
;; > (-> o
;;       (++ `(#(d 4)))
;;       (++ `(#(e 5)))
;;       (++ `(#(f 6))))
;; (#(f 6) #(e 5) #(d 4) #(a 1) #(b 2) #(c 3))
;;
;; Note that usage of this macro with this examples results in each successive
;; value being PREPENDED to the input list.
;;
;; Another example showing how this:
;;
;; > (lists:foldl #'+/2 0
;;     (take 10
;;       (lists:filter
;;         (compose #'even?/1 #'round/1)
;;         (lists:map
;;           (lambda (x)
;;             (math:pow x 2))
;;           (seq 42)))))
;; 1540.0
;;
;; Can be rewritten as this:
;;
;; > (->> (seq 42)
;;        (lists:map (lambda (x) (math:pow x 2)))
;;        (lists:filter (compose #'even?/1 #'round/1))
;;        (take 10)
;;        (lists:foldl #'+/2 0))
;; 1540.0
;;
(defmacro ->>
  ((x) x)
  ((x sexp) (when (is_list sexp))
   `(,(car sexp) ,@(cdr sexp) ,x))
  ((x sexp)
   `(list ,sexp ,x))
  ((x sexp . sexps)
   `(->> (->> ,x ,sexp) ,@sexps)))

;; The following 'compose' functions aren't macros but are conceptual
;; companions to the thrushing macros above.
;;
;; Example usage:
;;
;; > (include-file "include/compose-macros.lfe")
;; compose
;; > (funcall (compose #'math:sin/1 #'math:asin/1)
;;            0.5)
;; 0.49999999999999994
;; > (funcall (compose `(,#'math:sin/1
;;                       ,#'math:asin/1
;;                       ,(lambda (x) (+ x 1))))
;;            0.5)
;; 1.5
;;
;; Or used in another function call:
;;
;; > (lists:filter (compose #'not/1 #'zero?/1)
;;                 '(0 1 0 2 0 3 0 4))
;; (1 2 3 4)
;;
;; The usage above is best when 'compose' will be called from in
;; functions like '(lists:foldl ...)' or '(lists:filter ...)', etc.
;; However, one may also call compose in the following manner, best
;; suited for direct usage:
;;
;; > (compose #'math:sin/1 #'math:asin/1 0.5)
;; 0.49999999999999994
;; > (compose `(,#'math:sin/1
;;              ,#'math:asin/1
;;              ,(lambda (x) (+ x 1))) 0.5)
;; 1.5
;;
(defun compose
  ((func-1 func-2) (when (is_function func-2))
    (lambda (x)
      (funcall func-1
        (funcall func-2 x))))
  ((funcs x)
    (funcall (compose funcs) x)))

(defun compose (f g x)
  (funcall (compose f g) x))

(defun compose (funcs)
  (lists:foldl #'compose/2 (lambda (x) x) funcs))

;; Partial
;;
;; Usage:
;;
;; > (set f (partial #'+/2 1))
;; #Fun<lfe_eval.28.86468545>
;; > (funcall f 2)
;; 3
;; > (set f (partial #'+/3 1))
;; #Fun<lfe_eval.28.86468545>
;; > (funcall f '(2 3))
;; 6
;; > (set f (partial #'+/3 '(2 3)))
;; #Fun<lfe_eval.28.86468545>
;; > (funcall f 4)
;; 9
;; > (set f (partial #'+/4 '(2 3)))
;; #Fun<lfe_eval.28.86468545>
;; > (funcall f '(4 5))
;; 14
;;
(defun partial
  "The partial function is arity 2 where the first parameter must be a
  function and the second parameter may either be a single item or a list of
  items.

  When funcall is called against the result of the partial call, a second
  parameter is applied to the partial function. This parameter too may be
  either a single item or a list of items."
  ((func args-1) (when (is_list args-1))
    (match-lambda
      ((args-2) (when (is_list args-2))
        (apply func (++ args-1 args-2)))
      ((arg-2)
        (apply func (++ args-1 `(,arg-2))))))
  ((func arg-1)
    (match-lambda
      ((args-2) (when (is_list args-2))
        (apply func (++ `(,arg-1) args-2)))
      ((arg-2)
        (funcall func arg-1 arg-2)))))

(defun loaded-compose ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).

  This function needs to be the last one in this include."
  'ok)
