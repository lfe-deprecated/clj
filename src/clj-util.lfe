(defmodule clj-util
  (export all))

(defun get-version ()
  (lr3-ver-util:get-app-version 'clj))

(defun get-versions ()
  (++ (lr3-ver-util:get-versions)
      `(#(kla ,(lr3-ver-util:get-app-version 'kla))
        #(clj ,(get-version)))))
