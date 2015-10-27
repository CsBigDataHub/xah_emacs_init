;; -*- coding: utf-8 -*-
;; Emacs settings for packages bundled with pure gnu emacs only

;; 2007-06
;;   Xah Lee
;; ∑ http://xahlee.org/



;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)
;; (setenv "LANG" "en_US.UTF-8" )
;; (setenv "LC_ALL" "en_US.UTF-8" )

;; (set-selection-coding-system 'raw-text)
;; (set-selection-coding-system 'utf-16-be)
;; (set-selection-coding-system 'utf-16-le)
;; (set-selection-coding-system 'gb18030)
;; (set-selection-coding-system nil)
;; (set-selection-coding-system 'utf-8)

;; selection-coding-system

;; •
;;           buffer code: #xE5 #x93 #x88 utf8
;;             file code: #xB9 #xFE (encoded by coding system chinese-gb18030-unix)

;㬻ᬠ⠤㥁㥾᭾䈨

;; emacs coding system
;; binary
;; chinese-gb18030
;; chinese-gb18030-dos
;; chinese-gb18030-mac
;; chinese-gb18030-unix
;; dos
;; emacs-internal
;; gb18030
;; gb18030-dos
;; gb18030-mac
;; gb18030-unix
;; mac
;; mule-utf-8
;; mule-utf-8-dos
;; mule-utf-8-mac
;; mule-utf-8-unix
;; no-conversion
;; prefer-utf-8
;; prefer-utf-8-dos
;; prefer-utf-8-mac
;; prefer-utf-8-unix
;; raw-text
;; raw-text-dos
;; raw-text-mac
;; raw-text-unix
;; unix
;; utf-16
;; utf-16-be
;; utf-16-be-dos
;; utf-16-be-mac
;; utf-16-be-unix
;; utf-16-dos
;; utf-16-le
;; utf-16-le-dos
;; utf-16-le-mac
;; utf-16-le-unix
;; utf-16-mac
;; utf-16-unix
;; utf-16be
;; utf-16be-dos
;; utf-16be-mac
;; utf-16be-unix
;; utf-16be-with-signature
;; utf-16be-with-signature-dos
;; utf-16be-with-signature-mac
;; utf-16be-with-signature-unix
;; utf-16le
;; utf-16le-dos
;; utf-16le-mac
;; utf-16le-unix
;; utf-16le-with-signature
;; utf-16le-with-signature-dos
;; utf-16le-with-signature-mac
;; utf-16le-with-signature-unix
;; utf-7
;; utf-7-dos
;; utf-7-imap
;; utf-7-imap-dos
;; utf-7-imap-mac
;; utf-7-imap-unix
;; utf-7-mac
;; utf-7-unix
;; utf-8
;; utf-8-auto
;; utf-8-auto-dos
;; utf-8-auto-mac
;; utf-8-auto-unix
;; utf-8-dos
;; utf-8-emacs
;; utf-8-emacs-dos
;; utf-8-emacs-mac
;; utf-8-emacs-unix
;; utf-8-mac
;; utf-8-unix
;; utf-8-with-signature
;; utf-8-with-signature-dos
;; utf-8-with-signature-mac
;; utf-8-with-signature-unix


(setq initial-major-mode 'fundamental-mode)

(setq mark-ring-max 5)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

(setq backup-by-copying t)
;; (setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-visited-file-name t )

(setq save-interprogram-paste-before-kill t)
(setq enable-recursive-minibuffers t)

;; 2015-07-04 bug of pasting in emacs.
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737#17
;; http://ergoemacs.org/misc/emacs_bug_cant_paste_2015.html
(setq x-selection-timeout 300)

(progn
  ;; seems pointless to warn. There's always undo.
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'scroll-left 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
)


(progn
;; dired
  (require 'dired-x)

  ;; make dired suggest target dir (for copy, move, …) that's in the other dired pane
  (setq dired-dwim-target t)

  ;; make dired list not inclued 「.」 and 「..」, and use metric prefix for file size
  (setq dired-listing-switches "-Al --si --time-style long-iso")

  ;; make dired allow deleting/copy whole dir
  (setq dired-recursive-copies (quote always))
  (setq dired-recursive-deletes (quote top))
  )



;; (set-background-color "honeydew")
(setq inhibit-splash-screen t)


(setq x-select-enable-clipboard-manager nil)

;; (setq ediff-window-setup-function 'ediff-setup-windows-plain)﻿
;; ;; (setq ediff-split-window-function 'split-window-horizontally)

(setq mouse-wheel-progressive-speed nil)


;; initial window and default window

;123456789;123456789;123456789;123456789;123456789;123456789;123456789;123456789;123456789

(setq initial-frame-alist
      '(
        (width . 102)
        (height . 54)
        (background-color . "honeydew")))

(setq default-frame-alist
      '((menu-bar-lines . 1)
        (left-fringe)
        (right-fringe)
        (tool-bar-lines . 0)
        (width . 92)
        (height . 52)
        (background-color . "honeydew")))


(require 'recentf)
(recentf-mode 1)

(desktop-save-mode 1)

(blink-cursor-mode 0 )
(setq shift-select-mode 1)

(set-default 'tab-always-indent 'complete)

(global-auto-revert-mode 1)

(setq scroll-error-top-bottom t )

(which-function-mode 1) ; show current function in mode line
(winner-mode 0)

(setq sentence-end-double-space nil )
(setq switch-to-visible-buffer t)
(setq set-mark-command-repeat-pop t)

;; set the fallback input method to Chinese for toggle-input-method
(setq default-input-method 'chinese-py) ; as of emacs 24, default is nil anyway.

(when (fboundp 'eww)
  (progn
    (defun xah-rename-eww-hook ()
      "Rename eww browser's buffer so sites open in new page."
      (rename-buffer "eww" t))
    (add-hook 'eww-mode-hook 'xah-rename-eww-hook)))

(progn
  (defun xah-turn-on-line-number ()
    "Turn on line number on margin."
    (linum-mode 1))
  (add-hook 'text-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-elisp-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-css-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-html-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-js-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-xahk-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-clojure-mode-hook 'xah-turn-on-line-number)
  (add-hook 'xah-php-mode-hook 'xah-turn-on-line-number)
  (add-hook 'python-mode-hook 'xah-turn-on-line-number)
  (add-hook 'racket-mode-hook 'xah-turn-on-line-number)
)

(progn
  ;; use variable-width font for some modes
  (defun xah-use-variable-width-font ()
    "Set current buffer to use variable-width font."
    (variable-pitch-mode 1)
    ;; (text-scale-increase 0.5 )
    )
  (add-hook 'nxml-mode-hook 'xah-use-variable-width-font)
  ;; (add-hook 'xah-elisp-mode-hook 'xah-use-variable-width-font)
  (add-hook 'xah-js-mode-hook 'xah-use-variable-width-font)
  (add-hook 'xah-css-mode-hook 'xah-use-variable-width-font)
  (add-hook 'xah-html-mode-hook 'xah-use-variable-width-font)
  )


;; minibuffer

;; Save minibuffer history
(savehist-mode 1)

;; don't let the cursor go into minibuffer prompt
(setq minibuffer-prompt-properties (quote (read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)))



;; save cursor position
(require 'saveplace)
(setq save-place-file (concat user-emacs-directory "saveplace.el") ) ; use standard emacs dir
(setq-default save-place t)

;; (setq enable-recursive-minibuffers t )

;; apache per dir config file
(add-to-list 'auto-mode-alist '("\\.htaccess\\'" . conf-unix-mode))


;;; editing related

;; make cursor movement stop in between camelCase words.
(global-subword-mode 1)

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;; set highlighting brackets
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

(electric-pair-mode 0)

(progn
  ;; interactive name completion for describe-function, describe-variable, execute-extended-command, etc.
  (icomplete-mode 1)
  ;; make icomplete prettier
  (setq icomplete-separator " ")
  ;; (setq icomplete-separator "\n")
  (setq icomplete-hide-common-prefix nil)
  (setq icomplete-in-buffer t))

(progn
  ;; make buffer switch command do suggestions, also for find-file command
  (ido-mode 1)
 ;; (ido-everywhere 1)
  (setq ido-separator "\n")
  (setq ido-enable-flex-matching t) ; show any name that has the chars you typed
  )

(electric-indent-mode 0) ; default is on in emacs 24.4

;; majority of code formatting conventions do no recommend mixed tabs and spaces. So, here.
(setq-default indent-tabs-mode nil) ; gnu emacs 23.1, 24.4.1 default is t

;; 4 is more popular than 8.
(setq tab-width 4) ; width for display tabs. emacs 23.1 default is 8

(set-default 'abbrev-mode t)



(progn
  ;; org-mode
  ;; make “org-mode” syntax color code sections
  (setq org-src-fontify-natively t)
  (setq org-startup-folded nil)
  (setq org-return-follows-link t)
  (setq org-startup-truncated nil))



;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))



(progn
  ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; http://ergoemacs.org/emacs/whitespace-mode.html
  (setq whitespace-style (quote ( spaces tabs newline space-mark tab-mark newline-mark )))

  ;; Make whitespace-mode and whitespace-newline-mode use “¶” for end of line char and “▷” for tab.
  (setq whitespace-display-mappings
        ;; all numbers are unicode codepoint in decimal. e.g. (insert-char 182 1)
        '(
          (space-mark 32 [183] [46]) ; SPACE 32 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
          (newline-mark 10 [182 10]) ; LINE FEED,
          (tab-mark 9 [9655 9] [92 9]) ; tab
          )))


;; 2009-09-29 see http://groups.google.com/group/ergoemacs/msg/9eec3b455cab3ff1 and http://stackoverflow.com/questions/885793/emacs-error-when-calling-server-start
; (and (= emacs-major-version 23) (defun server-ensure-safe-dir (dir) "Noop" t))



;; (setcdr (assq 'continuation fringe-indicator-alist) '(nil right-curly-arrow))


;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(abbrev-mode t)
;;  ;; '(initial-major-mode (quote text-mode))
;;  ;; '(initial-scratch-message "")
;;  ;; '(line-number-display-limit-width 500)
;;  ;; '(mouse-buffer-menu-mode-mult 4)
;;  ;; '(pov-run-high "+R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640 +i%s")
;;  ;; '(recentf-exclude (quote ("/ftp")))
;;  ;; '(recentf-max-menu-items 11)
;;  ;; '(recentf-max-saved-items 31)
;;  ;; '(report-emacs-bug-no-confirmation t)
;;  ;; '(report-emacs-bug-no-explanations t)
;;  ;; '(scalable-fonts-allowed t)
;;  ;; '(user-full-name "Xah Lee")
;;  ;; '(user-mail-address "xah@xahlee.org")
;;  ;; '(w32shell-add-emacs-to-path t)
;;  ;; '(w32shell-cygwin-bin "C:\\cygwin\\bin")
;;  ;; '(w32shell-msys-bin "C:\\msys\\1.0\\bin")
;;  ;; '(w32shell-shell (quote cygwin))
;;  ;; '(xlsl-mode-format-style 1)
;;  ;; '(xlsl-reference-url "http://lslwiki.net/lslwiki/wakka.php?wakka=")
;; )

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(completions-common-part ((t (:inherit default :foreground "gray50"))))
;;  '(show-paren-match ((((class color) (background light)) (:background "azure2"))))
;;  )