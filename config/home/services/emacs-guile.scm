(define-module (config home services emacs-guile)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages sdl)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix transformations)

  #:export (home-emacs-config-service-type))


(define (home-emacs-config-profile-service config)
  (list  ;; emacs-pgtk ;;|--> gnu packages emacs
         emacs-diminish  ;;|--> gnu packages emacs-xyz
         emacs-delight
         emacs-nord-theme
         emacs-doom-themes
         emacs-nerd-icons
         emacs-doom-modeline
         emacs-ligature
         emacs-no-littering
         emacs-ws-butler
         emacs-undo-tree
         emacs-paredit
         emacs-visual-fill-column
         emacs-ace-window
         emacs-mct
         emacs-orderless
         emacs-corfu
         emacs-marginalia
         emacs-beframe
         emacs-denote
         emacs-magit
         emacs-vterm
         emacs-guix
         emacs-arei
         emacs-sly
         emacs-mbsync
         emacs-org-superstar
         emacs-org-appear
         emacs-erc-hl-nicks
         emacs-erc-image
         emacs-emojify
         ;; Magit
         git
         (list git "send-email")
         ;; Guile Integration
         guile-next
         guile-ares-rs
         guile-hoot
         guile-websocket
         guile-sdl2
         sdl2))

(define home-emacs-config-service-type
  (service-type (name 'home-emacs-config)
                (description "Applies my personal Emacs configuration.")
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-emacs-config-profile-service)))
                (default-value #f)))
