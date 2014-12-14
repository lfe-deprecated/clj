(defmacro in? (item collection)
  `(orelse ,@(lists:map
               (lambda (x)
                 `(== ,x ,item))
               collection)))

(defmacro not-in? (item collection)
  `(not (in? ,item ,collection)))

(defun string? (data)
  (io_lib:printable_list data))

(defun unicode? (data)
  (io_lib:printable_unicode_list data))

(defun list? (data)
  (and (is_list data) (not (string? data))))

(defun tuple? (data)
  (is_tuple data))

(defun atom? (data)
  (is_atom data))

(defun binary? (data)
  (is_binary data))

(defun bitstring? (data)
  (is_bitstring data))

(defun bool? (data)
  (is_boolean data))

(defun float? (data)
  (is_float data))

(defun function? (data)
  (is_function data))

(defun function? (data arity)
  (is_function data arity))

(defun func? (data)
  (is_function data))

(defun func? (data arity)
  (is_function data arity))

(defun integer? (data)
  (is_integer data))

(defun int? (data)
  (is_integer data))

(defun number? (data)
  (is_number data))

(defun record? (data record-tag)
  (is_record data record-tag))

(defun record? (data record-tag size)
  (is_record data record-tag size))

(defun reference? (data)
  (is_reference data))

(defun dict?
  ((data) (when (== 'dict (element 1 data)))
    'true)
  ((_)
    'false))

(defun undefined? (x)
  (== x 'undefined))

(defun undef? (x)
  (== x 'undefined))

(defun nil? (x)
  (or (== x 'nil)
      (== x '())))

(defun true? (x)
  (== x 'true))

(defun false? (x)
  (== x 'false))

(defun odd? (x)
  (== 1 (rem x 2)))

(defun even? (x)
  (== 0 (rem x 2)))

(defun zero? (x)
  (== 0 x))

(defun pos? (x)
  (> x 0))

(defun neg? (x)
  (< x 0))

