(define-module (config packages emacs)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:))

;;TODO - doesn't work when exported, only with define-public... why?

;;Note: generate new sha256/base32 via
;; guix hash -x --serializer=nar .
;; Get commit via git log
(define-public raz-emacs
  (package
   (name "raz-emacs")
   (version "0.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/logoraz/raz-emacs/")
                  (commit "a5cd2c0b862113f83f6ef6e31905509a9fc2c7a6")))
            (sha256
             (base32
              "0njdf5xxx7bp22pk389hh7vw14n870d5rnmzs6vxc06drc586ygr"))))
   (build-system copy-build-system)
   (home-page "https://github.com/logoraz/raz-emacs")
   (synopsis "Raz Emacs")
   (description "Raz Emacs")
   (license license:agpl3+)))
