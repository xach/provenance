;;;; provenance.lisp

(in-package #:provenance)

;;; "provenance" goes here. Hacks and glory await!

(deftype provenance-value ()
  '(or integer keyword string boolean))

(defun provenance-value-p (object)
  (typep object 'provenance-value))

(defun valid-provenance-p (provenance)
  (or (provenance-value-p provenance)
      (and (consp provenance)
           (valid-provenance-p (car provenance))
           (valid-provenance-p (cdr provenance)))))

(defun provenance-vector (provenance)
  (with-standard-io-syntax
    (let ((*package* (find-package '#:keyword))
          (*print-case* :downcase))
      (trivial-utf-8:string-to-utf-8-bytes (prin1-to-string provenance)))))

(defun name-vector (name)
  (trivial-utf-8:string-to-utf-8-bytes name))

(defun table-to-cdb (hash-table cdb-file &optional temp-file)
  (unless temp-file
    (setf temp-file (make-pathname :name (format nil "~A-cdb-tmp"
                                                 (pathname-name cdb-file))
                                   :defaults cdb-file)))
  (zcdb:with-output-to-cdb (cdb cdb-file temp-file)
    (maphash (lambda (name provenance)
               (unless (stringp name)
                 (error "Invalid key in table: ~S" name))
               (unless (valid-provenance-p provenance)
                 (error "Invalid provenance for key ~S: ~S" name provenance))
               (zcdb:add-record (name-vector name)
                                (provenance-vector provenance)
                                cdb))
             hash-table)))
