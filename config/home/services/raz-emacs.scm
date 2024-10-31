(define-module (config home services raz-emacs)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services utils)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages emacs)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (config packages emacs)
  #:use-module (ice-9 format)

  #:export (home-raz-emacs-service-type
            home-raz-emacs-configuration))

(define-configuration home-raz-emacs-configuration
  (package
    (package raz-emacs)
    "The Raz Emacs package to use.")
  (emacs-package
   (package emacs-pgtk)
   "The Emacs package to use."))

(define (home-raz-emacs-files-service config)
  (list `(".config/emacs" ,raz-emacs)))

(define (home-raz-emacs-profile-service config)
  (list nss-certs
        (home-raz-emacs-configuration-package config)
        (home-raz-emacs-configuration-emacs-package config)))

(define home-raz-emacs-service-type
  (service-type (name 'home-raz-emacs)
                (description "The home service to confiure Raz Emacs.")
                (extensions
                 (list (service-extension
                        home-files-service-type
                        home-raz-emacs-files-service)
                       (service-extension
                        home-profile-service-type
                        home-raz-emacs-profile-service)))
                (default-value (home-raz-emacs-configuration))))
