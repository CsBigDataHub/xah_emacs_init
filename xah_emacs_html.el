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

Version 2018-12-07"
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
            (search-backward "<time>"))))
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
~/Documents/
~/
/tmp/

The first file whose name starts with ee or tt or contain “Screenshot”, “Screen Shot” , will be moved.

The destination dir and new file name is asked by a prompt. A random string attached (as id) is added to file name, and any uppercase extension name is lowercased. Space in filename is replaced by the low line char “_”.
If the file name ends in png, “optipng” is called on it.

URL `http://ergoemacs.org/emacs/move_image_file.html'
Version 2019-05-06"
  (interactive (list (ido-read-directory-name "Move img to dir:" )))
  (let (
        $fromPath
        $newName1
        $ext
        $toPath
        ($dirs '( "~/Downloads/" "~/Pictures/" "~/Desktop/" "~/Documents/" "~/" "/tmp" ))
        ($randStr
         (let* (($charset "bcdfghjkmnpqrstvwxyz23456789")
                ($len (length $charset))
                ($randlist nil))
           (dotimes (_ 5)
             (push (char-to-string (elt $charset (random $len)))  $randlist))
           (mapconcat 'identity $randlist ""))))
    (setq $fromPath
          (catch 'TAG
            (dolist (x $dirs )
              (let ((mm (directory-files x t "^ee\\|^tt\\|Screen Shot\\|Screenshot\\|[0-9A-Za-z]\\{11\\}\._[A-Z]\\{2\\}[0-9]\\{4\\}_\.jpg" t)))
                (if mm
                    (progn
                      (throw 'TAG (car mm)))
                  nil
                  )))))
    (when (not $fromPath)
      (error "no file name starts with ee nor contain “Screen Shot” at dirs %s" $dirs))
    (setq $ext
          (let (($x (file-name-extension $fromPath )))
            (if $x
                (downcase $x)
              ""
              )))
    (setq $newName1 (file-name-nondirectory (file-name-sans-extension $fromPath)))
    (setq $newName1
          (replace-regexp-in-string
           "Screen Shot \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\) at [0-9]+.[0-9]\\{2\\}.[0-9]\\{2\\} \\(AM\\|PM\\)"
           "screenshot_\\1"
           $newName1 ))
    ;; Screen Shot 2018-07-25 at 2.46.36 AM.png
    (setq $newName1 (read-string "file name:" $newName1 nil $newName1 ))
    (setq $newName1
          (concat (replace-regexp-in-string " " "_" $newName1)
                  "_"
                  $randStr
                  "."
                  ))
    (setq $toPath (concat (file-name-as-directory @toDirName ) $newName1 $ext))

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
            (shell-command (concat "optipng " $toPath " &"))))
        (when (string-equal major-mode "dired-mode")
          (revert-buffer))
        (if (string-equal major-mode "xah-html-mode")
            (progn
              (kill-new $toPath)
              (insert "\n\n")
              (insert $toPath)
              (insert "\n\n")
              (backward-word )

              (xah-html-any-linkify)

              ;; (let ($p1 $p2 $altStr)
              ;;   (setq $altStr (xah-html-image-linkify))
              ;;   (search-backward "<img ")
              ;;   (insert "<figure>\n")
              ;;   (search-forward ">")
              ;;   (insert "\n<figcaption>\n")
              ;;   (insert $altStr "\n</figcaption>\n</figure>\n\n")
              ;;   ;;
              ;;   )
              )
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
Version 2019-05-10"
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (insert (format "

<section>

<div class=\"date-xl\"><time>%s</time></div>

<h3></h3>

x

</section>

" (format-time-string "%Y-%m-%d")))
  (search-backward "</h3>" ))

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

(defun xah-copy-html-by-link ()
  "clone a html page, see:

current buffer is a html file,
it contains 2 lines, each is a href link.
place cursor on the link of first line.
This command will clone the file, from the 1st link's content, into the second link.
The 2nd link file normally do not exit. it'll be created.

Version 2018-12-24"
  (interactive)
  (let ( p1 p2 fPath1 fPath2 doitp
            bds p3 p4 buf
            title)
    (progn
      (search-backward " href=")
      (forward-char 7)
      (setq p1 (point))
      (search-forward "\"" (line-end-position))
      (backward-char 1)
      (setq p2 (point))
      (setq fPath1 (expand-file-name (buffer-substring-no-properties p1 p2))))
    (progn
      (search-forward "href=\"")
      (setq p1 (point))
      (search-forward "\"" (line-end-position))
      (backward-char 1)
      (setq p2 (point))
      (setq fPath2 (expand-file-name (buffer-substring-no-properties p1 p2))))
    (if (file-exists-p fPath2)
        (progn
          (setq doitp (yes-or-no-p (format "file 2 「%s」 exist. continue and replace?" fPath2))))
      (setq doitp t))
    (when doitp
      (setq buf (find-file fPath2))
      (erase-buffer)
      (insert-file-contents fPath1 )
      (save-buffer buf)
      (kill-buffer buf))

    ;; (setq bds (xah-get-bounds-of-thing [">" "<"]))
    ;; (setq p3 (aref bds 0))
    ;; (setq p4 (aref bds 1))
    ;; (setq title (buffer-substring-no-properties p3 p4))

    ;; (xah-get-thing-at-point [">" "<"])

    ;;
    ))

(defun xah-remove-wikipedia-link ()
  "Delet wikipedia link at cursor position
Version 2019-04-07"
  (interactive)
  (require 'xah-html-mode)
  (let ( $p2
         $deletedText
         )
    (when (search-forward "</a>")
      (progn
        (setq $p2 (point))
        (re-search-backward "http.?://..\\.wikipedia.org/wiki/")
        (re-search-backward "<a .*href=")
        (setq $deletedText (buffer-substring (point) $p2))
        (xah-html-remove-html-tags (point) $p2)
        (message "%s" $deletedText)
        $deletedText
        ))))

(defun xah-remove-all-wikipedia-link ()
  "Delete all wikipedia links in a html file, except image links etc.
Version 2018-06-03"
  (interactive)
  (let ($p1
        $p2 $deletedText
        ($resultList '()))
    (goto-char (point-min))
    (while (re-search-forward "<a href=\"https?://...wikipedia.org/wiki/" nil t)
      (progn
        (search-backward "<a href" )
        (setq $p1 (point))
        (search-forward ">")
        (setq $p2 (point))

        (setq $deletedText (buffer-substring-no-properties $p1 $p2))
        (push $deletedText $resultList)
        (delete-region $p1 $p2)

        (search-forward "</a>")
        (setq $p2 (point))
        (search-backward "</a>")
        (setq $p1 (point))
        (delete-region $p1 $p2)))

    (goto-char (point-min))
    (while (re-search-forward "<a class=\"wikipedia-69128\" href" nil t)
      (progn
        (search-backward "<a class=\"wikipedia-69128\" href" )
        (setq $p1 (point))
        (search-forward ">")
        (setq $p2 (point))

        (setq $deletedText (buffer-substring-no-properties $p1 $p2))
        (push $deletedText $resultList)
        (delete-region $p1 $p2)

        (search-forward "</a>")
        (setq $p2 (point))
        (search-backward "</a>")
        (setq $p1 (point))
        (delete-region $p1 $p2)))
    (terpri )
    (mapc (lambda (x) (princ x) (terpri )) $resultList)))

(defun xah-new-page ()
  "Make a new blog page.
Version 2019-04-04"
  (interactive)
  (let* (
         ($path-map
          '(
            ("/Users/xah/web/xaharts_org/arts/" . "Hunger_Games_eyelash.html")
            ("/Users/xah/web/xahmusic_org/music/" . "Disney_Frozen__let_it_go.html")
            ("/Users/xah/web/xahlee_org/Periodic_dosage_dir/" . "20030907_la_gangs.html")
            ("/Users/xah/web/xahlee_org/sex/" . "Korean_gymnast_Son_Yeon_jae.html")
            ("/Users/xah/web/xahlee_info/comp/" . "artificial_neural_network.html")
            ("/Users/xah/web/xahlee_info/math/" . "math_books.html")
            ("/Users/xah/web/xahlee_info/kbd/" . "3m_ergonomic_mouse.html")
            ("/Users/xah/web/xaharts_org/dinju/" . "Petronas_towers.html")
            ("/Users/xah/web/xaharts_org/movie/" . "brazil_movie.html")
            ("/Users/xah/web/xahporn_org/porn/" . "Renee_Pornero.html")
            ("/Users/xah/web/xahlee_info/w/" . "spam_farm_2018.html")
            ("/Users/xah/web/ergoemacs_org/emacs/" . "ErgoEmacs_logo.html")
            ("/Users/xah/web/ergoemacs_org/misc/" . "Daniel_Weinreb_died.html")
            ("/Users/xah/web/xahlee_info/golang/" . "golang_run.html")
            ("/Users/xah/web/wordyenglish_com/lit/" . "china_dollar_bill_multilingual.html")
            ("/Users/xah/web/wordyenglish_com/chinese/" . "Zhuangzi.html")
            ("/Users/xah/web/xahlee_info/talk_show/" . "xah_talk_show_2019-03-05_unicode.html")
            ;;

            ))

         ($cur-fpath (buffer-file-name))
         ($dir-path (file-name-directory $cur-fpath))

         ($temp-fname (cdr (assoc $dir-path $path-map)))

         ($temp-fpath (concat $dir-path $temp-fname))
         (p1 (line-beginning-position))
         (p2 (line-end-position))
         (title1 (buffer-substring-no-properties p1 p2))
         (fnameBase (downcase (replace-regexp-in-string " +" "_" title1 )))
         (fpath (format "%s%s.html" (file-name-directory $temp-fpath) fnameBase))
         p3
         )

    (if (file-exists-p fpath)
        (message "file exist: %s" fpath)
      (progn

        (find-file fpath)
        (insert-file-contents $temp-fpath )

        (progn
          (goto-char (point-min))
          (search-forward "<title>" )
          (insert title1)
          (setq p3 (point))
          (skip-chars-forward "^<")
          (delete-region p3 (point))

          (search-forward "<h1>" )
          (insert title1)
          (setq p3 (point))
          (skip-chars-forward "^<")
          (delete-region p3 (point))
          (search-forward "</h1>" )

          (when (search-forward "<div class=\"byline\">By Xah Lee. Date: <time>" nil t)
            (insert (format-time-string "%Y-%m-%d"))
            (setq p3 (point))
            (search-forward "</div>" )
            (delete-region p3 (point))
            (insert "</time>.</div>"))

          (setq p3 (point))

          ;; porn bottom_ad_42482
          ;; art ads_96352
          ;; comp ads-bottom-65900

          (when
              (search-forward "ads-bottom-65900" nil t)
            (search-backward "<")
            (delete-region p3 (point))
            (insert "\n\n\n\n")
            (backward-char 2))

          (save-buffer )
          (kill-buffer )

          ;;
          ))
      (delete-region p1 p2)
      (insert fpath)

      (xah-all-linkify)
      (search-backward "\"")
      ;; (beginning-of-line)
      ;; (insert "<p>")
      ;; (end-of-line )
      ;; (insert "</p>")

      )

    ;;
    ))
