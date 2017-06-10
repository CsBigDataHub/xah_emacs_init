;;-*- coding: utf-8 -*-
;; Xah Lee's personal functions for transforming cursor location's text into HTML links.
;; 2007-10, 2011-05-29
;; ∑ http://xahlee.org/


(require 'url-util)



(defun xahsite-html-image-linkify ( &optional *begin *end)
  "Replace a image file's path under cursor with a HTML img tag.
If there's a text selection, use that as path.
For example,
 i/cat.png
becames
 <img src=\"i/cat.png\" alt=\"cat\" width=\"707\" height=\"517\" />

Image path can be a URL or local file.  Supported file suffix are {.gif, .png, .svg}. If path starts with “http”, then no “width” and “height” attribute will be added.
URL `http://ergoemacs.org/emacs/elisp_image_tag.html'
Version 2015-05-12"
  (interactive)
  (let ( -p0 -p1 -p2 -inputPath -currentDir -fullPath -altText )
    (progn ; sets -p1 -p2
      (if *begin
          (progn (setq -p1 *begin) (setq -p2 *end))
        (if (use-region-p)
            (progn (setq -p1 (region-beginning)) (setq -p2 (region-end)))
          (save-excursion
            (setq -p0 (point))
            ;; chars that are likely to be delimiters of full path, e.g. space, tabs, brakets.
            (skip-chars-backward "^  \"\t\n'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\`")
            (setq -p1 (point))
            (goto-char -p0)
            (skip-chars-forward "^  \"\t\n'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\'")
            (setq -p2 (point))))))

    (progn
      (setq -inputPath (buffer-substring-no-properties -p1 -p2))
      (setq -currentDir (file-name-directory (or (buffer-file-name) default-directory )))
      (setq -fullPath (expand-file-name (xah-local-url-to-file-path -inputPath) -currentDir ))
      (setq -altText (replace-regexp-in-string "-s$" "" (replace-regexp-in-string "_" " " (file-name-sans-extension (file-name-nondirectory -fullPath)) t t))))

    (if (xahsite-is-link-to-xahsite-p (file-relative-name -fullPath (or (buffer-file-name) default-directory)))
        (progn
          (if (file-exists-p -fullPath)
              (let (-wh -w -h -whStr)
                (setq -wh
                      (cond
                       ((string-match "\.svg$" -fullPath) (xah-get-image-dimensions -fullPath))
                       (t (xah-get-image-dimensions -fullPath))))
                (setq -w (number-to-string (elt -wh 0)))
                (setq -h (number-to-string (elt -wh 1)))
                (setq -whStr
                      (if (string-match "\.svg$" -fullPath)
                          ""
                        (format "width=\"%s\" height=\"%s\"" -w -h)))
                (delete-region -p1 -p2)
                (insert
                 (format "<img src=\"%s\" alt=\"%s\" %s />"
                         (xahsite-filepath-to-href-value -fullPath (or (buffer-file-name) default-directory))
                         -altText -whStr )))
            (error "File does not exist 「%s」" -fullPath )))
      (progn
        (delete-region -p1 -p2)
        (insert "<img src=\"" -fullPath "\" alt=\"" -altText "\">")))))

(defun xah-image-file-to-html-figure-tag ()
  "Replace a image file's path under cursor with a HTML img tag,
and wrap it with “figure” and “figcaption” tags.

Example, if cursor is on the word “i/cat.png”, then it will became

<figure>
<img src=\"cat.png\" alt=\"cat\" width=\"707\" height=\"517\" />
<figcaption>▮</figcaption>
</figure>

If there's a text selection, use that as image path.

This function calls `xah-html-image-linkify'.
Version 2017-06-09"
  (interactive)
  (let (-p1 -p2 -alt-str)
    (setq -alt-str (xah-html-image-linkify))

    ;; (search-backward "alt=\"")
    ;; (forward-char 5)

    ;; (progn
    ;;   (setq -p1 (point))
    ;;   (search-forward "\"")
    ;;   (setq -p2 (- (point) 1) )
    ;;   (setq -alt-str (buffer-substring -p1 -p2)))

    (search-backward "<img ")
    (insert "<figure>\n")
    (search-forward ">")
    (insert "\n<figcaption>\n")
    (insert -alt-str "\n</figcaption>\n</figure>\n")

    ;; (search-backward "</figcaption>")
    ;; (backward-char)

))

(defun xah-html-full-size-img-linkify (&optional *begin *end)
  "Make image file path at cursor point into a img link.

Example:
i/goddess.jpg
becomes
<a class=\"big-i\" href=\"i/goddess.jpg\" title=\"622×800\" target=\"_blank\">❐</a>

If there's a text selection, use that region as file name."
  (interactive)
  (let
      (-p0 -p1 -p2 -inputStr -imgPath -dimension -width -height -resultStr)
    (progn ; sets -p1 -p2
      (if *begin
          (progn
            (setq -p1 *begin)
            (setq -p2 *end))
        (if (use-region-p)
            (progn
              (setq -p1 (region-beginning))
              (setq -p2 (region-end)))
          (save-excursion
            (setq -p0 (point))
            ;; chars that are likely to be delimiters of full path, e.g. space, tabs, brakets.
            (skip-chars-backward "^  \"\t\n'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\`")
            (setq -p1 (point))
            (goto-char -p0)
            (skip-chars-forward "^  \"\t\n'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\'")
            (setq -p2 (point))))))

    (setq -inputStr (buffer-substring-no-properties -p1 -p2))
    (setq -imgPath (xah-local-url-to-file-path -inputStr))
    (setq -dimension (xah-get-image-dimensions-imk -imgPath))
    (setq -width (number-to-string (elt -dimension 0)))
    (setq -height (number-to-string (elt -dimension 1)))
    (setq -resultStr
          (concat "<a class=\"big-i\" href=\"" (file-relative-name -imgPath) "\" target=\"_blank\">" -width "×" -height "</a>"))

    (delete-region -p1 -p2)
    (insert -resultStr)))

(defun xah-blogger-linkify ()
  "Make URL at cursor point into a HTML link.

Example: http://xahlee.blogspot.com/2010/03/some.html
becomes

<div class=\"blgcmt\"><a href=\"http://xahlee.blogspot.com/2010/03/some.html\">✍</a></div>"
  (interactive)
  (let* ((-bds (bounds-of-thing-at-point 'url))
         (p7 (car -bds))
         (p8 (cdr -bds))
         (-url (buffer-substring-no-properties p7 p8)))
    (delete-region p7 p8)
    (insert (concat "<div class=\"blgcmt\"><a href=\"" (url-encode-url -url) "\">✍</a></div>"))))

(defun youporn-search-linkify ()
  "Make the current line into a YouPorn.com link.
For example, if the cursor is on the line:
anal
Then it'll become
\(YouPorn video: <a href=\"http://www.youporn.com/search?query=anal\">anal</a>\)"
  (interactive)
  (let (-p1 -p2 -word -url)

    (if (use-region-p)
        (progn (setq -p1 (region-beginning))
               (setq -p2 (region-end)))
      (progn (setq -p1 (line-beginning-position))
             (setq -p2 (line-end-position))))

    (setq -word (buffer-substring-no-properties -p1 -p2) )

    (setq -url (concat "http://www.youporn.com/search?query=" -word) )
    (setq -url (replace-regexp-in-string " " "+" -url ) )
    (delete-region -p1 -p2)
    (insert "(YouPorn video: <a href=\"" -url "\">" -word "</a>)\n")))

(defun xah-youtube-search-linkify ()
  "Make the current line into a YouTube link.
If there's a text selection, use that.
For example, if the cursor is on the line:
David Bowie
Then it'll become
<a class=\"utb\" href=\"http://youtube.com/results?search_query=David+Bowie&amp;search=Search\">David Bowie</a>

Warning: the line must end in a line return char else the result is wrong.

Note: old version returns this form:
<span class=\"utb\"><a href=\"http://youtube.com/results?search_query=David+Bowie&amp;search=Search\">David Bowie</a></span>
"
  (interactive)
  (let (-p1 -p2 -word -url)
    (if (use-region-p)
        (progn (setq -p1 (region-beginning))
               (setq -p2 (region-end)))
      (progn (setq -p1 (line-beginning-position))
             (setq -p2 (line-end-position))))

    (setq -word (buffer-substring-no-properties -p1 -p2))

    (setq -url (concat "http://youtube.com/results?search_query=" -word "&amp;search=Search"))
    (setq -url (replace-regexp-in-string " " "+" -url ))
    (setq -url (replace-regexp-in-string "," "%2C" -url ))
    (delete-region -p1 -p2)
    (insert "<a class=\"utb\" href=\"" -url "\">" -word "</a>")))

(defun xah-video-search-string (*searchString)
  "Return a Google video search string URL of SEARCHSTRING.

Example:
 「(xah-video-search-string \"White Rabbit, Jefferson Airplane\")」 ⇒
 「http://www.google.com/search?tbs=vid%3A1&q=White+Rabbit%2C+Jefferson+Airplane」

This command is called by `xah-video-search-linkify'."
  (let (strEncoded)
    (setq strEncoded *searchString )
    (setq strEncoded (replace-regexp-in-string " " "+" strEncoded ) )
    (setq strEncoded (url-encode-url strEncoded ) )
    (concat "http://www.google.com/search?tbs=vid%3A1&q=" strEncoded)
    ))

(defun xah-video-search-linkify ()
  "Make the current line into a Google video search link.
If there's a text selection, use that.
For example, if the cursor is on the line:

White Rabbit, Jefferson Airplane

Then it'll become

<a class=\"google-video-search-36645\" href=\"http://www.google.com/search?tbs=vid%3A1&q=White+Rabbit%2C+Jefferson+Airplane\">White Rabbit, Jefferson Airplane</a>

Warning: the line must end in a line return char else the result is wrong.

This command calls `xah-video-search-string'"
  (interactive)
  (let (-p1 -p2 -word -url)
    (if (use-region-p)
        (progn (setq -p1 (region-beginning))
               (setq -p2 (region-end)))
      (progn (setq -p1 (line-beginning-position))
             (setq -p2 (line-end-position))))
    (setq -word (buffer-substring-no-properties -p1 -p2))
    (setq -url (xah-video-search-string -word))
    (delete-region -p1 -p2)
    (insert "<a class=\"google-video-search-36645\" href=\"" -url "\">" -word "</a>")))

(defun google-search-linkify ()
  "Make the current line into a Google search link.
For example, if the cursor is on the line:

emacs lisp

Then it'll become

<p>Google search: <a href=\"http://www.google.com/search?q=emacs+lisp\">emacs lisp</a>.</p>

Warning: the line must end in a line return char else the result is wrong."
  (interactive)
  (let (-p1 -p2 -word -url)
    (if (use-region-p)
        (progn (setq -p1 (region-beginning))
               (setq -p2 (region-end)))
      (progn (setq -p1 (line-beginning-position))
             (setq -p2 (line-end-position))))
    (setq -word (buffer-substring-no-properties -p1 -p2))
    (setq -url (concat "http://www.google.com/search?q=" -word))
    (setq -url (replace-regexp-in-string " " "+" -url ))
    (delete-region -p1 -p2)
    (insert "<p>Google search: <a href=\"" -url "\">" -word "</a>.</p>\n")))


;; some custom HTML markup and functions for working with HTML

(defun xah-nks-linkify ()
  "Make the current word into into a link to Wolfram Science site.
For Example, if you cursor is on the word 「p123」, then
it becomes
 「<a href=\"http://www.wolframscience.com/nksonline/page-123\">p123</a>」
Version 2015-05-15"
  (interactive)
  (let* ((-bounds (bounds-of-thing-at-point 'word))
         (-p1 (car -bounds))
         (-p2 (cdr -bounds))
         (-inputStr (buffer-substring-no-properties -p1 -p2))
         (-pageNum (substring -inputStr 1)))
    (delete-region -p1 -p2)
    (insert
     (concat
      "<a href=\"http://www.wolframscience.com/nksonline/page-"
      -pageNum "\">p" -pageNum "</a>"))))


;; more specific to Xah Lee

(defun xah-amazon-search-linkify-url (*sString *productCat *assid)
  "Returns a URL of amazon search based on search string and product category.
*sString is the search string. e.g. “deep throat”
*productCat is a short code for amazon's product category.
See `amazon-search-linkify' for the possible code string.
Sample call:
 (xah-amazon-search-linkify-url \"debbie does dollas\" \"dvd\" \"xahh-20\")"
  (interactive)
  (let (sStrPercent)
    (setq sStrPercent *sString)
    (setq sStrPercent (replace-regexp-in-string " " "%20" sStrPercent) )
    (setq sStrPercent (replace-regexp-in-string "," "%2c" sStrPercent) )

    (concat
     "<a class=\"amzs\" href=\"http://www.amazon.com/gp/search?ie=UTF8&amp;keywords="
     sStrPercent
     "&amp;tag="
     *assid
     "&amp;index="
     *productCat
     "&amp;linkCode=ur2&amp;camp=1789&amp;creative=9325\">"
     *sString
     "</a>"
     ) ) )

(defun amazon-search-linkify ()
  "Make the current line or text-selection into a Amazon product search link.
The current line must have this format:
search word;code
The “search word” is any letter and space.
the “code” is one of the following:
a = “blended” = all categories.
d = “dvd” = movies and tv.
b = “books”
c = “classical” = classical music
p = “pc-hardware”
e = “electronics”
m = “music”
s = “software”
There are other amazon categories, but not supported by this function."
  (interactive)
  (let (-p1 -p2 mainText tmplist sstr pcato pcc)
    (if (use-region-p)
        (setq -p1 (region-beginning) -p2 (region-end))
      (progn
        (setq -p1 (line-beginning-position) )
        (setq -p2 (line-end-position) )
        ))
    ;; get the text
    (setq mainText (buffer-substring-no-properties -p1 -p2) )
    (setq tmplist (split-string mainText ";") )
    (setq sstr (nth 0 tmplist ) )
    (setq pcato (nth 1 tmplist ) )
    (message "%s , %s" sstr pcato)

    (cond
     ((string= pcato "a") (setq pcc "blended"))
     ((string= pcato "d") (setq pcc "dvd"))
     ((string= pcato "b") (setq pcc "books"))
     ((string= pcato "c") (setq pcc "classical"))
     ((string= pcato "p") (setq pcc "pc-hardware"))
     ((string= pcato "e") (setq pcc "electronics"))
     ((string= pcato "m") (setq pcc "music"))
     ((string= pcato "s") (setq pcc "software"))
     (t (error "Code does not match"))
     )

    (delete-region -p1 -p2)
    (insert  (xah-amazon-search-linkify-url sstr pcc "xahh-20"))
    ))

(defun xah-amazon-linkify ()
  "Make the current amazon URL or selection into a link.

Examples of amazon product URL formats
http://www.amazon.com/Cyborg-R-T-Gaming-Mouse/dp/B003CP0BHM/ref=pd_sim_e_1
http://www.amazon.com/gp/product/B003CP0BHM
http://www.amazon.com/exec/obidos/ASIN/B003CP0BHM/xahh-20
http://www.amazon.com/exec/obidos/tg/detail/-/B003CP0BHM/
http://www.amazon.com/dp/B003CP0BHM?tag=xahhome-20
http://amzn.to/1F5M1hA
https://alexa.design/2okfMcj

Example output:
<a class=\"amz\" href=\"http://www.amazon.com/dp/B003CP0BHM/?tag=xahh-20\" title=\"Cyborg R T Gaming Mouse\">amazon</a>

For info about the Amazon ID in URL, see: URL `http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number'
URL `http://ergoemacs.org/emacs/elisp_amazon-linkify.html'
Version 2017-04-10"
  (interactive)
  (let ((-bds (bounds-of-thing-at-point 'url))
        -p1 -p2 -inputText -asin -productName )
    (if (use-region-p)
        (progn (setq -p1 (region-beginning)) (setq -p2 (region-end)))
      (progn (setq -p1 (car -bds)) (setq -p2 (cdr -bds))))
    (setq -inputText (buffer-substring-no-properties -p1 -p2))
    (if (or (string-match "//amzn.to/" -inputText)
            (string-match "//alexa.design/" -inputText))
        (progn (delete-region -p1 -p2)
               (insert (format "<a class=\"amz_search\" href=\"%s\">amazon</a>" -inputText)))
      (progn
        (setq -asin
              (cond
               ((string-match "/dp/\\([[:alnum:]]\\{10\\}\\)/?" -inputText) (match-string 1 -inputText))
               ((string-match "/dp/\\([[:alnum:]]\\{10\\}\\)\\?tag=" -inputText) (match-string 1 -inputText))
               ((string-match "/gp/product/\\([[:alnum:]]\\{10\\}\\)" -inputText) (match-string 1 -inputText))
               ((string-match "/ASIN/\\([[:alnum:]]\\{10\\}\\)" -inputText) (match-string 1 -inputText))
               ((string-match "/tg/detail/-/\\([[:alnum:]]\\{10\\}\\)/" -inputText) (match-string 1 -inputText))
               ((and
                 (equal 10 (length -inputText ))
                 (string-match "\\`\\([[:alnum:]]\\{10\\}\\)\\'" -inputText))
                -inputText)
               (t (error "no amazon ASIN found"))))

        (setq
         -productName
         (replace-regexp-in-string
          "-" " "
          (if (string-match "amazon\.com/\\([^/]+?\\)/dp/" -inputText)
              (progn (match-string 1 -inputText))
            (progn
              (message "no product name found" ))
            ""
            )))

        (delete-region -p1 -p2)
        (insert
         "<a class=\"amz\" href=\"http://www.amazon.com/dp/"
         -asin "/?tag=xahh-20\" title=\"" -productName "\">Buy at amazon</a>")
        (search-backward "\">")))))

;; (defun local-linkify ()
;; "Make the path under cursor into a local link.\n
;; For Example, if you cursor is on the text “../emacs/emacs.html”,
;; then it'll become:
;; “<a href=\"../emacs/emacs.html\">Xah's Emacs Tutorial</a>”.
;; The link text is pulled from the file's <h1> tag.

;; If a region is active, use the region as file path."
;;  (interactive)
;;  (let (-path bounds tempBuff x1 x2 titleText -resultStr)
;;    (setq -path
;;          (if (use-region-p)
;;              (buffer-substring-no-properties (region-beginning) (region-end))
;;            (thing-at-point 'filename)
;;            ))
;;    (setq bounds (bounds-of-thing-at-point 'filename))

;;    (setq tempBuff (generate-new-buffer-name " temp"))

;;    (when (file-exists-p -path)
;;        (progn
;;          (save-current-buffer
;;            (message -path)
;;            (set-buffer (get-buffer-create tempBuff))
;;            (goto-char (point-min))
;;            (insert-file-contents -path nil nil nil t)
;;            (setq x1 (search-forward "<title>"))
;;            (search-forward "</title>")
;;            (setq x2 (search-backward "<"))
;;            (setq titleText (buffer-substring-no-properties x1 x2))
;;            (kill-buffer tempBuff))

;;          (setq -resultStr (concat "<a href=\"" -path "\">" titleText "</a>"))
;;          (save-excursion
;;            (delete-region (car bounds) (cdr bounds))
;;            (insert -resultStr))))
;;    ))

(defun xah-file-linkify (&optional *begin *end)
  "Make the path under cursor into a HTML link for xah site.

For Example, if you cursor is on the text “../emacs/emacs.html”,
then it'll become:
“<a href=\"../emacs/emacs.html\">Xah's Emacs Tutorial</a>”.
The link text is pulled from the file's <title> tag.

If there is text selection, use it as file path.

The file path can also be a full path or URL, See: `xahsite-web-path-to-filepath'.
Version 2016-07-07"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (save-excursion
       (let (p0 p1 p2)
         (setq p0 (point))
         ;; chars that are likely to be delimiters of full path, e.g. space, tabs, brakets.
         (skip-chars-backward "^  \"\t\n'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\`")
         (setq p1 (point))
         (goto-char p0)
         (skip-chars-forward "^  \"\t\n'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\'")
         (setq p2 (point))
         (list p1 p2)))))
  (let* (
         (-inputStr (buffer-substring-no-properties *begin *end))
         (-inputStParts (split-uri-hashmark -inputStr))
         (pt1 (aref -inputStParts 0))
         (-fragPart (aref -inputStParts 1))
         (-fPath (xahsite-web-path-to-filepath pt1 default-directory))
         -rltvPath -titleText -resultStr
         (-currentBufferFilePathOrDir (expand-file-name (or (buffer-file-name) default-directory)))
         (-currentBufferFileDir (file-name-directory (or (buffer-file-name) default-directory))))

    (if (file-exists-p -fPath)
        (progn
          (setq -titleText
                (if (string-match-p ".+html\\'" -fPath)
                    (concat (xah-html-get-html-file-title -fPath t) -fragPart)
                  (file-name-nondirectory -fPath)))
          (setq -resultStr
                (if (string-equal
                     (xahsite-get-domain-of-local-file-path -currentBufferFilePathOrDir)
                     (xahsite-get-domain-of-local-file-path -fPath))
                    (progn
                      (setq -rltvPath (file-relative-name -fPath -currentBufferFileDir))
                      (format "<a href=\"%s\">%s</a>"
                              (concat -rltvPath -fragPart)
                              (if (string-equal -titleText "") -rltvPath -titleText )))
                  (progn
                    (format "<a href=\"%s\">%s</a>" (concat (xahsite-filepath-to-url -fPath) -fragPart) -titleText))))
          (delete-region *begin *end)
          (insert -resultStr))
      (progn (message (format "Cannot locate the file: 「%s」" -fPath))))))

(defun nodejs-get-title (*fName *fragPart)
  "Return the file frag part function title.
 (nodejs-get-title \"/home/xah/web/xahlee_info/node_api/net.html\" \"#net_server_listen_port_host_backlog_callback\" )
returns
 \"server.listen(port, [host], [backlog], [callback])\"
"
  (with-temp-buffer
    (insert-file-contents *fName nil nil nil t)
    (goto-char 1)
    (if (string= *fragPart "")
        (progn
          (search-forward "<div id=\"apicontent\">")
          (if (search-forward "<h1>" nil t)
              (progn (buffer-substring-no-properties
                      (point)
                      (-  (search-forward "<span>") 6)) )
            (progn
              (goto-char 1)
              (buffer-substring-no-properties
               (search-forward "<title>")
               (- (search-forward "</title>") 8)) ) ) )
      (progn
        (search-forward *fragPart)
        (buffer-substring-no-properties
         (search-forward "\">")
         (-  (search-forward "</a>") 4))  )
      ) ))

(defun xah-clojure-word-ref-linkify ()
  "Make the path under cursor into a HTML link for xah site.
Version 2016-03-07"
  (interactive)
  (let ( -p1 -p2 -wd )
    (if (use-region-p)
        (setq -p1 (region-beginning) -p2 (region-end))
      (progn
        (skip-chars-backward "-A-Za-z0-9*+!-_?")
        (setq -p1 (point))
        (skip-chars-forward "-A-Za-z0-9*+!-_?")
        (setq -p2 (point))))
    (setq -wd (buffer-substring-no-properties -p1 -p2))
    (delete-region -p1 -p2)
    (insert (concat "<span class=\"ref\"><a href=\"../clojure-doc-1.8/clojure.core-api.html#clojure.core/" -wd "\">clojure.core/" -wd "</a></span>"))))

(defun xah-nodejs-ref-linkify ()
  "Make the path under cursor into a HTML link for xah site.

For Example, if you cursor is on the text “../emacs/emacs.html”,
then it'll become:
“<a href=\"../emacs/emacs.html\">Xah's Emacs Tutorial</a>”.
The link text is pulled from the file's <h1> tag.

If there is text selection, use it as file path.

The file path can also be a full path or URL, See: `xahsite-web-path-to-filepath'.

sample
file:///home/xah/web/xahlee_info/node_api/process.html#process_process_execpath

file:///home/xah/web/xahlee_info/node_api/process.html#process_process_execpath

<span class=\"ref\"><a href=\"../node_api/process.html#process_process_execpath\">Node doc process.execpath</a></span>

linkText
Version 2016-10-31"
  (interactive)
  (let* (
         (-bds (xah-get-bounds-of-thing-or-region 'filepath))
         (-p1 (car -bds))
         (-p2 (cdr -bds))
         (-inputStr (buffer-substring-no-properties -p1 -p2))
         (currentBufferFilePathOrDir (or (buffer-file-name) default-directory))
         (currentBufferFileDir (file-name-directory (or (buffer-file-name) default-directory)))

         (temp87318 (split-uri-hashmark -inputStr))
         (urlMainPart (elt temp87318 0))
         (urlFragPart (elt temp87318 1))
         (-fPath (xahsite-web-path-to-filepath urlMainPart default-directory))
         rltvPath titleText -resultStr
         )

    (if (file-exists-p -fPath)
        (progn
          (setq titleText (concat "⬢ " (nodejs-get-title -fPath urlFragPart)))
          (setq -resultStr
                (if (string-equal
                     (xahsite-get-domain-of-local-file-path currentBufferFilePathOrDir)
                     (xahsite-get-domain-of-local-file-path -fPath))
                    (progn
                      (setq rltvPath (file-relative-name -fPath currentBufferFileDir))
                      (format "<span class=\"ref\"><a href=\"%s%s\">%s</a></span>" rltvPath urlFragPart titleText))
                  (progn
                    (format "<span class=\"ref\"><a href=\"%s%s\">%s</a></span>" (xahsite-filepath-to-url -fPath) urlFragPart titleText))))
          (delete-region -p1 -p2)
          (insert -resultStr))
      (progn (message (format "Cannot locate the file: 「%s」" -fPath))))))

(defun xah-javascript-linkify ()
  "Make the path under cursor into a HTML link.
 eg <script src=\"xyz.js\"></script>
Version 2016-10-31"
  (interactive)
  (let* (
         (-bds (xah-get-bounds-of-thing-or-region 'filepath))
         (-p1 (car -bds))
         (-p2 (cdr -bds))
         (-inputStr (buffer-substring-no-properties -p1 -p2))
         (-src
          (if (string-match "^http" -inputStr )
              -inputStr
            (file-relative-name -inputStr))))
    (delete-region -p1 -p2)
    (insert (format "<script defer src=\"%s\"></script>" -src))))

(defun xah-audio-file-linkify ()
  "Make the path under cursor into a HTML link.
e.g. xyz.mp3
becomes
<audio src=\"xyz.mp3\"></audio>"
  (interactive)
  (let* (
         (-bds (xah-get-bounds-of-thing-or-region 'filepath))
         (-p1 (car -bds))
         (-p2 (cdr -bds))
         (-inputStr (buffer-substring-no-properties -p1 -p2))
         (-src
          (if (string-match "^http" -inputStr )
              -inputStr
            (file-relative-name -inputStr))))
    (delete-region -p1 -p2)
    (insert (format "<audio src=\"%s\" controls></audio>" -src))))

(defun xah-video-file-linkify ()
  "Make the path under cursor into a HTML video tag link.
e.g. xyz.webm
becomes
<video src=\"i/xyz.webm\" controls loop autoplay></video>
Version 2017-02-12"
  (interactive)
  (let* (
         (-bds (bounds-of-thing-at-point 'filename ))
         (-p1 (car -bds))
         (-p2 (cdr -bds))
         (-inputStr (buffer-substring-no-properties -p1 -p2 ))
         (-src
          (if (string-match "^http" -inputStr )
              -inputStr
            (if (file-exists-p -inputStr)
                (file-relative-name -inputStr)
              (user-error "file not found: 「%s」" -inputStr)))))
    (delete-region -p1 -p2)
    (insert (format "<video src=\"%s\" controls loop autoplay></video>" -src))))

(defun xah-css-linkify ()
  "Make the path under cursor into a HTML link.
 e.g. /home/xah/web/xahlee_org/lit.css
becomes
<link rel=\"stylesheet\" href=\"../lit.css\" />
Version 2016-10-31"
  (interactive)
  (let* (
         (-bds (xah-get-bounds-of-thing-or-region 'filepath))
         (-p1 (car -bds))
         (-p2 (cdr -bds))
         (-inputStr (buffer-substring-no-properties -p1 -p2))
         (-src (if (string-match "^http" -inputStr ) -inputStr (file-relative-name -inputStr))))
    (delete-region -p1 -p2)
    (insert (format "<link rel=\"stylesheet\" href=\"%s\" />" -src))))

(defun xah-curve-linkify ()
  "Make the current word or text selection into a HTML link.

This function works on Xah Lee's website only.
 Example:
 “parabola” becomes
“<a href=\"../Parabola_dir/parabola.html\">parabola</a>”.

The directory to search includes:
“SpecialPlaneCurves_dir” and “surface”.
Version 2015-03-18"
  (interactive)
  (let* (
         (-bds (bounds-of-thing-at-point 'symbol))
         (-p1 (car -bds))
         (-p2 (cdr -bds))
         (-inputWord (if (use-region-p)
                         (progn (buffer-substring-no-properties (region-beginning) (region-end)))
                       (progn (buffer-substring-no-properties -p1 -p2))))
         (-wordPath (replace-regexp-in-string " " "_" (downcase -inputWord))) ; word for constructing possible dir
         (-pathsToTest
          (vector
           (concat "~/web/xahlee_info/SpecialPlaneCurves_dir/" (upcase-initials -wordPath) "_dir/" -wordPath ".html")
           (concat "~/web/xahlee_info/surface/" -wordPath "/" -wordPath ".html")))
         -i  -found-p -rPath -linkWord)

    ;; loop thru the paths until a file is found
    (setq -found-p nil)
    (setq -i 0)
    (while (and (not -found-p) (< -i (length -pathsToTest)))
      (setq -rPath (elt -pathsToTest -i))
      (setq -found-p (file-exists-p -rPath))
      (setq -i (1+ -i)))

    (if -found-p
        (progn
          (setq -linkWord (replace-regexp-in-string "_" " " -inputWord))
          (delete-region -p1 -p2)
          (insert (concat "<a href=\"" (file-relative-name -rPath) "\">" -linkWord "</a>")))
      (progn (beep) (message "No file found")))))

(defun xah-all-linkify ()
  "Make the text under cursor into a HTML link for xah's sites.

text can be any of:
• relative path (file, image, or anything)
• Wikipedia link
• any URL

They will be changed into a HTML link in various formats, depending on the input.

If there is text selection, use it as input.
Version 2017-02-12"
  (interactive)
  (let* ( -p1 -p2 -input)
    ;; (if (string-match "%" -input )
    ;;     (decode-coding-string (url-unhex-string "https://mysticsiva.wordpress.com/2016/11/04/%E3%82%AD%E3%83%BC%E3%82%AD%E3%83%A3%E3%83%83%E3%83%97%E4%BA%A4%E6%8F%9B3/") 'utf-8)
    ;;   -input)
    (if (use-region-p)
        (setq -p1 (region-beginning) -p2 (region-end))
      (save-excursion
        (let (-p0)
          (setq -p0 (point))
          ;; chars that are likely to be delimiters of full path, e.g. space, tabs, brakets.
          (skip-chars-backward "^  \"\t\n'|[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\`")
          (setq -p1 (point))
          (goto-char -p0)
          (skip-chars-forward "^  \"\t\n'|[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\'")
          (setq -p2 (point)))))
    (setq -input (buffer-substring-no-properties -p1 -p2))
    (cond
     ((string-match-p "javascript_es2016/ECMAScript_2016" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "javascript_es6" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "javascript_ecma-262_5.1_2011" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "java8_doc" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "godoc" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "html_whatwg" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "html5_whatwg" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "css_2.1_spec" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "css_3_color_spec" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "clojure-doc-1.8" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "python_doc_2" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "python_doc_3" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "dom-whatwg/DOM_Standard.html" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "REC-SVG11-20110816" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "css_transitions/CSS_Transitions.html" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "php-doc/" -input) (xah-file-linkify -p1 -p2) (xah-insert-reference-span-tag))
     ((string-match-p "\\`http://xahlee\.blogspot\.com/\\|\\`http://wordy-english\.blogspot\.com/" -input) (xah-blogger-linkify))
     ((string-match-p "www\.amazon\.com/" -input) (xah-amazon-linkify))
     ((string-match-p "//amzn\.to/" -input) (xah-amazon-linkify))
     ((string-match-p "alexa\.design/" -input) (xah-amazon-linkify))
     ((string-match-p "www\.youtube\.com/watch" -input) (xah-youtube-linkify))
     ((string-match-p "/emacs_manual/" -input) (xah-html-emacs-ref-linkify))
     ((string-match-p "/node_api/" -input) (xah-nodejs-ref-linkify))
     ((string-match-p "\\.js\\'" -input) (xah-javascript-linkify))
     ((string-match-p "\\.css\\'" -input) (xah-css-linkify))
     ((string-match-p "\\.mp3\\'" -input) (xah-audio-file-linkify))
     ((string-match-p "\\.ogg\\'" -input) (xah-audio-file-linkify))
     ((string-match-p "\\.mp4\\'" -input) (xah-video-file-linkify))
     ((string-match-p "\\.mkv\\'" -input) (xah-video-file-linkify))
     ((string-match-p "\\.webm\\'" -input) (xah-video-file-linkify))

     ((xahsite-url-is-xah-website-p -input) (xah-file-linkify -p1 -p2))
     ((or (string-match-p "wikipedia.org/" -input)
          (string-match-p "wiktionary.org/" -input))
      (let ((case-fold-search nil))
        (if (xah-path-ends-in-image-suffix-p -input)
            (xah-html-source-url-linkify 0)
          (xah-html-wikipedia-url-linkify ))))

     ((and (string-match-p "\\`https?://" -input)) (xah-html-source-url-linkify 0)) ; generic URL

     ((xah-path-ends-in-image-suffix-p -input) (xah-image-file-to-html-figure-tag))

     (t (xah-file-linkify -p1 -p2)))))
