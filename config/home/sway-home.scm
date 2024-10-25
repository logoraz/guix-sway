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
  :use-module (guix transformations)
  :use-module (config home services home-files-alist)
  :use-module (config home services home-impure-symlinks)
  :use-module (config home services udiskie))

(use-service-modules desktop guix)
(use-package-modules bootloaders certs gnuzilla emacs emacs-xyz version-control wm
                     compression curl fonts freedesktop gimp glib gnome gnome-xyz
                     gstreamer kde-frameworks linux package-management
                     password-utils pdf pulseaudio shellutils ssh syncthing video
                     web-browsers wget xdisorg xorg

                     guile guile-xyz sdl gnucash gimp inkscape graphics terminals
                     image networking qt music)

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

;;; Package Transformations
;; Keep for now as an example
;; deploy in package list as (latest-sbcl sbcl)
;; (define latest-sbcl
;;   (options->transformation
;;    '((with-latest . "sbcl"))))

;;; Packages
(define guile-packages
  (list guile-next    ;;|--> gnu packages guile
        guile-ares-rs ;;|--> gnu packages guile-xyz
        guile-hoot
        guile-websocket
        guile-sdl2 ;;|--> gnu package sdl
        sdl2))

;;TODO - Better organize & comment
;; https://github.com/daviwil/dotfiles/blob/master/daviwil/home-services/desktop.scm
(define sway-packages
  (list  swaybg
         swayidle
         wl-clipboard
         fuzzel
         mako
         grimshot ;; grimshot --notify copy area
         network-manager-applet

         ;; Compatibility for older Xorg applications
         xorg-server-xwayland

         ;; XDG Utilities
         xdg-utils ;; For xdg-open, etc
         xdg-dbus-proxy
         shared-mime-info
         udiskie
         (list glib "bin")

         ;; Appearance
         matcha-theme
         papirus-icon-theme
         adwaita-icon-theme
         gnome-themes-extra
         bibata-cursor-theme

         ;; Fonts
         font-jetbrains-mono
         font-liberation
         font-hack
         font-fira-code
         font-iosevka-aile
         font-google-noto
         font-google-noto-emoji
         font-google-noto-sans-cjk

         ;; Browsers
         icecat
         qtwayland
         ;; (specification->package "qtwayland@5")
         qutebrowser

         ;; Authentication
         keepassxc
         password-store

         ;; Audio devices and media playback
         mpv      ;;|--> gnu packages video
         mpv-mpris
         youtube-dl
         playerctl
         gstreamer
         gst-plugins-good
         gst-plugins-bad
         gst-libav
         ;; alsa-utils
         ;; pavucontrol
         pipewire ;;|--> gnu packages linux
         wireplumber

         ;; Applications
         foot     ;;|--> gnu packages terminals
         gnucash  ;;|--> gnu packages gnucash
         gimp     ;;|--> gnu packages gimp
         inkscape ;;|--> gnu packages inkscape
         blender  ;;|--> gnu packages graphics

         ;; General utilities
         lm-sensors
         blueman ;;|--> gnu packages networkings
         bluez
         brightnessctl
         git
         (list git "send-email")
         curl
         wget
         openssh
         zip
         unzip
         trash-cli))

(define emacs-packages
  (list  emacs-pgtk ;;|--> gnu packages emacs
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
         emacs-emojify))

(define *home-path* "/home/logoraz/dotfiles/")

(define home-config
  (home-environment
   (packages (append guile-packages
                     sway-packages
                     emacs-packages))

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
              (service home-udiskie-service-type)))))

home-config
