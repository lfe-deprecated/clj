;;;; XXX Update the kla project with a macro that can:
;;;; * introspect an LFE module
;;;; * get a list of exported functions and their arities
;;;; * define functions that wrap the exported functions
;;;;
;;;; With that macro in hand, call it in this include against the clj-seq module,
;;;; thus allowing users/developers to include those functions in their own modules
;;;; by means of (include-lib "clj/include/seq.lfe"), giving them a user experience
;;;; similar to if those functions were defined as part of the language.
;;;;

(defmacro get-in args
  (let ((data (car args))
        (keys (cdr args)))
    `(apply #'clj-seq:get-in/2 (list ,data (list ,@keys)))))

(defun loaded-seq ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).

  This function needs to be the last one in this include."
  'ok)
