;; -*- coding: utf-8; lexical-binding: t; -*-

(when (boundp 'xah-fly-key-map)

  (global-set-key (kbd "<end>") 'xah-fly-command-mode-activate)

  ;; (global-set-key (kbd "<end>") xah-fly-e-keymap)

  ;; (define-key xah-fly-key-map (kbd "<home>") xah-fly-e-keymap)

  (global-set-key (kbd "<f10>") 'xah-user-keymap)
  ;; (setq xah-fly-dot-keymap xah-user-keymap)

  ;; (define-key xah-fly-leader-key-map (kbd "e") nil)

  ;; (define-key xah-fly-key-map (kbd "SPC") 'xah-fly-space-key)
  )

;; (global-set-key (kbd "<end> 3") 'xah-remove-wikipedia-link)
;; (global-set-key (kbd "<end> 4") 'xah-remove-all-wikipedia-link)

;; (setq visible-bell nil)

;; ring-bell-function

 ;; (setq ring-bell-function (lambda ()
                            ;; (play-sound-file "/this/is/my/errorsound.au")))

;; (setq ring-bell-function 'ding)

;; (setq ring-bell-function nil)

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(define-key key-translation-map (kbd "<escape>") (kbd "C-g"))

(when (string-equal system-type "darwin")
  ;; macOS

  (define-key key-translation-map (kbd "<deletechar>") (kbd "<delete>"))
  (define-key key-translation-map (kbd "<kp-delete>") (kbd "<delete>"))

  (global-set-key (kbd "M--") 'xah-cycle-hyphen-underscore-space)

  (global-set-key (kbd "s-w") 'xah-close-current-buffer)
  (global-set-key (kbd "s-r") 'xah-browse-url-of-buffer)
  ;; (global-set-key (kbd "s-r") 'xah-open-in-safari)
  (global-set-key (kbd "s-T") 'xah-open-last-closed)
  (global-set-key (kbd "s-t") 'xah-new-empty-buffer)
  (global-set-key (kbd "s-n") 'xah-new-empty-buffer)

  (global-set-key (kbd "s-[") 'xah-previous-user-buffer)
  (global-set-key (kbd "s-]") 'xah-next-user-buffer)

  (global-set-key (kbd "s-=") 'text-scale-increase)
  (global-set-key (kbd "s--") 'text-scale-decrease)

  (global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)

  (global-set-key (kbd "<f1>") 'toggle-frame-fullscreen)
  (global-set-key (kbd "<f2>") 'xah-cut-line-or-region)
  (global-set-key (kbd "<f3>") 'xah-copy-line-or-region)
  ;; (global-set-key (kbd "<f11>") 'toggle-frame-fullscreen)

  ;; (global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)
  ;;
  )

;; (current-input-mode)
;; (t nil t 7)

;; (let ((x (current-input-mode)))
;;   (set-input-mode
;;    (nth 0 x)
;;    (nth 1 x)
;;    (nth 2 x)
;;    27))

;; (global-set-key (kbd "<prior>") 'scroll-down-command)
;; (global-set-key (kbd "<next>") 'scroll-up-command)

;; (global-set-key (kbd "<prior>") 'hippie-expand)
;; (global-set-key (kbd "<next>") 'xah-toggle-letter-case)

(global-set-key (kbd "<S-prior>") 'scroll-down)
(global-set-key (kbd "<S-next>") 'scroll-up)

;; keys for moving to prev/next code section (form feed; ^L)
(global-set-key (kbd "<C-M-prior>") 'backward-page)
(global-set-key (kbd "<C-M-next>") 'forward-page)

(global-set-key (kbd "C-t") 'hippie-expand)

;; 'xah-cycle-font-2
;; 'xah-cycle-font-next
;; 'xah-cycle-font-previous

(progn
  ;; command dump. temp, rare, or whatever. put them here to have a key for now. worry later
  (define-prefix-command 'xah-dump-keymap)

  ;; a
  ;; b
  (define-key xah-dump-keymap (kbd "c") 'xah-css-mode)
  ;; d
  (define-key xah-dump-keymap (kbd "e") 'xah-elisp-mode)
  ;; f
  ;; g
  (define-key xah-dump-keymap (kbd "h") 'xah-html-mode)
  ;; i
  (define-key xah-dump-keymap (kbd "j") 'xah-js-mode)
  ;; k
  (define-key xah-dump-keymap (kbd "l") 'xah-scan-list)

  ;; l ;; m ;; n ;; o ;; p ;; p ;; q ;; r ;; s

  (define-key xah-dump-keymap (kbd "t") 'xah-clojure-mode)

  ;; u ;; v ;; w ;; x ;; y ;; z

  )
(progn
  (define-prefix-command 'xah-user-keymap)

  (define-key xah-user-keymap (kbd "SPC") xah-dump-keymap)

  (define-key xah-user-keymap (kbd "RET") 'xah-insert-word-3)

  (define-key xah-user-keymap (kbd "<f10>") 'xah-math-input-change-to-symbol)

  ;; '
  (define-key xah-user-keymap (kbd ".") 'xah-title-case-region-or-line)


  (define-key xah-user-keymap (kbd ", c") 'xah-create-thumbnail-img)
  (define-key xah-user-keymap (kbd ", d") 'xah-image-autocrop)
  (define-key xah-user-keymap (kbd ", e") 'xah-dired-show-metadata)
  (define-key xah-user-keymap (kbd ", g") 'xah-dired-2drawing)
  (define-key xah-user-keymap (kbd ", h") 'xah-dired-scale-image)
  (define-key xah-user-keymap (kbd ", n") 'xah-dired-2png)
  (define-key xah-user-keymap (kbd ", p") 'xah-open-in-gimp)
  (define-key xah-user-keymap (kbd ", t") 'xah-dired-2jpg)
  (define-key xah-user-keymap (kbd ", u") 'xah-dired-remove-all-metadata)

  (define-key xah-user-keymap (kbd "8") 'xah-find-count)
  (define-key xah-user-keymap (kbd "9") 'xah-find-replace-text-regex)
  (define-key xah-user-keymap (kbd "0") 'xah-find-text-regex)

  ;; a
  (define-key xah-user-keymap (kbd "b") 'xah-toggle-previous-letter-case)
  (define-key xah-user-keymap (kbd "c") 'xah-cite)
  ;; d

  ;; f
  (define-key xah-user-keymap (kbd "g") 'xah-replace-straight-quotes)
  ;; h

  (define-key xah-user-keymap (kbd "i c") 'xah-insert-random-number)
  (define-key xah-user-keymap (kbd "i h") 'xah-insert-random-hex)
  (define-key xah-user-keymap (kbd "i t") 'xah-insert-random-string)
  (define-key xah-user-keymap (kbd "i n") 'xah-insert-random-uuid)

  (define-key xah-user-keymap (kbd "j") 'xah-interactive-abbrev)
  (define-key xah-user-keymap (kbd "k") 'xah-find-replace-text)
  ;; l
  (define-key xah-user-keymap (kbd "m") 'xah-move-image-file)
  ;; n
  (define-key xah-user-keymap (kbd "o") 'xah-open-file-from-clipboard)
  (define-key xah-user-keymap (kbd "p") 'xah-find-text)
  (define-key xah-user-keymap (kbd "q") 'xah-replace-invisible-char)

  ;; r s t

  (define-key xah-user-keymap (kbd "u ,") 'xah-remove-punctuation-trailing-redundant-space )
  (define-key xah-user-keymap (kbd "u .") 'xah-convert-english-chinese-punctuation)
  (define-key xah-user-keymap (kbd "u [") 'xah-remove-square-brackets)
  (define-key xah-user-keymap (kbd "u b") 'xah-change-bracket-pairs)

  (define-key xah-user-keymap (kbd "u d") 'xah-fix-datetime-stamp)
  (define-key xah-user-keymap (kbd "u g") 'xah-convert-latin-alphabet-gothic)

  (define-key xah-user-keymap (kbd "u p") 'xah-convert-asian/ascii-space)
  (define-key xah-user-keymap (kbd "u p") 'xah-replace-profanity)
  (define-key xah-user-keymap (kbd "u t") 'xah-twitterfy)
  (define-key xah-user-keymap (kbd "u w") 'xah-convert-fullwidth-chars)
  (define-key xah-user-keymap (kbd "u x") 'xah-remove-quotes-or-brackets)

  ;;  v w x y z

  )

;; 2015-08-22 add these somewhere
;; 'xah-toggle-read-novel-mode
;; 'xah-toggle-margin-right
;; 'xah-toggle-line-spacing

;; (progn
;;   (define-key key-translation-map (kbd "<menu> SPC <up>") (kbd "↑"))
;;   (define-key key-translation-map (kbd "<menu> SPC <down>") (kbd "↓"))
;;   (define-key key-translation-map (kbd "<menu> SPC <left>") (kbd "←"))
;;   (define-key key-translation-map (kbd "<menu> SPC <right>") (kbd "→"))
;;   (define-key key-translation-map (kbd "<menu> SPC 4") (kbd "◆"))
;;   (define-key key-translation-map (kbd "<menu> SPC 2") (kbd "＆"))
;;   (define-key key-translation-map (kbd "<menu> SPC 1") (kbd "•"))
;;   (define-key key-translation-map (kbd "<menu> SPC .") (kbd "…"))
;;   (define-key key-translation-map (kbd "<menu> SPC 3") (kbd "-"))
;;   (define-key key-translation-map (kbd "<menu> SPC 9") (kbd "_")))



(when (boundp 'xah-elisp-mode-map)
  (define-key xah-elisp-mode-map (kbd "<delete>") xah-elisp-mode-no-chord-map))

(when (boundp 'xah-css-mode-no-chord-map)
  (define-key xah-css-mode-no-chord-map (kbd "s") 'xah-sync-css)
  (define-key xah-css-mode-map (kbd "<delete>") xah-css-mode-no-chord-map)
  ;;
  )

(when (boundp 'xah-clojure-mode-map)
    (define-key xah-clojure-mode-map (kbd "<delete>") xah-clojure-mode-no-chord-map))

(progn
  (require 'dired )
  (define-key dired-mode-map (kbd "-") 'xah-dired-rename-space-to-underscore)
  (define-key dired-mode-map (kbd "s") 'xah-dired-sort))

(progn
  (require 'info )
  (define-key Info-mode-map (kbd "<f5>") 'xah-view-emacs-manual-in-browser))

(when (boundp 'org-mode-hook)
  (defun xah-org-mode-setup ()
    "Modify keymaps used by `org-mode'."
    (local-set-key (kbd "<C-tab>") 'xah-next-user-buffer))
  (add-hook 'org-mode-hook 'xah-org-mode-setup))



(when (fboundp 'xah-html-mode)

  (define-key xah-html-mode-map (kbd "<delete>") xah-html-mode-no-chord-map)
  (define-key xah-html-mode-map (kbd "<f5>") 'xah-browse-url-of-buffer)
  (progn

    (define-key xah-html-mode-no-chord-map (kbd "<delete>") 'xah-browse-url-of-buffer)

    (define-key xah-html-mode-no-chord-map (kbd "SPC") nil)

    (define-key xah-html-mode-no-chord-map (kbd "SPC s") 'xah-insert-reference-span-tag)
    (define-key xah-html-mode-no-chord-map (kbd "SPC SPC") 'xah-html-insert-date-section)

    (define-key xah-html-mode-no-chord-map (kbd "SPC e") 'xah-make-atom-entry)
    (define-key xah-html-mode-no-chord-map (kbd "SPC u") 'xahsite-update-article-timestamp)
    ;; . p eu gc ht
    (define-key xah-html-mode-no-chord-map (kbd "SPC b") 'xah-make-blogger-entry)
    (define-key xah-html-mode-no-chord-map (kbd "SPC c") 'xah-angle-brackets-to-html)
    (define-key xah-html-mode-no-chord-map (kbd "SPC .") 'xah-html-full-size-img-linkify)
    (define-key xah-html-mode-no-chord-map (kbd "SPC p") 'xah-copy-url-current-file)
    (define-key xah-html-mode-no-chord-map (kbd "SPC t") 'xah-open-in-safari)
    (define-key xah-html-mode-no-chord-map (kbd "SPC r d") 'xah-html-perldoc-ref-linkify)
    (define-key xah-html-mode-no-chord-map (kbd "SPC r e") 'xah-html-emacs-ref-linkify)
    (define-key xah-html-mode-no-chord-map (kbd "SPC r g") 'xah-clojure-word-ref-linkify)
    (define-key xah-html-mode-no-chord-map (kbd "SPC r j") 'xah-html-image-figure-linkify)
    (define-key xah-html-mode-no-chord-map (kbd "SPC r r") 'xah-add-to-related-links)

    (define-key xah-html-mode-no-chord-map (kbd "SPC z b") 'xah-html-insert-lyrics-header)
    (define-key xah-html-mode-no-chord-map (kbd "SPC z f") 'xah-html-insert-midi)

    (define-key xah-html-mode-no-chord-map (kbd "o") nil)

    (define-key xah-html-mode-no-chord-map (kbd "o a") 'xah-words-annotate)
    (define-key xah-html-mode-no-chord-map (kbd "o e") 'xah-words-bold-word)
    (define-key xah-html-mode-no-chord-map (kbd "o c") 'xah-words-chinese-linkify)
    (define-key xah-html-mode-no-chord-map (kbd "o m") 'xah-words-move-word-to-page)
    (define-key xah-html-mode-no-chord-map (kbd "o t") 'xah-words-word-etymology-linkify)

    (define-key xah-html-mode-no-chord-map (kbd "o n") 'xah-words-new-word-entry )
    (define-key xah-html-mode-no-chord-map (kbd "o i") 'xah-words-insert-word-entry )
    (define-key xah-html-mode-no-chord-map (kbd "o d") 'xah-words-add-definition )
    (define-key xah-html-mode-no-chord-map (kbd "o s") 'xah-words-add-source )
    (define-key xah-html-mode-no-chord-map (kbd "o c") 'xah-words-add-comment )
    (define-key xah-html-mode-no-chord-map (kbd "o g") 'xah-words-search-next-unbold )
    (define-key xah-html-mode-no-chord-map (kbd "o p") 'xah-words-query-find-then-bold )))



(when (boundp 'tuareg-mode-map)
  (define-key tuareg-mode-map (kbd "<backspace>") nil)
  (define-key tuareg-mode-map (kbd "DEL") nil))

(defun xah-rcirc-mode-keys ()
  "Modify keybindings for `rcirc'.
For `rcirc-mode-hook'."
  (local-set-key (kbd "<M-f11>") 'rcirc-insert-prev-input)
  (local-set-key (kbd "<M-f12>") 'rcirc-insert-next-input))
(add-hook 'rcirc-mode-hook 'xah-rcirc-mode-keys)

(setq rcirc-default-nick "mid2")

(when (boundp 'xah-fly-h-keymap)
  (define-key xah-fly-h-keymap (kbd "1") 'xah-lookup-etymology)
  (define-key xah-fly-h-keymap (kbd "2") 'xah-lookup-word-dict-org)
  (define-key xah-fly-h-keymap (kbd "3") 'xah-lookup-web)
  (define-key xah-fly-h-keymap (kbd "4") 'xah-lookup-word-definition)
  (define-key xah-fly-h-keymap (kbd "5") 'xah-lookup-wikipedia)
  (define-key xah-fly-h-keymap (kbd "6") 'xah-lookup-wiktionary)
  (define-key xah-fly-h-keymap (kbd "7") 'xah-lookup-all-dictionaries)
  (define-key xah-fly-h-keymap (kbd "9") 'xah-lookup-word-definition)
  ;;
  )
