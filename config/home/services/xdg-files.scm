(define-module (config home services xdg-files)
  #:use-module (ice-9 optargs)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu home services dotfiles)
  #:export (home-xdg-local-files-service-type))

;; TODO - Refactor, rename symbols accordingly!
(define %home-path "/home/logoraz/.dotfiles/")

(define (home-file dir filename)
  "Resolve local config file."
  (local-file (string-append
               %home-path
               dir "/"
               filename)))

(define (home-xdg-local-files-list-service config)
  `(;; Guix Configuration Channels
    ("guix/channels.scm"
     ,(home-file "config/system" "channels.scm"))

    ;; Sway configuration files
    ("sway/config"
     ,(home-file "files/sway" "config"))

    ("sway/bin/status.sh"
     ,(home-file "files/sway/bin" "status.sh"))

    ;; ("sway/bin/toggle-display.sh"
    ;;  ,(home-file "files/sway/bin" "toggle-display.sh"))

    ;; GTK configuration
    ("gtk-3.0/settings.ini"
     ,(home-file "files/gtk-3.0" "settings.ini"))

    ;; Terminal configuration
    ("foot/foot.ini"
     ,(home-file "files/foot" "foot.ini"))

    ;; qutebrowser Configuration Files
    ("qutebrowser/config.py"
     ,(home-file "files/qutebrowser" "config.py"))

    ("qutebrowser/quteconfig.py"
     ,(home-file "files/qutebrowser" "quteconfig.py"))

    ("qutebrowser/qutemacs.py"
     ,(home-file "files/qutebrowser" "qutemacs.py"))))

(define home-xdg-local-files-service-type
  (service-type (name 'home-xdg-files)
                (description "Service for setting up XDG local files.")
                (extensions
                 (list (service-extension
                        home-xdg-configuration-files-service-type
                        home-xdg-local-files-list-service)))
                (default-value #f)))


;; TODO - use define-configuration to create a better suited configuration interface using
;; the functionality of iambumblehead's home-alist.scm to provide a clean interface for users
;; to define xdg-local files to be symlinked into the XDG_HOME_DIR.
