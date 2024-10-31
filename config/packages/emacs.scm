(define-module (config packages emacs)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:))

;;TODO - doesn't work when exported, only with define-public... why?
(define-public raz-emacs
  (package
   (name "raz-emacs")
   (version "0.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/logoraz/raz-emacs/")
                  (commit "22031518da108667abd938351b1fbaf8d9720f72")))
            (sha256
             (base32
              "16y409s5nqmnk9lxy46rf8nkrl349rw1imhmjja49mx5ww8gvwzx"))))
   (build-system copy-build-system)
   (home-page "https://github.com/logoraz/raz-emacs")
   (synopsis "Raz Emacs")
   (description "Raz Emacs")
   (license license:agpl3+)))
