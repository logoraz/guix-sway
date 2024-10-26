(define-module (config home sway-home)
  :use-module (gnu)
  :use-module (gnu home)
  :use-module (gnu home services)
  :use-module (gnu home services pm)
  :use-module (gnu home services gnupg)
  :use-module (gnu home services mcron)
  :use-module (gnu home services shells)
  :use-module (gnu home services sound)
  :use-module (gnu home services desktop)
  :use-module (gnu home services dotfiles)
  :use-module (gnu home services syncthing)
  :use-module (guix gexp)

  :use-module (config home services sway-desktop)
  :use-module (config home services emacs-guile)
  :use-module (config home services udiskie)
  :use-module (config home services home-files-alist)
  :use-module (config home services home-impure-symlinks))

(use-service-modules desktop guix)

(define sway-config
  (map
   (lambda (str)
     (string-append str "\n"))
   (list
    "set $mod Mod4"
    "include \"~/.config/sway/before-config\""
    "bindsym $mod+space exec fuzzel -w 50 -x 8 -y 8 -r 3 -b 232635ff -t A6Accdff -s A6Accdff -S 232635ff -C c792eacc -m c792eacc -f \"JetBrains Mono:weight=light:size=10\""
    "exec mako --border-radius=2 --font=\"JetBrains Mono 8\" --max-visible=5 --outer-margin=5 --margin=3 --background=\"#1c1f26\" --border-color=\"#89AAEB\" --border-size=1 --default-timeout=7000"
    "output \"*\" bg ~/Pictures/wallpapers/sunset-mountain.jpg fill"
    "exec nm-applet --indicator"
    "exec emacs"
    "include \"~/.config/sway/after-config\"")))


(define *home-path* "/home/logoraz/dotfiles/")

(define home-config
  (home-environment

   (services (list
              ;; Enable pipewire audio
              (service home-pipewire-service-type)

              ;; Enable bluetooth connections
              (service home-dbus-service-type)

              ;; (service home-xdg-configuration-files-service-type
              ;;          `(("sway/config" ,(apply mixed-text-file (cons "sway-config" sway-config)))))

              (simple-service 'home-impure-symlinks-dotfiles
                              home-impure-symlinks-service-type
                              `( ;; Guix Configuration
                                (".config/guix/channels.scm"
                                 ,(string-append
                                   *home-path*
                                   "config/system/channels.scm"))
                                ;; Sway Configuration
                                (".config/sway"
                                 ,(string-append
                                   *home-path*
                                   "files/sway"))
                                (".config/gtk-3.0/settings.ini"
                                 ,(string-append
                                   *home-path*
                                   "files/gtk-3.0/settings.ini"))
                                (".config/yambar"
                                 ,(string-append
                                   *home-path*
                                   "files/yambar"))
                                ;; qutebrowser Configuration
                                (".config/qutebrowser"
                                 ,(string-append
                                   *home-path*
                                   "files/qutebrowser"))
                                ;; Emacs Configuration
                                (".config/emacs"
                                 ,(string-append
                                   *home-path*
                                   "files/emacs"))
                                ;; Foot Configuration
                                (".config/foot"
                                 ,(string-append
                                   *home-path*
                                   "files/foot"))))

              ;; Set environment variables for every session
              (simple-service 'profile-env-vars-service
                              home-environment-variables-service-type
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

              (service home-bash-service-type
                       (home-bash-configuration
                        (guix-defaults? #f)
                        (aliases '(("grep" . "grep --color=auto")
                                   ("ls"   . "ls -p --color=auto")
                                   ("ll"   . "ls -l")
                                   ("la"   . "ls -la")))
                        (bashrc
                         (list (local-file "dot-bashrc.sh"
                                           #:recursive? #t)))
                        (bash-profile
                         (list (local-file "dot-bash_profile.sh"
                                           #:recursive? #t)))))
              ;; File synchronization
              (service home-syncthing-service-type)

              ;; Monitor battery levels
              (service home-batsignal-service-type)

              ;; Udiskie for auto-mounting
              (service home-udiskie-service-type)

              ;; Emacs configuration
              (service home-emacs-config-service-type)

              ;; Sway Desktop configuration
              (service home-sway-desktop-service-type)))))


home-config
