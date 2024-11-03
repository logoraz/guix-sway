(define-module (config packages emacs)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:))

;;TODO - doesn't work when exported, only with define-public... why?

;;Note: generate new sha256/base32 via
;; guix hash -x --serializer=nar .
;; guix hash -x --serializer=git .
;; Get commit via git log
(define-public raz-emacs
  (package
   (name "raz-emacs")
   (version "0.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://codeberg.org/loraz/raz-emacs")
                  (commit "234f2d366476b02a7e27ca0a776db474cda679cb")))
            (hash
             (content-hash
              "1zlwd1ipr1ag16vsws4xnbcqgwaqm55byscj8rb291ypp9yzp2yz"
              sha256))))
   (build-system copy-build-system)
   (home-page "https://codeberg.org/loraz/raz-emacs")
   (synopsis "Raz Emacs")
   (description "Raz Emacs")
   (license license:agpl3+)))
