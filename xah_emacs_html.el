;; -*- coding: utf-8; lexical-binding: t; -*-
;; stuff related to HTML
;; most things moved to xah-html-mode
;; ∑ http://xahlee.org/

(defun forward-html-end-tag ()
  "Move cursor to the next HTML tag's content."
  (interactive)
  (forward-char 1)
  (search-forward "</")
  (backward-char 2)
  )

(defun backward-html-end-tag ()
  "Move cursor to the previous HTML tag's content."
  (interactive)
  (search-backward "</")
  ;; (forward-char-char 2)
  )

(defun xah-insert-reference-span-tag ()
  "Add <span class=\"ref\">…</span> tag to current HTML element or text selection.
Version 2016-11-10"
  (interactive)
  (require 'xah-html-mode)
  (let ( $p1 $p2 )
    (if (use-region-p)
         (setq $p1 (region-beginning) $p2 (region-end))
      (progn
        (xah-html-skip-tag-backward)
        (setq $p1 (point))
        (xah-html-skip-tag-forward)
        (setq $p2 (point))))
    (set-mark $p1)
    (goto-char $p2)
    (xah-html-insert-open-close-tags "span" "ref" $p1 $p2)
    ;; (xah-html-wrap-html-tag "span" "ref")
    ))

(defun xahsite-update-article-timestamp ()
  "Update article's timestamp.
Add today's date to the “byline” tag of current file, also delete the last one if there are more than one.
This command saves buffer if it's a file.
Also, move cursor there.
Also, pushes mark. You can go back to previous location `exchange-point-and-mark'.
Also, removes repeated empty lines.

Version 2018-12-03"
  (interactive)
  (save-excursion ; remove empty lines
    (progn
      (goto-char (point-min))
      (while (re-search-forward "\n\n\n+" nil t)
        (replace-match (make-string 2 ?\n)))))
  (let ($p1 $p2 $num $bufferTextOrig )
    (push-mark)
    (goto-char 1)
    (when (search-forward "<div class=\"byline\">" nil)
      (progn ;; set $p1 $p2. they are boundaries of inner text
        (setq $p1 (point))
        (backward-char 1)
        (search-forward "</div>" )
        (backward-char 6)
        (setq $p2 (point))
        (let (($bylineText (buffer-substring-no-properties $p1 $p2)))
          (when (> (length $bylineText) 110)
            (user-error "something's probably wrong. the length for the byline is long: 「%s」" $bylineText ))))
      (save-restriction ; update article timestamp
        (narrow-to-region $p1 $p2)
        (setq $bufferTextOrig (buffer-string ))
        (setq $num (count-matches "<time>" (point-min) (point-max)))
        (if (equal $num 1)
            (progn
              (goto-char (point-min))
              (search-forward "</time>")
              (insert ". Last updated: ")
              (insert (format "<time>%s</time>" (format-time-string "%Y-%m-%d")))
              (when (not (looking-at "\\.")) (insert ".")))
          (progn ;; if there are more than 1 “time” tag, delete the last one
            (let ($p3 $p4)
              (goto-char (point-max))
              (search-backward "</time>")
              (search-forward "</time>")
              (setq $p4 (point))
              (search-backward "<time>")
              (setq $p3 (point))
              (delete-region $p3 $p4 ))
            (insert (format "<time>%s</time>" (format-time-string "%Y-%m-%d")))
            (when (not (looking-at "\\.")) (insert "."))
            )))
      (let ; backup
          (($fname (buffer-file-name)))
        (if $fname
            (let (($backup-name
                   (concat $fname "~" (format-time-string "%Y-%m-%d_%H%M%S") "~")))
              (copy-file $fname $backup-name t)
              (message (concat "Backup saved at: " $backup-name)))))
      (save-buffer )
      (message "old date line: 「%s」" $bufferTextOrig)

      ;; (when ;; open in browser
      ;;     (string-equal system-type "gnu/linux")
      ;;   (let ( (process-connection-type nil))
      ;;     (start-process "" nil "setsid" "firefox" (concat "file://" buffer-file-name )))
      ;;   ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. eg with nautilus
      ;;   )

      ;;
      )))

(defun xahsite-update-page-tag ()
  "Update HTML page navigation tags.

The input is a text block or text selection.
Each line should a file name/path (can be relative path)
Update each file's page navigation tag.

Each file name is a file path without dir, and relative to current dir.
Sample text selection for input:

words.html
words-2.html
words-3.html
words-4.html
Version before 2012 or so"
  (interactive)
  (require 'sgml-mode)
  (let* (
         $p1 $p2
         ($fileList (split-string (buffer-substring-no-properties $p1 $p2) "\n" t))
         $pageNavStr )
    (delete-region $p1 $p2)
    ;; generate the page nav string
    (setq $pageNavStr
          (format "<nav class=\"page\">\n%s</nav>"
                  (let ($result $linkPath $fTitle ($i 0))
                    (while (< $i (length $fileList))
                      (setq $linkPath (elt $fileList $i))
                      (setq $fTitle (xah-html-get-html-file-title $linkPath))
                      (setq $result (concat $result "<a href=\"" $linkPath "\" title=\"" $fTitle "\">" (number-to-string (1+ $i)) "</a>\n"))
                      (setq $i (1+ $i)))
                    $result
                    )))
    ;; open each file, insert the page nav string
    (mapc
     (lambda (thisFile)
       (message "%s" thisFile)
       (find-file thisFile)
       (goto-char 1)
       (if (search-forward "<nav class=\"page\">" nil t)
           (let ($p3 $p4 )
             (search-backward "<")
             (setq $p3 (point))
             (sgml-skip-tag-forward 1)
             (setq $p4 (point))
             (delete-region $p3 $p4)
             (insert $pageNavStr))
         (progn
           (search-forward "<script><!--
google_ad_client")
           (progn
             (search-backward "<script>")
             (insert $pageNavStr "\n\n")))))
     $fileList)))

(defun xah-syntax-color-hex ()
  "Syntax color text of the form 「#ff1100」 and 「#abc」 in current buffer.
URL `http://ergoemacs.org/emacs/emacs_CSS_colors.html'
Version 2017-03-12"
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[[:xdigit:]]\\{3\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background
                      (let* (
                             (ms (match-string-no-properties 0))
                             (r (substring ms 1 2))
                             (g (substring ms 2 3))
                             (b (substring ms 3 4)))
                        (concat "#" r r g g b b))))))
     ("#[[:xdigit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-flush))

(defun xah-syntax-color-hsl ()
  "Syntax color CSS's HSL color spec eg 「hsl(0,90%,41%)」 in current buffer.
URL `http://ergoemacs.org/emacs/emacs_CSS_colors.html'
Version 2017-02-02"
  (interactive)
  (require 'color)
  (font-lock-add-keywords
   nil
   '(("hsl( *\\([0-9]\\{1,3\\}\\) *, *\\([0-9]\\{1,3\\}\\)% *, *\\([0-9]\\{1,3\\}\\)% *)"
      (0 (put-text-property
          (+ (match-beginning 0) 3)
          (match-end 0)
          'face
          (list
           :background
           (concat
            "#"
            (mapconcat
             'identity
             (mapcar
              (lambda (x) (format "%02x" (round (* x 255))))
              (color-hsl-to-rgb
               (/ (string-to-number (match-string-no-properties 1)) 360.0)
               (/ (string-to-number (match-string-no-properties 2)) 100.0)
               (/ (string-to-number (match-string-no-properties 3)) 100.0)))
             "" )) ;  "#00aa00"
           ))))))
  (font-lock-flush))

;; (concat "#" (mapconcat 'identity
;;                         (mapcar
;;                          (lambda (x) (format "%x" (round (* x 255))))
;;                          (color-hsl-to-rgb
;;                           (/ (string-to-number "0") 360.0)
;;                           (/ (string-to-number "90") 100.0)
;;                           (/ (string-to-number "50") 100.0)
;;                           ) )
;;                         "" ))

;; (format "%2x" (round (* (/ (string-to-number "49") 100.0) 255)))
;; (format "%02x" 10)

(defun xah-python-ref-linkify ()
  "Transform current line (a file path) into a link.
For example, this line:

~/web/xahlee_info/python_doc_2.7.6/library/stdtypes.html#mapping-types-dict

becomes

<span class=\"ref\"><a href=\"../python_doc_2.7.6/library/stdtypes.html#mapping-types-dict\">5. Built-in Types — Python v2.7.6 documentation #mapping-types-dict</a></span>

The path is relative to current file. The link text is the linked file's title, plus fragment url part, if any.

Requires a python script. See code."
  (interactive)
  (let (scriptName bds)
    (setq bds (bounds-of-thing-at-point 'filename))
    (save-excursion
      (setq scriptName (format "/usr/bin/python ~/git/xahscripts/emacs_pydoc_ref_linkify.py %s" (buffer-file-name)))
      (shell-command-on-region (car bds) (cdr bds) scriptName nil "REPLACE" nil t))))

;; (defun xah-move-image-file (@dir-name @file-name)
;;   "move image file at
;; ~/Downloads/xx.jpg
;; to current dir of subdir i
;; and rename file to current line's text.

;; if xx.jpg doesn't exit, try xx.png. The dirs to try are
;;  ~/Downloads/
;;  ~/Pictures/
;;  /tmp

;; Version 2016-10-08"
;;   (interactive "DMove xx img to dir:
;; sNew file name:")
;;   (let (
;;         $from-path
;;         $to-path )
;;     (setq $from-path
;;           (cond
;;            ((file-exists-p (expand-file-name "~/Downloads/xx.jpg"))
;;             (expand-file-name "~/Downloads/xx.jpg"))
;;            ((file-exists-p (expand-file-name "~/Downloads/xx.JPG"))
;;             (expand-file-name "~/Downloads/xx.JPG"))
;;            ((file-exists-p (expand-file-name "~/Downloads/xx.png"))
;;             (expand-file-name "~/Downloads/xx.png"))
;;            ((file-exists-p (expand-file-name "~/Pictures/xx.jpg"))
;;             (expand-file-name "~/Pictures/xx.jpg"))
;;            ((file-exists-p (expand-file-name "~/Pictures/xx.png"))
;;             (expand-file-name "~/Pictures/xx.png"))
;;            ((file-exists-p (expand-file-name "~/Pictures/xx.gif"))
;;             (expand-file-name "~/Pictures/gif.png"))
;;            ((file-exists-p (expand-file-name "~/Downloads/xx.gif"))
;;             (expand-file-name "~/Downloads/xx.gif"))

;;            ((file-exists-p "/tmp/xx.jpg")
;;             "/tmp/xx.jpg")
;;            ((file-exists-p "/tmp/xx.png")
;;             "/tmp/xx.png")
;;            (t (error "no xx.jpg or xx.png at downloads dir nor pictures dir nor /tmp dir"))))
;;     (setq $to-path (concat
;;                     (file-name-as-directory @dir-name )
;;                     @file-name "."
;;                     (downcase (file-name-extension $from-path ))))
;;     (if (file-exists-p $to-path)
;;         (message "move to path exist: %s" $to-path)
;;       (progn
;;         (rename-file $from-path $to-path)
;;         (find-file $to-path )
;;         (message "move to path: %s" $to-path)))))

(defun xah-move-image-file ( @toDirName  )
  "Move image file to another dir.

from directories checked are:
~/Downloads/
~/Pictures/
~/Desktop/
~/
/tmp/

The first file whose name starts with ee, or contain “Screen Shot”, will be moved.

The destination dir is asked by a prompt.

the new file name is with ee removed.
Any space in filename is replaced by the low line char “_”.
If the file name ends in png, 「optipng filename」 is called.

Version 2018-08-10"
  (interactive
   (list
    (read-directory-name "Move to dir:" )))
  (let (
        $fromPath
        $newName
        $ext
        $toPath
        ($dirs '( "~/Downloads/" "~/Pictures/" "~/Desktop/" "~/" "/tmp" ))
        ($randomHex (format  (concat "%05x" ) (random (1- (expt 16 5))))))
    (setq $fromPath
          (catch 'TAG
            (dolist (x $dirs )
              (let ((mm (directory-files x t "^ee\\|Screen Shot" t)))
                (if mm
                    (progn
                      (throw 'TAG (car mm)))
                  nil
                  )))))
    (when (not $fromPath)
      (error "no file name starts with ee nor contain “Screen Shot” at dirs %s" $dirs))

    (setq $ext (file-name-extension $fromPath ))
    (setq $newName (file-name-nondirectory (file-name-sans-extension $fromPath)))
    (setq $newName
          (replace-regexp-in-string
           "Screen Shot \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\) at [0-9]+.[0-9]\\{2\\}.[0-9]\\{2\\} \\(AM\\|PM\\)"
           "screenshot_\\1"
           $newName ))
    ;; Screen Shot 2018-07-25 at 2.46.36 AM.png
    (setq $newName (read-string "file name:" $newName nil $newName ))
    (setq $newName
          (concat (replace-regexp-in-string " " "_" $newName)
                  "_"
                  $randomHex
                  "."
                  ))
    (setq $toPath (concat (file-name-as-directory @toDirName ) $newName $ext))

    (when (string-equal $ext "jpg-large")
      (setq $toPath (concat (file-name-sans-extension $toPath) ".jpg")))
    (when (string-equal $ext "jpg_large")
      (setq $toPath (concat (file-name-sans-extension $toPath) ".jpg")))
    (when (string-equal $ext "jpeg")
      (setq $toPath (concat (file-name-sans-extension $toPath) ".jpg")))
    (message "from path is 「%s」\n to path is 「%s」 " $fromPath $toPath)
    (if (file-exists-p $toPath)
        (error "move to path exist: %s" $toPath)
      (progn
        (rename-file $fromPath $toPath)
        (when (string-equal (file-name-extension $toPath ) "png")
          (when (eq (shell-command "which optipng") 0)
            (message "optimizing with optipng")
            (shell-command (concat "optipng " $toPath))))
        (when (string-equal major-mode "dired-mode")
          (revert-buffer))
        (if (string-equal major-mode "xah-html-mode")
            (progn
              (kill-new $toPath)
              (insert "\n\n")
              (insert $toPath)
              (insert "\n\n")
              (backward-word )
              (xah-html-any-linkify))
          (progn
            (insert "\n\n")
            (insert $toPath)
            (insert "\n\n")))))))

(defun xah-youtube-get-image ()
  "
given a youtube url, get its image.
the url is taken from current line
tttttttttttttttttttttttttttttttt
todo
2016-07-01"
  (interactive)
  (let* (
         (p1 (line-beginning-position))
         (p2 (line-end-position))
         (lineStr (buffer-substring-no-properties p1 p2))
         id
         shellCmd
         (fileName (read-file-name "name:")))
    (setq id (replace-regexp-in-string "https://www.youtube.com/watch\\?v=" "" lineStr "FIXEDCASE" "LITERAL" ))
    (setq id (replace-regexp-in-string "http://www.youtube.com/watch\\?v=" "" id "FIXEDCASE" "LITERAL" ))

    (setq shellCmd
          (concat "wget " "https://i.ytimg.com/vi/" id "/maxresdefault.jpg"
                  " -O "
                  fileName
                  ".jpg "
                  ))

    (shell-command shellCmd)

    ;; (replace-regexp-in-string "https://www.youtube.com/watch\\?v=" "" "https://www.youtube.com/watch?v=aa8jTf7Xg3E" "FIXEDCASE" "LITERAL" )

    ;; https://www.youtube.com/watch?v=aa8jTf7Xg3E
    ;; https://i.ytimg.com/vi/aa8jTf7Xg3E/maxresdefault.jpg

    ;; https://www.youtube.com/watch?v=zdD_QygwRuY

    ))




(defun xah-html-insert-date-section ()
  "Insert a section tag with date tag inside.
Version 2018-09-03"
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (insert (format "\n\n<section>\n\n<div class=\"date-xl\"><time>%s</time></div>\n\nx\n\n</section>\n\n\n" (format-time-string "%Y-%m-%d")))
  (search-backward "x" )
  (delete-char 1))

(defun xah-html-insert-date-tag ()
  "Insert a date tag."
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end) )
    )
  (insert (concat "<div class=\"date-xl\"><time>" (format-time-string "%Y-%m-%d") "</time></div>\n\n\n" ))
  (backward-char 1)
  )



(defun xah-html-insert-midi ()
  "Insert a midi audio markup."
  (interactive)
  (insert "<div class=\"obj\">
<object type=\"application/x-midi\" data=\"../../ClassicalMusic_dir/midi/liszt/Transcendetal_Etudes_dir/12_chasse.mid\" width=\"300\" height=\"20\">
<param name=\"src\" value=\"../../ClassicalMusic_dir/midi/liszt/Transcendetal_Etudes_dir/12_chasse.mid\">
<param name=\"autoStart\" value=\"0\">
</object>
<p class=\"cpt\">Liszt's transcendental etude #12.
<a href=\"../ClassicalMusic_dir/midi/liszt/Transcendetal_Etudes_dir/12_chasse.mid\">midi file ♪</a>.</p>
</div>
")
  )

