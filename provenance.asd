;;;; provenance.asd

(asdf:defsystem #:provenance
  :description "Converts Quicklisp project provenance info to a cdb file."
  :author "Zach Beane <xach@xach.com>"
  :license "MIT"
  :depends-on (#:zcdb
               #:trivial-utf-8)
  :serial t
  :components ((:file "package")
               (:file "provenance")))

