(define-module (config home services xdg-files)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu home services dotfiles)
  #:export (home-xdg-local-files-service-type))

(define %home-path "/home/logoraz/dotfiles/")

(define (home-file dir filename)
  "Resolve local config file."
  (local-file (string-append
               %home-path
               dir "/"
               filename)))

(define (home-xdg-local-files-list-service config)
  `(("sway/config"
     ,(home-file "files/sway" "config"))
    ("sway/status.sh"
     ,(home-file "files/sway" "status.sh"))

    ;; GTK configuration
    ("gtk-3.0/settings.ini"
     ,(home-file "files/gtk-3.0" "settings.ini"))
    ("foot/foot.ini"
     ,(home-file "files/foot" "foot.ini"))

    ;; qutebrowser Configuration Files
    ("qutebrowser/config.py"
     ,(home-file "files/qutebrowser" "config.py"))
    ("qutebrowser/quteconfig.py"
     ,(home-file "files/qutebrowser" "quteconfig.py"))

    ;; Emacs Configuration Files
    ("emacs/early-init.el"
     ,(home-file "files/emacs" "early-init.el"))
    ("emacs/init.el"
     ,(home-file "files/emacs" "init.el"))
    ("emacs/elisp/raz-subrx.el"
     ,(home-file "files/emacs/elisp" "raz-subrx.el"))
    ("emacs/modules/raz-base-core.el"
     ,(home-file "files/emacs/modules" "raz-base-core.el"))
    ("emacs/modules/raz-base-ext.el"
     ,(home-file "files/emacs/modules" "raz-base-ext.el"))
    ("emacs/modules/raz-completions-mct.el"
     ,(home-file "files/emacs/modules" "raz-completions-mct.el"))
    ("emacs/modules/raz-denote.el"
     ,(home-file "files/emacs/modules" "raz-denote.el"))
    ("emacs/modules/raz-erc.el"
     ,(home-file "files/emacs/modules" "raz-erc.el"))
    ("emacs/modules/raz-guile-ide.el"
     ,(home-file "files/emacs/modules" "raz-guile-ide.el"))
    ("emacs/modules/raz-lisp-ide.el"
     ,(home-file "files/emacs/modules" "raz-lisp-ide.el"))
    ("emacs/modules/raz-org.el"
     ,(home-file "files/emacs/modules" "raz-org.el"))))

(define home-xdg-local-files-service-type
  (service-type (name 'home-xdg-files)
                (description "Service for setting up XDG local files.")
                (extensions
                 (list (service-extension
                        home-xdg-configuration-files-service-type
                        home-xdg-local-files-list-service)))
                (default-value #f)))
