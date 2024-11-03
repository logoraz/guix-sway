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
                  (url "https://codeberg.org/loraz/raz-emacs.git")
                  (commit "b6f7d5ec0d2550d4441cc853a1ff26c271e3658783c8a143cd7c34e42db841fb")))
            (sha256
             (base32
              "0bn67gnvyhfzqhszixahnn6vs2cpljwhhqjazj6wfi3vi4bpaqvs"))))
   (build-system copy-build-system)
   (home-page "https://github.com/logoraz/raz-emacs")
   (synopsis "Raz Emacs")
   (description "Raz Emacs")
   (license license:agpl3+)))
