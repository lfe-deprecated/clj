;; Usage: `(condp pred expr . clauses)`
;;
;; Given a binary predicate, an expression and a set of clauses of the form:
;;
;;     test-expr result-expr
;;
;;     test-expr >> result-fn
;;
;; where `result-fn` is a unary function, if `(pred test-expr expr)` returns
;; anything other than `undefined` or `false`, the clause is a match. If a binary
;; clause matches, return `result-expr`. If a ternary clause matches, call
;; `result-fn` with the result of the predicate and return the result.
;;
;; If no clause matches and a single default expression is given after the clauses,
;; return it. If no default expression is given and no clause matches, return a
;; tuple of the form:
;;
;;     #(error "No matching clause: {{expr}}")
(defmacro condp
  (`(,pred ,expr . ,clauses)
   (fletrec ((emit
              ([pred expr `(,a >> ,c . ,more)]
               (let ((f (if (is_atom pred) `(fun ,pred 2) pred)))
                 `(case (funcall ,f ,a ,expr)
                    ('undefined ,(emit pred expr more))
                    ('false     ,(emit pred expr more))
                    (p          (let ((g ,(if (is_atom c) `(fun ,c 1) c)))
                                  (funcall g p))))))
              ([pred expr `(,a ,b . ,more)]
               (let ((f (if (is_atom pred) `(fun ,pred 2) pred)))
                 `(case (funcall ,f ,a ,expr)
                    ('undefined ,b)
                    ('false     ,b)
                    (_          ,(emit pred expr more)))))
              ([pred expr `(,a)] a)
              ([pred expr '()]
               `#(error ,(lists:flatten
                          (io_lib:format "No matching clause: ~s"
                                         `(,(lfe_io_pretty:term expr))))))))
     (emit `,pred expr clauses))))

;; If `test` evaluates to `false`, evaluate and return `then`, otherwise `else`,
;; if supplied, else `undefined`.
(defmacro if-not
  (`(,test ,then . ()) `(if-not ,test ,then 'undefined))
  (`(,test ,then . (,else))
   `(if (not ,test) ,then ,else)))

;; If `test` evaluates to `false`, evaluate `body` in an implicit `progn`,
;; otherwise if `test` evaluates to `true`, return `undefined`.
(defmacro when-not
  (`(,test . ,body)
   `(if ,test 'undefined (progn ,@body))))

;; Same as `(not (== ...))`
(defmacro not=
  (`(,x . ())       'false)
  (`(,x ,y . ,more) `(not (== ,x ,y ,@more))))
