;; -*- coding: utf-8 -*-
;; xah's emacs keybinding.

;; jump points to other files
;; • xah_emacs_keybinding.el
;; • xah_emacs_keybinding_mode_specific.el
;; • xah_emacs_unicode_input.el
;; • xah_emacs_hyper_super_setup.el
;; • xah_emacs_mouse_binding.el
;; • xah_emacs_alias.el
;; • xah_emacs_abbr.el
;; ~/git/ergoemacs/ergoemacs/ergoemacs-keybindings/ergoemacs-variants.el

;; • 〈Dvorak Keyboard Layout〉 http://xahlee.info/comp/dvorak_keyboard_layout.html
;; • 〈ErgoEmacs Keybinding〉 http://ergoemacs.org/emacs/ergonomic_emacs_keybinding.html
;; • 〈xah_autohotkey.ahk〉 http://xahlee.info/mswin/autohotkey.html
;; • 〈Emacs: How to define Hyper ＆ Super Keys〉 http://ergoemacs.org/emacs/emacs_hyper_super_keys.html
;; • 〈Emacs: Remapping Keys Using key-translation-map〉 http://ergoemacs.org/emacs/emacs_key-translation-map.html
;; • 〈Emacs: Add Custom Keys to Enhance Productivity〉 http://ergoemacs.org/emacs/emacs_useful_user_keybinding.html
;; • 〈Keyboard Layouts Fight! Dvorak, Maltron, Colemak, NEO, Bépo, Turkish-F, …〉  http://xahlee.info/kbd/dvorak_and_all_keyboard_layouts.html

;; http://ergoemacs.org/emacs/command-frequency/Xah_Lee_2013-09-04.txt

;; Xah Lee
;; created: 2007-06.


;; generic

(define-key key-translation-map (kbd "<apps>") (kbd "<menu>"))
(define-key key-translation-map (kbd "C-t") (kbd "<menu>"))  ; useful when in terminal or Mac

(define-key key-translation-map (kbd "<escape>") (kbd "C-g"))
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;(define-key key-translation-map (kbd "C-8") (kbd "<menu>"))
;(define-key key-translation-map (kbd "<f6>") (kbd "<menu>"))
;; (define-key key-translation-map (kbd "<henkan>") (kbd "<delete>")) ; henkan is the 変換 key on Japanese keyboard for “do convert”

;; (global-set-key (kbd "<delete>") 'set-mark-command)

(global-set-key (kbd "]") 'xah-close-current-buffer)

(global-set-key (kbd "<M-backspace>") nil) ;need to set this to something useful



(global-set-key (kbd "M-m") 'hippie-expand)

;; Truly Ergonomic keyboard + Dvorak layout
;; \` 1234 5 6 7890 []
;; \z ',.p y f gcrl /=
;;    aoeu i d htns
;;    ;qjk x b mwv-

;; prefix keys should be
;; .p yf gc
;; eu id ht

;; u is for unicode insert
;; e is mode-specific
;; h is help-map
;; t is generic dump space
;; x is for ctl-x-map

;; stars indicate frequency of use
;; ★★★ every minute
;; ★★ every hour
;; ★ few times a day

; qwerty
; er t y ui
; df g h jk

; matt's ErgoEmacs key sequence bindings
; 【.】 【p】 【y】       | 【f】 C-h 【g】 C-c 【c】
; 【e】 【u】 C-x   【i】  | 【d】 C-h 【h】 C-c 【t】
;                                 【m】 commit

(progn
  (define-key help-map (kbd "c") 'describe-char)
  (define-key help-map (kbd "3") 'man)
  (define-key help-map (kbd "7") 'lookup-google)
  (define-key help-map (kbd "8") 'lookup-wikipedia)
  (define-key help-map (kbd "9") 'lookup-word-definition)
  (define-key help-map (kbd "0") 'lookup-all-dictionaries)
  (define-key help-map (kbd "`") 'elisp-index-search)
  (define-key help-map (kbd "m") 'xah-describe-major-mode)
  (define-key help-map (kbd "o") nil)  ; ergoemacs-where-is-old-binding
  (define-key help-map (kbd "h") nil) ; view-hello-file
  )

(global-set-key (kbd "<XF86Launch8>") 'universal-argument)

(global-set-key (kbd "<tab>") nil)
(global-set-key (kbd "<tab> <tab>") 'yas/expand)

(global-set-key (kbd "<menu> <return>") 'smex) ; 3459    0.21%  smex
;(global-set-key (kbd "<menu> <backspace>") 'delete-indentation)
(global-set-key (kbd "<menu> <backspace>") 'delete-cut-text-block)
(global-set-key (kbd "<menu> <tab>") 'indent-region)

(global-set-key (kbd "<menu> <f2>") 'xah-cut-all)
(global-set-key (kbd "<menu> <f3>") 'xah-copy-all)

(require 'package)
(package-initialize)

(progn 
(require 'highlight-symbol nil "noerror")
(global-set-key (kbd "<f8> <f8>") 'highlight-symbol-at-point)
(global-set-key (kbd "<C-f8>") 'highlight-symbol-prev)
(global-set-key (kbd "<C-f9>") 'highlight-symbol-next)
(global-set-key (kbd "<f8> <f9>") 'highlight-symbol-query-replace)
)

(global-set-key (kbd "<f9> SPC") 'flyspell-buffer) ; 306    0.02%  flyspell-buffer
(global-set-key (kbd "<f9> <f6>") 'visual-line-mode)
(global-set-key (kbd "<f9> <f7>") 'linum-mode)
(global-set-key (kbd "<f9> <f8>") 'whitespace-mode)
(global-set-key (kbd "<f9> <f9>") 'shell)
(global-set-key (kbd "<f9> <f10>") 'calc)
(global-set-key (kbd "<f9> <f11>") 'calendar)
(global-set-key (kbd "<f9> <f12>") nil)

(global-set-key (kbd "<f9> 0") nil)
(global-set-key (kbd "<f9> 1") nil)
(global-set-key (kbd "<f9> 2") nil)
(global-set-key (kbd "<f9> 3") 'xah-elisp-mode)
(global-set-key (kbd "<f9> 4") 'xah-php-mode)
(global-set-key (kbd "<f9> 5") 'xah-html-mode)
(global-set-key (kbd "<f9> 6") 'html-mode)
(global-set-key (kbd "<f9> 7") nil)
(global-set-key (kbd "<f9> 8") nil)
(global-set-key (kbd "<f9> 9") nil)

(global-set-key (kbd "<f9> <return>") 'run-current-file) ;  1494    0.09%  run-current-file

;; (global-set-key (kbd "<menu> <tab>") 'yas/expand)

;xah-cycle-camel-style-case

(global-set-key (kbd "<menu> .") nil)
(global-set-key (kbd "<menu> '") nil) ;
(global-set-key (kbd "<menu> ,") nil) ;

(global-set-key (kbd "<menu> -") nil)

(global-set-key (kbd "<menu> /") nil)
(global-set-key (kbd "<menu> 0") nil)
(global-set-key (kbd "<menu> 1") nil)
(global-set-key (kbd "<menu> 2") 'delete-window) ;
(global-set-key (kbd "<menu> 3") 'delete-other-windows) ;
(global-set-key (kbd "<menu> 4") 'split-window-vertically) ; 2742    0.17%  split-window-vertically

(global-set-key (kbd "<menu> 5") 'shell-command) ;  ; 274    0.02%  shell-command
(global-set-key (kbd "<menu> 6") 'write-file)
(global-set-key (kbd "<menu> 7") 'xah-open-file-at-cursor) ;  find-file-at-point 4773    0.30%  xah-open-file-at-cursor
(global-set-key (kbd "<menu> 8") 'dired-jump)              ;  2377    0.15%  dired-jump
(global-set-key (kbd "<menu> 9") 'ispell-word)
(global-set-key (kbd "<menu> ;") nil) ;
(global-set-key (kbd "<menu> =") nil)
(global-set-key (kbd "<menu> SPC") 'set-mark-command)
(global-set-key (kbd "<menu> [") 'remove-square-brackets)
(global-set-key (kbd "<menu> \\") 'xah-escape-quotes)
(global-set-key (kbd "<menu> `") 'make-backup)
(global-set-key (kbd "<menu> a") 'mark-whole-buffer) ;★★     408    0.03%  mark-whole-buffer
(global-set-key (kbd "<menu> b") 'xah-shell-commands)
(global-set-key (kbd "<menu> c") 'xah-open-file-fast)

(global-set-key (kbd "<menu> e") nil) ;

 (global-set-key (kbd "<menu> f") 'copy-file-path) ;  2041    0.13%  copy-file-path

; ~/git/xah_emacs_init/xah_emacs_keybinding_shift_switch.el
(global-set-key (kbd "<menu> g") 'list-matching-lines) ; 432    0.03%  list-matching-lines

(progn
;  (global-set-key (kbd "<menu> h") help-map) ;
  (global-set-key (kbd "<menu> h") nil)

  (global-set-key (kbd "<menu> h 0") 'lookup-all-dictionaries)
  (global-set-key (kbd "<menu> h 1") nil)
  (global-set-key (kbd "<menu> h 2") nil)
  (global-set-key (kbd "<menu> h 3") 'man)
  (global-set-key (kbd "<menu> h 4") 'elisp-index-search)
  (global-set-key (kbd "<menu> h 5") nil)
  (global-set-key (kbd "<menu> h 6") nil)
  (global-set-key (kbd "<menu> h 7") 'lookup-google)
  (global-set-key (kbd "<menu> h 8") 'lookup-wikipedia)
  (global-set-key (kbd "<menu> h 9") 'lookup-word-definition)

  (global-set-key (kbd "<menu> h a") 'apropos-command)
  (global-set-key (kbd "<menu> h b") 'describe-bindings)
  (global-set-key (kbd "<menu> h c") 'describe-char)
  (global-set-key (kbd "<menu> h C") 'describe-coding-system)
  (global-set-key (kbd "<menu> h d") 'apropos-documentation)
  (global-set-key (kbd "<menu> h e") 'view-echo-area-messages)
  (global-set-key (kbd "<menu> h f") 'describe-function)
  (global-set-key (kbd "<menu> h F") 'Info-goto-emacs-command-node)
  (global-set-key (kbd "<menu> h i") 'info)
  (global-set-key (kbd "<menu> h I") 'describe-input-method)
  (global-set-key (kbd "<menu> h I") 'Info-goto-emacs-key-command-node)
  (global-set-key (kbd "<menu> h k") 'describe-key)
  (global-set-key (kbd "<menu> h l") 'view-lossage)
  (global-set-key (kbd "<menu> h L") 'describe-language-environment)
  (global-set-key (kbd "<menu> h m") 'xah-describe-major-mode)
  (global-set-key (kbd "<menu> h n") 'view-emacs-news)
  (global-set-key (kbd "<menu> h p") 'finder-by-keyword)
  (global-set-key (kbd "<menu> h r") 'info-emacs-manual)
  (global-set-key (kbd "<menu> h s") 'describe-syntax)
  (global-set-key (kbd "<menu> h S") 'info-lookup-symbol)
  (global-set-key (kbd "<menu> h v") 'describe-variable)
  (global-set-key (kbd "<menu> h w") 'where-is)
  )

(progn
  (global-set-key (kbd "<menu> i") nil)
  (global-set-key (kbd "<menu> i d") 'insert-date)
  (global-set-key (kbd "<menu> i n") 'ξ-insert-random-number)
  (global-set-key (kbd "<menu> i x") 'ξ-insert-random-hex)
  (global-set-key (kbd "<menu> i s") 'ξ-insert-random-string)
  (global-set-key (kbd "<menu> i u") 'ξ-insert-random-uuid)
 )

;(global-set-key (kbd "<menu> j") 'kmacro-start-macro) ;  42    0.00%  kmacro-start-macro
;(global-set-key (kbd "<menu> k") 'kmacro-end-macro)   ; 36    0.00%  kmacro-end-macro
(global-set-key (kbd "<menu> j") 'xah-copy-all)
(global-set-key (kbd "<menu> k") nil)
(global-set-key (kbd "<menu> l") 'xah-clean-whitespace)

(global-set-key (kbd "<menu> m") nil)

(global-set-key (kbd "<menu> n") 'narrow-to-region)
(global-set-key (kbd "<menu> o") nil)
(global-set-key (kbd "<menu> o c") 'bookmark-bmenu-list)
(global-set-key (kbd "<menu> o g") 'ibuffer) ; 198    0.01%  ibuffer
(global-set-key (kbd "<menu> o h") 'recentf-open-files) ;  333    0.02%  recentf-open-files
(global-set-key (kbd "<menu> o t") 'ido-switch-buffer)  ; 33    0.00%  ido-switch-buffer

(global-set-key (kbd "<menu> o d") 'xah-open-in-desktop) ; 325    0.02%  xah-open-in-desktop

(global-set-key (kbd "<menu> p") 'query-replace) ; 2746    0.17%  query-replace

(global-set-key (kbd "<menu> q") 'xah-cut-all)
(global-set-key (kbd "<menu> r") nil)
(global-set-key (kbd "<menu> r 3") 'copy-to-register-1)
(global-set-key (kbd "<menu> r 8") 'paste-from-register-1)
(global-set-key (kbd "<menu> r '") 'xah-replace-straight-quotes)
(global-set-key (kbd "<menu> r ,") 'xah-remove-punctuation-trailing-redundant-space)
(global-set-key (kbd "<menu> r .") 'xah-convert-english-chinese-punctuation)
(global-set-key (kbd "<menu> r d") 'delete-matching-lines) ; ★★     317    0.02%  delete-matching-lines
(global-set-key (kbd "<menu> r f") 'xah-find-text)
(global-set-key (kbd "<menu> r p") 'xah-convert-asian/ascii-space)
(global-set-key (kbd "<menu> r r") 'xah-find-replace-text)
(global-set-key (kbd "<menu> r u") 'query-replace-regexp) ; 288    0.02%  query-replace-regexp

  (global-set-key (kbd "<menu> s") 'save-buffer) ; 25468    1.58%  save-buffer

(progn
  (global-set-key (kbd "<menu> t") nil)
  (global-set-key (kbd "<menu> t 2") 'make-frame-command) ;
  (global-set-key (kbd "<menu> t 3") 'xah-new-empty-buffer) ;  1700    0.11%  xah-new-empty-buffer
  (global-set-key (kbd "<menu> t 4") 'ido-find-file)         ; open. 765    0.05%  ido-find-file
  (global-set-key (kbd "<menu> t 6") 'xah-open-in-external-app) ; 0.00%  xah-open-in-external-app
  (global-set-key (kbd "<menu> t c") 'xah-cite)
  (global-set-key (kbd "<menu> t f") 'xah-open-file-from-clipboard)
  (global-set-key (kbd "<menu> t r") 'repeat-complex-command)
  (global-set-key (kbd "<menu> t s") 'title-case-string-region-or-line)
  (global-set-key (kbd "<menu> t w") 'delete-trailing-whitespace)
  (global-set-key (kbd "<menu> t <delete>") 'delete-current-file)
  )

(progn
  (global-set-key (kbd "<menu> u") nil) ;
  (global-set-key (kbd "<menu> u -") "—") ; EM DASH
  (global-set-key (kbd "<menu> u ,") 'insert-pair-greater-less)

  (global-set-key (kbd "<menu> u RET") 'xah-insert-unicode)

  (global-set-key (kbd "<menu> u . <down>") "⇓")
  (global-set-key (kbd "<menu> u . <left>") "⇐")
  (global-set-key (kbd "<menu> u . <right>") "⇒")
  (global-set-key (kbd "<menu> u . <up>") "⇑")
  (global-set-key (kbd "<menu> u . b") 'insert-pair-white-lenticular-bracket〖〗)
  (global-set-key (kbd "<menu> u . m") 'insert-pair-white-corner-bracket『』)
  (global-set-key (kbd "<menu> u . w") 'insert-pair-double-angle-bracket《》)

  (global-set-key (kbd "<menu> u 1") "!")
  (global-set-key (kbd "<menu> u 2") "@")
  (global-set-key (kbd "<menu> u 3") "#") ;
  (global-set-key (kbd "<menu> u 4") "$") ;
  (global-set-key (kbd "<menu> u 5") "%") ;
  (global-set-key (kbd "<menu> u 6") "^")
  (global-set-key (kbd "<menu> u 7") "&") ;
  (global-set-key (kbd "<menu> u 8") "*") ;
  (global-set-key (kbd "<menu> u 9") "(") ;
  (global-set-key (kbd "<menu> u 0") ")")

  (global-set-key (kbd "<menu> u 2") "¤")
  (global-set-key (kbd "<menu> u 3") "◇") ; white diamond
  (global-set-key (kbd "<menu> u 4") "◆") ; black diamond
  (global-set-key (kbd "<menu> u 5") "🎶") ; MULTIPLE MUSICAL NOTES
  (global-set-key (kbd "<menu> u 7") "＆") ; full width ampersand
  (global-set-key (kbd "<menu> u 8") "•") ; bullet
  (global-set-key (kbd "<menu> u 9") "⭑") ; BLACK SMALL STAR
  (global-set-key (kbd "<menu> u <down>") "↓")
  (global-set-key (kbd "<menu> u <left>") "←")
  (global-set-key (kbd "<menu> u <right>") "→")
  (global-set-key (kbd "<menu> u <up>") "↑")
  (global-set-key (kbd "<menu> u SPC") (lambda () (interactive) (insert " "))) ;insert non-breaking space
  (global-set-key (kbd "<menu> u \\") "、") ; IDEOGRAPHIC COMMA
  (global-set-key (kbd "<menu> u b") 'insert-pair-black-lenticular-bracket【】)
  (global-set-key (kbd "<menu> u c") "=") ; equal
  (global-set-key (kbd "<menu> u d") 'insert-pair-double-curly-quote“”)
  (global-set-key (kbd "<menu> u f") 'insert-pair-single-straight-quote)
  (global-set-key (kbd "<menu> u g") 'insert-pair-double-straight-quote)
  (global-set-key (kbd "<menu> u h") 'insert-pair-brace)              ;{}
  (global-set-key (kbd "<menu> u i") 'insert-pair-single-curly-quote‘’)
  (global-set-key (kbd "<menu> u l") "…") ; HORIZONTAL ELLIPSIS
  (global-set-key (kbd "<menu> u m") 'insert-pair-corner-bracket「」)
  (global-set-key (kbd "<menu> u n") 'insert-pair-bracket)            ;[]
  (global-set-key (kbd "<menu> u p") 'insert-pair-double-angle-quote«»)
  (global-set-key (kbd "<menu> u r") "+") ; plus
  (global-set-key (kbd "<menu> u t") 'insert-pair-paren)              ;()
  (global-set-key (kbd "<menu> u u") nil)
  (global-set-key (kbd "<menu> u w") 'insert-pair-angle-bracket〈〉)
  (global-set-key (kbd "<menu> u x") 'insert-pair-tortoise-shell-bracket〔〕)
  (global-set-key (kbd "<menu> u y") 'insert-pair-single-angle-quote‹›)
  )

(global-set-key (kbd "<menu> v") nil)
(global-set-key (kbd "<menu> w") 'widen)
(global-set-key (kbd "<menu> x") ctl-x-map)
(global-set-key (kbd "<menu> y") 'universal-argument) ; ★★
(global-set-key (kbd "<menu> z") 'xc-comment-smart) ; 385    0.02%  xc-comment-smart


;; special keys

(global-set-key (kbd "<insert>") 'xah-switch-to-next-frame)


;;;; misc

;; (load (fullpath-relative-to-current-file "xah_emacs_keybinding_unset_keys.el"))

    ;; ("<f1> 6" lookup-all-dictionaries)
    ;; ("<f1> 7" lookup-google)
    ;; ("<f1> 8" lookup-wikipedia)
    ;; ("<f1> 9" lookup-word-definition)
    ;; ("<f1> 0" lookup-answers.com)
    ;; ("<f1> [" lookup-word-dict-org)
    ;; ("<f1> ]" lookup-wiktionary)

(global-set-key (kbd "<f1> <f2>") 'helm-mini)

;; (load (fullpath-relative-to-current-file "xah_emacs_keybinding_number_pad"))
(load (fullpath-relative-to-current-file "xah_emacs_keybinding_number_pad_number"))
;; (load (fullpath-relative-to-current-file "xah_emacs_keybinding_truly_ergonomic"))
(load (fullpath-relative-to-current-file "xah_emacs_unicode_input"))

(global-set-key (kbd "C--") 'xah-cycle-camel-style-case)
(global-set-key (kbd "C-1") 'cycle-font-backward)
(global-set-key (kbd "C-2") 'cycle-font-forward)
(global-set-key (kbd "C-3") 'cycle-font-2)
(global-set-key (kbd "C-4") 'xah-convert-fullwidth-chars)
(global-set-key (kbd "C-5") 'xah-convert-latin-alphabet-gothic)
(global-set-key (kbd "C-6") nil)
(global-set-key (kbd "C-7") 'xah-cycle-hyphen-underscore-space)
(global-set-key (kbd "C-8") nil)
(global-set-key (kbd "C-9") nil)

;; ;; (global-set-key (kbd "C-a") nil) ; select all
;; (global-set-key (kbd "C-b") nil)
;; ;; (global-set-key (kbd "C-c") nil) ; mode specific
;; (global-set-key (kbd "C-d") nil)
;; (global-set-key (kbd "C-e") nil)
;; ;; (global-set-key (kbd "C-f") nil) ; find
;; ;; (global-set-key (kbd "C-g") nil) ; cancel
;; ;; (global-set-key (kbd "C-h") nil) ; help
;; ;; (global-set-key (kbd "C-i") nil) ; tab
;; ;; (global-set-key (kbd "C-j") nil) ; newline
;; (global-set-key (kbd "C-k") nil)
;; (global-set-key (kbd "C-l") nil)
;; ;; (global-set-key (kbd "C-m") nil) ; return
;; ;; (global-set-key (kbd "C-n") nil) ; new
;; ;; (global-set-key (kbd "C-o") nil) ; open
;; (global-set-key (kbd "C-p") nil)
;; ;; (global-set-key (kbd "C-q") nil) ; quote
;; (global-set-key (kbd "C-r") nil)
;; (global-set-key (kbd "C-s") nil)
;; (global-set-key (kbd "C-t") nil)
;; (global-set-key (kbd "C-u") nil)
;; (global-set-key (kbd "C-v") nil)
;; ;; (global-set-key (kbd "C-w") nil) ; close
;; ;; (global-set-key (kbd "C-x") nil) C-x
;; ;; (global-set-key (kbd "C-y") nil)
;; (global-set-key (kbd "C-z") nil)

;(global-set-key (kbd "C-o") 'backward-sexp)
;(global-set-key (kbd "C-u") 'forward-sexp)
;(global-set-key (kbd "C-e") 'down-list)
;(global-set-key (kbd "C-.") 'backward-up-list)

;(global-unset-key (kbd "C-+") )         ; text-scale-increase
;(global-unset-key (kbd "C--") )         ; text-scale-decrease
;(global-unset-key (kbd "C-a") )         ; mark-whole-buffer
;(global-unset-key (kbd "C-s") )         ; save
;(global-unset-key (kbd "C-o") )         ; open
;(global-unset-key (kbd "C-0") ) ; text-scale-normal-size
;(global-unset-key (kbd "M-5") )
;(global-unset-key (kbd "M-3") )
;(global-unset-key (kbd "M-4") )
;(global-unset-key (kbd "M--") )
;(global-unset-key (kbd "M-%") )
;(global-unset-key (kbd "M-l") )         ; recenter-top-bottom
;(global-unset-key (kbd "M-0") )         ; delete-window
;(global-unset-key (kbd "C-S-t") )       ; xah-open-last-closed
;(global-unset-key (kbd "C-u") )       ; universal-argument

(load (fullpath-relative-to-current-file "xah_emacs_keybinding_ergoemacs_raw.el"))
(load (fullpath-relative-to-current-file "xah_emacs_keybinding_functions.el"))

;; (global-set-key (kbd "<backspace>") 'delete-backward-char)

(global-set-key (kbd "<prior>") 'xah-backward-block) ; page up
(global-set-key (kbd "<next>") 'xah-forward-block) ; page down

(global-set-key (kbd "<S-prior>") 'scroll-down) ; page up
(global-set-key (kbd "<S-next>") 'scroll-up) ; page down

;; keys for moving to prev/next code section (form feed; ^L)
(global-set-key (kbd "<C-M-prior>") 'backward-page) ; Ctrl+Alt+PageUp
(global-set-key (kbd "<C-M-next>") 'forward-page)   ; Ctrl+Alt+PageDown

(global-set-key (kbd "<C-M-next>") 'forward-page)   ; Ctrl+Alt+PageDown

(require 'ido)
(define-key ido-file-completion-map (kbd "C-o") 'ido-fallback-command)

;; (defun toggle-menu-key ()
;;   "toggle the value of `w32-apps-modifier' between 'meta and 'nil"
;;   (interactive)
;;   (if (eq w32-apps-modifier 'meta)
;;         (progn (setq w32-apps-modifier 'nil))
;;       (progn (setq w32-apps-modifier 'meta) )
;;       ))

;; ~/web/ergoemacs_org/emacs/gnu_emacs_keybinding_C-x.txt

;; some idea about command categories, in context to chosing keys for them

;; • whether a command has immediate effect, no prompt. ⁖ shell vs delete-matching-lines
;; • whether a command has is safe to run by mistake. ⁖ whitespace-mode vs eval-buffer
;; • whether a command is frequently needed ⁖ few times a min, hour, day

;; idea about key groups
;; all should be sequence of single keys. 2 to 3 keys. All should start with F7. And all commands should be globally useful.
;; • 2 keys vs 3 keys
;; • whether the key ends in a digit key 0 to 9. These probably should be most frequently used, or immediate effect.

;; (ergoemacs-ignore-prev-global) ; Do not honor previously defined global keys. 2013-06-24

(global-set-key (kbd "<S-backspace>") 'delete-char)

(global-set-key (kbd "<M-backspace>") 'backward-kill-word)

(global-set-key (kbd "<M-return>") 'open-line)

;(global-set-key (kbd "<menu> p") 'yas/expand)
;(global-set-key (kbd "") 'indent-region)
;
;'indent-for-tab-command

(global-set-key (kbd "s-x") "ξ")

;; (global-set-key (kbd "<right>") 'forward-word)
;; (global-set-key (kbd "<left>") 'backward-word)
;; (global-set-key (kbd "<up>") 'xah-backward-block)
;; (global-set-key (kbd "<down>") 'xah-forward-block)

;; (global-set-key (kbd "M-2") nil)
;; (global-set-key (kbd "M-3") nil)
;; (global-set-key (kbd "M-4") nil)



(global-set-key (kbd "<f11>") 'delete-other-windows)
(global-set-key (kbd "<f12>") 'other-window); 6067    0.38%  other-window
(global-set-key (kbd "<C-prior>") 'xah-previous-user-buffer)
(global-set-key (kbd "<C-next>") 'xah-next-user-buffer)
(global-set-key (kbd "<S-prior>") 'xah-previous-emacs-buffer)
(global-set-key (kbd "<S-next>") 'xah-next-emacs-buffer)

;; (global-set-key (kbd "<home>") 'other-window)
;; (global-set-key (kbd "<end>") 'smex)
;; (global-set-key (kbd "<prior>") 'split-window-below) ;  2735    0.17%  split-window-vertically
;; (global-set-key (kbd "<next>") 'delete-other-windows) ;  4996    0.31%  delete-other-windows

(global-set-key (kbd "<prior>") 'xah-backward-block) ;  93862    5.83%  xah-backward-block
(global-set-key (kbd "<next>") 'xah-forward-block)    ;  80008    4.97%  xah-forward-block
;(global-set-key (kbd "<home>") 'xah-backward-open-bracket) ;  14181    0.88%  xah-backward-open-bracket
;(global-set-key (kbd "<end>") 'xah-forward-close-bracket) ;  17177    1.07%  xah-forward-close-bracket

;; (global-set-key (kbd "<left>") 'backward-word) ;
;; (global-set-key (kbd "<right>") 'forward-word ) ;

;shell-command-on-region
; 16    0.00%  shell-command-on-region

(load (fullpath-relative-to-current-file "xah_emacs_keybinding_ergoemacs_vi.el"))

(delete-selection-mode 1)



;; ;; 2013-11-04 make emacs auto show suggestions when a prefix key is pressed
;; (require 'guide-key)
;; (setq guide-key/guide-key-sequence '("<menu> t" "<tab> t" ))
;; (guide-key-mode 0)

