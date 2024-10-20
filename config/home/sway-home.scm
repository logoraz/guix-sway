(define-module (config home sway-home)
  :use-module (gnu)
  :use-module (gnu home)
  :use-module (gnu home services)
  :use-module (gnu home services pm)
  :use-module (gnu home services gnupg)
  :use-module (gnu home services mcron)
  :use-module (gnu home services shells)
  :use-module (gnu home services desktop)
  :use-module (gnu home services dotfiles)
  :use-module (guix gexp)
  :use-module (guix transformations)
  :use-module (config home services home-impure-symlinks))

(use-service-modules desktop guix)
(use-package-modules bootloaders certs gnuzilla emacs emacs-xyz version-control wm
                     compression curl fonts freedesktop gimp glib gnome gnome-xyz
                     gstreamer kde-frameworks linux music package-management
                     password-utils pdf pulseaudio shellutils ssh syncthing video
                     web-browsers wget xdisorg xorg

                     guile guile-xyz sdl gnucash gimp inkscape graphics)

(define user-name "logoraz")

(define sway-config
  (map
   (lambda (str)
     (string-append str "\n"))
   (list
    "set $mod Mod4"
    "include \"~/.config/sway/before-config\""
    "bindsym $mod+space exec fuzzel -w 50 -x 8 -y 8 -r 3 -b 232635ff -t A6Accdff -s A6Accdff -S 232635ff -C c792eacc -m c792eacc -f \"JetBrains Mono:weight=light:size=10\" --no-fuzzy"
    "exec mako --border-radius=2 --font=\"JetBrains Mono 8\" --max-visible=5 --outer-margin=5 --margin=3 --background=\"#1c1f26\" --border-color=\"#89AAEB\" --border-size=1 --default-timeout=7000"
    "exec nm-applet --indicator"
    "exec emacs"
    "include \"~/.config/sway/after-config\"")))

;;; Package Transformations
(define latest-nyxt
  (options->transformation
   '((without-tests . "nyxt")
     (with-latest   . "nyxt"))))

;;; Packages
(define guile-packages
  (list guile-next ;;|--> gnu packages guile
        guile-ares-rs ;;|--> gnu packages guile-xyz
        guile-hoot
        guile-websocket
        guile-sdl2 ;;|--> gnu package sdl
        sdl2))

(define sway-packages
  (list  sway
         swaybg
         swayidle
         swaylock
         fuzzel
         mako
         grimshot
         network-manager-applet
         ;; Emacs
         emacs-pgtk
         ;; Browser
         icecat
         (latest-nyxt nyxt)
         gstreamer
         gst-plugins-good
         gst-plugins-bad
         gst-libav
         keepassxc
         ;; Compatibility for older Xorg applications
         xorg-server-xwayland
         ;; Flatpak and XDG utilities
         xdg-utils ;; For xdg-open, etc
         xdg-dbus-proxy
         shared-mime-info
         (list glib "bin")
         ;; Appearance
         gnome-themes-extra
         adwaita-icon-theme
         ;; Fonts
         font-jetbrains-mono
         font-liberation
         font-fira-code
         font-iosevka-aile
         font-google-noto
         font-google-noto-emoji
         font-google-noto-sans-cjk
         ;; Audio utils
         alsa-utils
         pavucontrol
         ;; Applications
         gnucash   ;;|--> gnu packages gnucash
         gimp      ;;|--> gnu packages gimp
         inkscape  ;;|--> gnu packages inkscape
         blender   ;;|--> gnu packages graphics
         ;; General utilities
         git
         curl
         wget
         openssh
         zip
         unzip
         trash-cli))

(define emacs-packages
  (list  emacs                    ;;|--> gnu packages emacs
         emacs-diminish           ;;|--> gnu packages emacs-xyz
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
              (service home-dbus-service-type) ;; for bluetooth --> system
              (service home-xdg-configuration-files-service-type
                       `(("sway/config" ,(apply mixed-text-file (cons "sway-config" sway-config)))))

              (simple-service 'home-impure-symlinks-dotfiles
                              home-impure-symlinks-service-type
                              `( ;; guix Configuration Scaffolding
                                (".config/guix/channels.scm"
                                 ,(string-append
                                   *home-path*
                                   "config/system/channels.scm"))
                                ;; Emacs Configuration Scaffolding
                                (".config/emacs"
                                 ,(string-append
                                   *home-path*
                                   "files/emacs"))
                                ;; Nyxt Configuration Scaffolding
                                (".config/nyxt"
                                 ,(string-append
                                   *home-path*
                                   "files/nyxt"))
                                (".local/share/nyxt/extensions"
                                 ,(string-append
                                   *home-path*
                                   "files/nyxt/extensions"))))
              (simple-service 'env-vars home-environment-variables-service-type
                              '(("EDITOR" . "emacs")
                                ("BROWSER" . "nyxt")
                                ;; ("OPENER" . "opener.sh")
                                ;; ("XDG_SESSION_TYPE" . "x11")
                                ;; ("XDG_SESSION_DESKOP" . "stumpwm")
                                ;; ("XDG_CURRENT_DESKTOP" . "stumpwm")
                                ;; ("XDG_DOWNLOAD_DIR" . "/home/logoraz/Downloads")
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
              ))))
