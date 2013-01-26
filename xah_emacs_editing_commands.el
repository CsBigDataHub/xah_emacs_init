;; -*- coding: utf-8 -*-
;; some general commands related to editing text

;; 2011-05-27
;;   Xah Lee
;; ∑ http://xahlee.org/

(defun copy-file-path (prefixArgCode)
  "Copy the current buffer's file path or dired path to `kill-ring'.
If `universal-argument' is called, copy only the dir path."
  (interactive "P")
  (let ((fPath
         (if (equal major-mode 'dired-mode)
             default-directory
           (buffer-file-name)
           )))
    (kill-new 
     (if (equal prefixArgCode nil)
         fPath
       (file-name-directory fPath)
       )))  
  (message "File path copied.") )


(defun copy-to-register-1 ()
  "Copy current line or text selection to register 1.
See also: `paste-from-register-1', `copy-to-register'."
  (interactive)
  (let* (
         (bds (get-selection-or-unit 'line ))
         (inputStr (elt bds 0) )
         (p1 (elt bds 1) )
         (p2 (elt bds 2) )
         )
    (copy-to-register ?1 p1 p2)
    (message "copied to register 1: 「%s」." inputStr)
))

(defun paste-from-register-1 ()
  "paste text from register 1.
See also: `copy-to-register-1', `insert-register'."
  (interactive)
  (insert-register ?1 t))

(defun compact-parens ()
  "Removing white spaces in ending parenthesises.
Removes white space from cursor point to end of code block (\n\n).
Or, act on a text selection.
Warning: This command does not preserve texts inside double quotes."
  (interactive)
  (let (inputStr resultText p1 p2)

    (setq inputStr
          (if (region-active-p)
              (progn (setq p1 (region-beginning) ) (setq p2 (region-end) ))
            (save-excursion
              (setq p1 (point) )
              (search-forward-regexp "\n\n" nil t)
              (setq p2 (- (point) 2))
              )))

    (setq resultText (replace-regexp-pairs-in-string (buffer-substring-no-properties p1 p2) '(["[ \t\n]+)[ \t\n]+" " )"])) )

    (delete-region p1 p2)
    (insert resultText) ) )



;; (defun my-delete-word (arg)
;;   "Delete characters forward until encountering the end of a word.
;; With argument, do this that many times.
;; This command does not push erased text to kill-ring."
;;   (interactive "p")
;;   (delete-region (point) (progn (forward-word arg) (point))))

;; (defun my-backward-delete-word (arg)
;;   "Delete characters backward until encountering the beginning of a word.
;; With argument, do this that many times.
;; This command does not push erased text to kill-ring."
;;   (interactive "p")
;;   (my-delete-word (- arg)))

;; (defun my-delete-line ()
;;   "Delete text from current position to end of line char."
;;   (interactive)
;;   (delete-region
;;    (point)
;;    (save-excursion (move-end-of-line 1) (point)))
;;   (delete-char 1)
;; )


(defun 2zip ()
  "Zip the current file in `dired'.
If multiple files are marked, only zip the first one.
Require unix zip commandline tool."
  (interactive)
  (require 'dired)
  (let ( (fileName (elt (dired-get-marked-files) 0))  )
    (shell-command (format "zip -r '%s.zip' '%s'" (file-relative-name fileName) (file-relative-name fileName)))
    ))

(defun process-image (fileList argsString newNameSuffix newNameFileSuffix )
  "Create a new image.
fileList is a list of image file paths.
argsString is argument string passed to ImageMagick's “convert” command.
newNameSuffix is the string appended to file. e.g. “_new” gets you “cat_new.jpg”
newNameFileSuffix is the new file's file extension. e.g. “.png”
Requires ImageMagick shell tool."
  (require 'dired)
  (mapc
   (lambda (ξf)
     (let ( newName cmdStr )
       (setq newName (concat (file-name-sans-extension ξf) newNameSuffix newNameFileSuffix) )
       (while (file-exists-p newName)
         (setq newName (concat (file-name-sans-extension newName) newNameSuffix (file-name-extension newName t))) )

       ;; relative paths used to get around Windows/Cygwin path remapping problem
       (setq cmdStr
             (format "convert %s '%s' '%s'" argsString (file-relative-name ξf) (file-relative-name newName)) )
       (shell-command cmdStr)
       ))
   fileList ))

(defun scale-image (fileList scalePercentage)
  "Create a scaled jpg version of images of marked files in dired.
The new names have “-s” appended before the file name extension.

Requires ImageMagick shell tool."
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:") )) ) ) )
     (list myFileList (read-from-minibuffer "scale percentage:")) )
   )
  (process-image fileList (concat "-scale " scalePercentage "% -quality 85% -sharpen 1 " ) "-s" ".jpg" )
  )

(defun image-autocrop (fileList)
  "Create a new auto-cropped jpg version of images of marked files in dired.
Requires ImageMagick shell tool."
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:") )) ) ) )
     (list myFileList) )
   )
  (process-image fileList "-trim" "-c" ".jpg" )
  )

(defun 2png (fileList)
  "Create a png version of images of marked files in dired.
Requires ImageMagick shell tool."
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:") )) ) ) )
     (list myFileList) )
   )
  (process-image fileList "" "-2" ".png" )
  )

(defun 2drawing (fileList grayscale-p bitsPerPixel)
  "Create a png version of (drawing type) images of marked files in dired.
Requires ImageMagick shell tool."
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:") )) ) ) )
     (list myFileList
           (setq grayscale-p (yes-or-no-p "Grayscale?"))
           (read-string "Bits per pixel (1 2 4 8):" "4")) ) )
  (process-image fileList
                 (format "+dither %s -depth %s"
                         (if grayscale-p "-type grayscale" "")
                         ;; image magick “-colors” must be at least 8
                         ;; (if (< (string-to-number bitsPerPixel) 3)
                         ;;     8
                         ;;     (expt 2 (string-to-number bitsPerPixel)))
                         bitsPerPixel)  "-2" ".png" )
  )

(defun 2jpg (fileList)
  "Create a jpg version of images of marked files in dired.
Requires ImageMagick shell tool."
  (interactive
   (let (
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((string-equal major-mode "image-mode") (list (buffer-file-name)))
           (t (list (read-from-minibuffer "file name:") )) ) ) )
     (list myFileList) )
   )
  (process-image fileList "" "-2" ".jpg" ))



(defun copy-rectangle-to-clipboard (p1 p2)
  "Copy region as column (rectangle) to operating system's clipboard.
This command will also put the text in register 0.

See also: `kill-rectangle', `copy-to-register'."
  (interactive "r")
  (let ((x-select-enable-clipboard t))
    (copy-rectangle-to-register ?0 p1 p2)
    (kill-new
     (with-temp-buffer
       (insert-register ?0)
       (buffer-string) )) ) )

