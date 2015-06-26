(defmacro in? (item collection)
  `(orelse ,@(lists:map
               (lambda (x)
                 `(=:= (quote ,x) ,item))
               `(,@(cadr collection)))))

(defmacro not-in? (item collection)
  `(not (in? ,item ,collection)))

;; XXX Once the TODO/XXX item at the top of include/seq.lfe is completed,
;; do the same thing here with clj-p.lfe -- use kla to pull in the
;; functions from the compose module to be available for users where --
;; after including them -- the experience will be as if the functions were
;; part of the language.

(defun loaded-predicates ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).

  This function needs to be the last one in this include."
  'ok)
