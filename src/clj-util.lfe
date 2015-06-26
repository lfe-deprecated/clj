(defmodule clj-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'clj))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(clj ,(get-version)))))