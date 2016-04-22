(defmodule clj-util
  (export all))

(defun get-version ()
  (kla-util:get-app-version 'clj))

(defun get-versions ()
  (++ (kla-util:get-versions)
      `(#(clj ,(get-version)))))
