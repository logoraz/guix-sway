(define-module (config home utils home-files-alist)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 optargs)
  #:export (home-file-dirs->alists))

(define %current-dir (dirname (current-filename)))
(define root-re (make-regexp "^\\/"))
(define dot-re (make-regexp "^\\.\\.?"))
(define tmp-re (make-regexp "~$"))

(define (path-join . args)
  (string-join args file-name-separator-string))

(define (path-expand path)
  (if (regexp-exec root-re path)
      path (path-join %current-dir path)))

(define (path-diff path-sub path-full)
  "(/full/path/ /full/path/to/file.cfg) -> to/file.cfg"
  (let ((path-sub-and-slash
         (string-append (dirname (path-expand path-sub))
                        file-name-separator-string)))
    (string-replace-substring path-full path-sub-and-slash "")))

(define (not-tmp-or-dot? str)
  (and (not (regexp-exec dot-re str))
       (not (regexp-exec tmp-re str))))

(define (list-recursive path-or-dir . files)
  (let ((filestat (stat path-or-dir)))
    (cond ((eq? (stat:type filestat) 'directory)
           (fold (lambda (str prev)
                   (append prev
                           (list-recursive
                            (path-join path-or-dir str))))
                 files
                 (scandir path-or-dir not-tmp-or-dot?)))
          ((eq? (stat:type filestat) 'regular)
           (cons path-or-dir files))
          (else files))))

(define (home-file-dir->list source home-lists)
  (let ((files (list-recursive source)))
    (fold (lambda (path-to prev)
            (let ((path-full (path-expand path-to)))
              (cons (list (path-diff source path-full)
                          (local-file path-full #:recursive? #t))
                    prev)))
          home-lists
          files)))

(define* (home-file-dirs->alists sources #:key (alist '()))
  (fold (lambda (source prev)
          (home-file-dir->list source prev))
        alist
        sources))
