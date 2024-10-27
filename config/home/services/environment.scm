(define-module (config home services environment)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  ;; #:use-module (guix gexp)
  #:use-module (gnu home services dotfiles)
  #:export (home-env-vars-configuration-service-type))


(define (home-env-vars-configuration config)
  '( ;; Sort hidden (dot) files first in ls listings
    ("LC_COLLATE" . "C")
    ;; Set Emacs as editor
    ("EDITOR" . "emacs")
    ("VISUAL" . "emacs")
    ;; Set quotebrowser as the default
    ("BROWSER" . "qutebrowser")
    ;; Set wayland-specific environment variables
    ("XDG_CURRENT_DESKTOP" . "sway")
    ("XDG_SESSION_TYPE" . "wayland")
    ("RTC_USE_PIPEWIRE" . "true")
    ("SDL_VIDEODRIVER" . "wayland")
    ("MOZ_ENABLE_WAYLAND" . "1")
    ("CLUTTER_BACKEND" . "wayland")
    ("ELM_ENGINE" . "wayland_egl")
    ("ECORE_EVAS_ENGINE" . "wayland-egl")
    ("QT_QPA_PLATFORM" . "wayland-egl")

    ;; Set XDG environment variables
    ("XDG_DOWNLOAD_DIR" . "/home/logoraz/Downloads")
    ("XDG_PICTURES_DIR" . "/home/logoraz/Pictures/Screenshots")
    ("GUILE_WARN_DEPRECATED" . "detailed")))

(define home-env-vars-configuration-service-type
  (service-type (name 'home-profile-env-vars-service)
                (description "Service for setting up profile env vars.")
                (extensions
                 (list (service-extension
                        home-environment-variables-service-type
                        home-env-vars-configuration)))
                (default-value #f)))
