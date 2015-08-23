;; -*- coding: utf-8 -*-

(defun xah-open-in-gimp ()
  "Open the current file or `dired' marked files in gimp.
Guaranteed to work on linux. Not tested on Microsoft Windows or Mac OS X
Version 2015-06-16"
  (interactive)
  (let* (
         (ξfile-list
          (if (string-equal major-mode "dired-mode")
              (dired-get-marked-files)
            (list (buffer-file-name))))
         (ξdo-it-p (if (<= (length ξfile-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))

    (when ξdo-it-p
      (cond
       ((string-equal system-type "windows-nt")
        (mapc
         (lambda (ξfpath)
           (w32-shell-execute "gimp" (replace-regexp-in-string "/" "\\" ξfpath t t))) ξfile-list))
       ((string-equal system-type "darwin")
        (mapc
         (lambda (ξfpath) (shell-command (format "gimp \"%s\"" ξfpath)))  ξfile-list))
       ((string-equal system-type "gnu/linux")
        (mapc
         (lambda (ξfpath) (let ((process-connection-type nil)) (start-process "" nil "gimp" ξfpath))) ξfile-list))))))

(defun xah-dired-to-zip ()
  "Zip the current file in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip command line tool.

URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-07-30"
  (interactive)
  (require 'dired)
  (let ( (fileName (elt (dired-get-marked-files) 0)))
    (shell-command
     (format
      "zip -r '%s.zip' '%s'"
      (file-relative-name fileName)
      (file-relative-name fileName)))))

(defun xah-process-image (φfile-list φargs-str φnew-name-suffix φnew-name-file-suffix )
  "Create a new image.
φfile-list is a list of image file paths.
φargs-str is argument string passed to ImageMagick's “convert” command.
φnew-name-suffix is the string appended to file. e.g. “_new” gets you “…_new.jpg”
φnew-name-file-suffix is the new file's file extension. e.g. “.png”
Requires ImageMagick shell command.

URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-03-10"
  (require 'dired)
  (mapc
   (lambda (ξf)
     (let ( newName cmdStr )
       (setq newName (concat (file-name-sans-extension ξf) φnew-name-suffix φnew-name-file-suffix) )
       (while (file-exists-p newName)
         (setq newName (concat (file-name-sans-extension newName) φnew-name-suffix (file-name-extension newName t))) )

       ;; relative paths used to get around Windows/Cygwin path remapping problem
       (setq cmdStr
             (format "convert %s '%s' '%s'" φargs-str (file-relative-name ξf) (file-relative-name newName)) )
       (shell-command cmdStr)
       ))
   φfile-list ))

(defun xah-dired-scale-image (φfile-list φscale-percentage φsharpen?)
  "Create a scaled version of images of marked files in dired.
The new names have “-s” appended before the file name extension.

If `universal-argument' is given, output is PNG format. Else, JPG.

When called in lisp code,
 φfile-list is a list.
 φscale-percentage is a integer.
 φsharpen? is true or false.

Requires ImageMagick unix shell command.
URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-03-10"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList
           (read-from-minibuffer "Scale %:")
           (y-or-n-p "Sharpen"))))
  (let ((sharpenOrNo (if φsharpen? "-sharpen 1" "" ))
        (outputSuffix (if current-prefix-arg ".png" ".jpg" )))
    (xah-process-image φfile-list
                       (format "-scale %s%% -quality 85%% %s " φscale-percentage sharpenOrNo)
                       "-s" outputSuffix )))

(defun xah-dired-image-autocrop (φfile-list φoutput-image-type-suffix)
  "Create a new auto-cropped version of images of marked files in dired.
Requires ImageMagick shell command.

If `universal-argument' is given, output is PNG format. Else, JPG.
URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-03-10"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:")))))
         (φoutput-image-type-suffix (if current-prefix-arg ".png" ".jpg" )))
     (list myFileList φoutput-image-type-suffix)))
  (xah-process-image φfile-list "-trim" "-cropped" φoutput-image-type-suffix ))

(defun xah-dired-2png (φfile-list)
  "Create a png version of images of marked files in dired.
Requires ImageMagick shell command.
URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-03-10"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList)))
  (xah-process-image φfile-list "" "-2" ".png" ))

(defun xah-dired-2drawing (φfile-list φgrayscale-p φmax-colors-count)
  "Create a png version of (drawing type) images of marked files in dired.
Basically, make it grayscale, and reduce colors to any of {2, 4, 16, 256}.
Requires ImageMagick shell command.

2015-07-09"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList
           (setq φgrayscale-p (yes-or-no-p "Grayscale?"))
           (ido-completing-read "Max number of colors:" '( "2" "4" "16" "256" )))))
  (xah-process-image φfile-list
                     (format "+dither %s -depth %s"
                             (if φgrayscale-p "-type grayscale" "")
                             ;; image magick “-colors” must be at least 8
                             ;; (if (< (string-to-number φmax-colors-count) 3)
                             ;;     8
                             ;;     (expt 2 (string-to-number φmax-colors-count)))
                             (cond
                              ((equal φmax-colors-count "256") 8)
                              ((equal φmax-colors-count "16") 4)
                              ((equal φmax-colors-count "4") 2)
                              ((equal φmax-colors-count "2") 1)
                              (t (error "logic error 0444533051: impossible condition on φmax-colors-count: %s" φmax-colors-count)))
                             φmax-colors-count)  "-2" ".png" ))

(defun xah-dired-2jpg (φfile-list)
  "Create a JPG version of images of marked files in dired.
Requires ImageMagick shell command.
URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-04-30"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList)))
  (xah-process-image φfile-list "-quality 90%" "-2" ".jpg" ))

(defun xah-dired-crop-image (φfile-list)
  " .......
Requires ImageMagick shell command."
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList)))
  (xah-process-image φfile-list "-crop 690x520+220+165" "_n" ".png" ))

(defun xah-dired-remove-all-metadata (φfile-list)
  "Remove all metatata of buffer image file or marked files in dired.
 (typically image files)
URL `http://xahlee.info/img/metadata_in_image_files.html'
Requires exiftool shell command.

URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-03-10"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList)))
  (if (y-or-n-p "Sure to remove all metadata?")
      (mapc
       (lambda (ξf)
         (let (cmdStr)
           (setq cmdStr
                 (format "exiftool -all= -overwrite_original '%s'" (file-relative-name ξf))) ; relative paths used to get around Windows/Cygwin path remapping problem
           (shell-command cmdStr)))
       φfile-list )
    nil
    ))

(defun xah-dired-show-metadata (φfile-list)
  "Display metatata of buffer image file or marked files in dired.
 (typically image files)
URL `http://xahlee.info/img/metadata_in_image_files.html'
Requires exiftool shell command.
URL `http://ergoemacs.org/emacs/emacs_dired_convert_images.html'
Version 2015-03-10"
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:"))))))
     (list myFileList)))
  (mapc
   (lambda (ξf)
     (let (cmdStr)
       (setq cmdStr
             (format "exiftool '%s'" (file-relative-name ξf))) ; relative paths used to get around Windows/Cygwin path remapping problem
       (shell-command cmdStr)))
   φfile-list ))

(defun xah-dired-sort ()
  "Sort dired dir listing in different ways.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/dired_sort.html'
Version 2015-07-30"
  (interactive)
  (let (ξsort-by ξarg)
    (setq ξsort-by (ido-completing-read "Sort by:" '( "date" "size" "name" "dir")))
    (cond
     ((equal ξsort-by "name") (setq ξarg "-Al --si --time-style long-iso "))
     ((equal ξsort-by "date") (setq ξarg "-Al --si --time-style long-iso -t"))
     ((equal ξsort-by "size") (setq ξarg "-Al --si --time-style long-iso -S"))
     ((equal ξsort-by "dir") (setq ξarg "-Al --si --time-style long-iso --group-directories-first"))
     (t (error "logic error 09535" )))
    (dired-sort-other ξarg )))

