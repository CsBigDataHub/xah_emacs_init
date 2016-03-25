;; -*- coding: utf-8 -*-
;; emacs abbrev def
;; 〈Using Emacs Abbrev Mode for Abbreviation〉 http://ergoemacs.org/emacs/emacs_abbrev_mode.html

; load my abbreviations file
;(read-abbrev-file "emacs_abbrev")


(clear-abbrev-table global-abbrev-table)

(define-abbrev-table 'global-abbrev-table
  '(

    ("mac" "Mac")
    ("osx" "OS X")
    ("macosx" "Mac OS X")
    ("ipv4" "IPv4")
    ("ipv6" "IPv6")
    ("msw" "Microsoft Windows")
    ("ms" "Microsoft")
    ("ex" "example")
    ("fex" "for example")
    ("jq" "jQuery")
    ("jvm" "Java Virtual Machine")
    ("cfg" "context-free grammar")
    ("sf" "San Francisco")

    ("catface" "😸")

    ("1arrows" "➵➙►▻☛☞👉⇰➛➜➝➞➟➠➢➣➤➥➦➧➨➲➺➻➼➽➾")

    ("hearts" "♥💕💓💔💖💗💘💝💞💟💙💚💛💜")
    ("1box" "┌─┬─┐
│ │ │
├─┼─┤
│ │ │
└─┴─┘")

    ;; http://oxforddictionaries.com/words/the-oec-facts-about-the-language

    ("dsnt" "doesn't")
    ("dnt" "don't")
    ("ddnt" "didn't")
    ("isnt" "isn't")
    ("cnt" "can't")
    ("wnt" "won't")
    ("wsnt" "wasn't")
    ("hnt" "haven't")
    ("shnt" "shouldn't")
    ;; ("r" "are")
    ("ur" "you are")

    ;; ("t" "the")
    ;; ("t" "be") ; 2
    ;; ("2" "to")                          ; problem with just enter a number
    ;; ("t" "of") ; 4
    ;; ("n" "and") ;3
;;; ("t" "a") ; 6
;;; ("t" "in") ; 7

  ;("h" "that") ; 8
    ;; ("h" "have") ; 9
;;; ("t" "I") ; 10
;;; ("t" "it") ; 11
    ;; ("f" "for")  ; 12
  ;("1" "not")
    ;; ("t" "on") ; 14
    ;; ("w" "with") ; 15
    ;; ("t" "he") ; 16
    ;; ("t" "as") ; 17
    ;; ("u" "you") ; 18

    ;; ("t" "do") ; 19
    ;; ("t" "at") ; 20
    ;; ("t" "this") ; 21
    ;; ("b" "but")      ; 22
    ;; ("t" "his") ; 23
    ;; ("t" "by") ; 24
    ;; ("t" "from") ; 25
    ;; ("t" "they") ; 26
    ;; ("t" "we") ; 27
    ;; ("t" "say") ; 28
    ;; ("t" "her") ; 29
    ;; ("t" "she") ; 30
    ;; ("t" "or") ; 31
    ;; ("t" "an") ; 32
    ;; ("t" "will") ; 33
    ;; ("t" "my") ; 34
    ;; ("t" "one") ; 35
    ;; ("t" "all") ; 36
    ;; ("t" "would") ; 37
    ;; ("t" "there") ; 38
    ;; ("t" "their") ; 39
    ;; ("t" "what") ; 40
    ;; ("t" "so") ; 41
    ;; ("t" "up") ; 42
    ;; ("t" "out") ; 43
    ;; ("t" "if") ; 44
    ;; ("t" "about") ; 45
    ;; ("t" "who") ; 46
    ;; ("t" "get") ; 47
    ;; ("t" "which") ; 48
    ;; ("t" "go") ; 49
    ;; ("t" "me") ; 50
    ;; ("w" "when") ; 51
    ;; ("t" "make") ; 52
    ;; ("t" "can") ; 53
    ;; ("t" "like") ; 54
    ;; ("t" "time") ; 55
    ;; ("t" "no") ; 56
    ;; ("t" "just") ; 57
    ;; ("t" "him") ; 58
    ;; ("t" "know") ; 59
    ;; ("t" "take") ; 60
  ;("pp" "people") ; 61
    ;; ("t" "into") ; 62
    ;; ("t" "year") ; 63
    ;; ("t" "your") ; 64
    ;; ("t" "good") ; 65
    ;; ("t" "some") ; 66
    ;; ("t" "could") ; 67
    ;; ("t" "them") ; 68
    ;; ("t" "see") ; 69
    ;; ("t" "other") ; 70
    ;; ("t" "than") ; 71
    ;; ("t" "then") ; 72
    ;; ("t" "now") ; 73
    ;; ("t" "look") ; 74
    ;; ("t" "only") ; 75
    ;; ("t" "come") ; 76
    ;; ("t" "its") ; 77
    ;; ("t" "over") ; 78
    ;; ("t" "think") ; 79
    ;; ("t" "also") ; 80
    ;; ("t" "back") ; 81
    ;; ("t" "after") ; 82
    ;; ("t" "use") ; 83
    ;; ("t" "two") ; 84
    ;; ("t" "how") ; 85
    ;; ("t" "our") ; 86
    ;; ("t" "work") ; 87
    ;; ("t" "first") ; 88
    ;; ("t" "well") ; 89
    ;; ("t" "way") ; 90
    ;; ("t" "even") ; 91
    ;; ("t" "new") ; 92
    ;; ("t" "want") ; 93
    ("bc" "because") ; 94
    ;; ("t" "any") ; 95
    ;; ("t" "these") ; 96
  ; ("t" "give") ; 97
  ; ("t" "day") ; 98
  ; ("t" "most") ; 99
  ; ("t" "us") ; 100

  ; ("tm" "time")
  ; ("g" "good")
  ; ("ipt" "important")

    ("bt" "between")
    ("uns" "understand")
    ("esp" "especially")
    ("comm" "communication")
    ("rsi" "Repetitive Strain Injury")
    ("disc" "discussion")
    ("trad" "traditional")
    ("addr" "address")
    ("dict" "dictionary")
    ("dicts" "dictionaries")
    ("desc" "description")
    ("ty" "thank you")
    ("btw" "by the way")
    ("afaik" "As far as i know")
    ("intro" "introduction")
    ("pls" "please")
    ("atm" "at the moment")
    ("1q" "question")
    ("faq" "frequently asked questions")
    ("i18n" "international")
    ("1org" "organization")
    ("ia" "interactive")
    ("ann" "announcement")
    ("ref" "reference")
    ("1temp" "temperature")
    ("gvn" "government")
    ("1auto" "automatic")
    ("1math" "mathematics")
    ("wtdb" "What's the difference between")
    ("dfb" "difference between")
    ("1dfc" "difference")
    ("1df" "different")
    ("1lib" "library")
    ("1libs" "libraries")
    ("comp" "computer")
    ("l" "language")
    ("1expe" "experience")
    ("1expr" "expression")
    ("techn" "technology")
    ("cs" "computer science")
    ("ai" "artificial intelligence")
    ("fs" "fullscreen")
    ("ss" "screenshot")
    ("vid" "video")

    ("ch" "Chinese")
    ("eng" "English")
    ("jp" "Japanese")

    ;; tech
    ("1e" "emacs")
    ("1so" "StackOverflow")
    ("1ps" "PowerShell")

    ("ipa" "IP address")
    ("wp" "Wikipedia")
    ("ms" "Microsoft")
    ("qt" "QuickTime")
    ("1it" "IntelliType")
    ("win" "window")
    ("ie" "Internet Explorer")
    ("yt" "YouTube")
    ("1g" "Google")
    ("ge" "Google Earth")
    ("gh" "Google Hangout")
    ("gm" "Google Map")
    ("gc" "Google Chrome")
    ("gp" "Google Plus")
    ("gcd" "googlecode")
    ("fx" "Firefox")
    ("sl" "Second Life")
    ("lsl" "Linden Scripting Language")
    ("fb" "Facebook")
    ("ahk" "AutoHotkey")
    ("msvs" "Microsoft Visual Studio")
    ("mma" "Mathematica")
    ("wl" "Wolfram Language")
    ("cl" "Common Lisp")
    ("js" "JavaScript")
    ("cj" "Clojure")
    ("vb" "Visual Basic")
    ("pp" "PayPal")
    ("ahd" "American Heritage Dictionary")
    ("wm" "Window Manager")
    ("1el" "emacs lisp")
    ("1os" "operating system")
    ("1cli" "command line interface")

    ;; for programers
    ("hex" "hexadecimal")
    ("ui" "user interface")
    ("gui" "graphical user interface")
    ("1alt" "alternative")

    ("prof" "professor")
    ("wd" "web development")
    ("dvp" "develop")
    ("dev" "development")
    ("1p" "program")
    ("pl" "programing language")
    ("paren" "parenthesis")
    ("dir" "directory")
    ("dirs" "directories")
    ("subdir" "sub-directory")
    ("subdirs" "sub-directories")
    ("1doc" "documentation")
    ("impl" "implementation")
    ("implt" "implement")
    ("dl" "download")
    ("1c" "character")
    ("1chars" "characters")
    ("1def" "definition")
    ("bg" "background")
    ("kw" "keyword")
    ("kb" "keyboard")
    ("kbs" "keyboards")
    ("kbd" "keybinding")
    ("env" "environment")
    ("1v" "variable")
    ("ver" "version")
    ("1vs" "variables")
    ("1s" "string")
    ("ev" "environment variable")
    ("evs" "environment variables")
    ("1ergo" "ergonomic")
    ("1fp" "functional programing")
    ("1fl" "functional language")
    ("1ca" "cellular automata")
    ("1f" "function")
    ("1pm" "parameter")
    ("1prog" "programing")
    ("1dt" "data type")
    ("1db" "database")
    ("1oop" "object oriented programing")
    ("1lhs" "left-hand-side")
    ("1rhs" "right-hand-side")
    ("1is" "image source")
    ("1md" "metadata")

    ;; emacs lisp
    ("1date" "\\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\\)")
    ("1d" "\\([0-9]+\\)")
    ("1dot" "\\(.\\)")
    ("1str" "\\([^\"]+?\\)")
    ("1curly" "“\\([^”]+?\\)”")
    ("1bracket" "\\[\\([^]]+?\\)\\]")
    ("1tag" "\\([</>=\" A-Za-z0-9]+\\)")
    ("1az" "\\([A-Za-z0-9]+\\)")

    ("1l" "────────── ────────── ────────── ────────── ──────────")
    ("1utf8" "-*- coding: utf-8 -*-")
    ("1ascii" "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")

    ("1php" "<?php\n\n?>")

    
;;; unix shell

  ; rsync -r -v -t --chmod=Dugo+x --chmod=ugo+r --delete --exclude="**/My *" --rsh="ssh -l xah" /media/HP/Users/xah/Documents /media/HP/Users/xah/web /media/HP/Users/xah/Pictures /media/HP/Users/xah/Shared /media/HP/Users/xah/cinse_pixra3 xah@192.168.1.6:~/

  ; rsync -r -v -t --delete --rsh="ssh -l xah" ~/web/ xah@169.254.153.147:~/web/

  ; rsync -r -v -t --delete --exclude="**/My *" --rsh="ssh -l xah" ~/Documents/ xah@169.254.153.147:~/Documents/

  ; unison -servercmd /usr/bin/unison c:/Users/xah/web ssh://xah@169.254.145.104//Users/xah/web
  ; sftp u40651120@s168753655.onlinehome.us
  ;

    
;;; xah personal

    ("lr" "#lang racket")

    ("tla" "<div class=\"¤tla\"><a href=\"url\">text</a></div>")
    ("1menu" "〖a ▸ b ▸ c〗")
    ("1key" "【Alt+f】")
    ("1song" "singer ♪《title》")
    ("1faq" "<div class=\"question-box32371\">
<p class=\"q\">How to do this?</p>
<p>this way</p>
</div>

")

    ("ee" "ErgoEmacs")
    ("eem" "ergoemacs-mode")
    ("xfk" "xah-fly-keys")
    ("vdspc" "Visual Dictionary of Special Plane Curves")
    ("xl" "Xah Lee")
    ("xim" "Twitter: @xah_lee
Facebook: https://www.facebook.com/xahlee
g+: https://plus.google.com/112757647855302148298/posts
Google talk: xahlee@gmail.com
Skype: XahLee
AIM: xahlee
Yahoo: P0lyglut
MSN: p0lyglut@yahoo.com or xahlee
Second Life: Xah Toll
QQ: http://user.qzone.qq.com/2609322939")

    ;; xah url
    ("xs" " Xah Lee
 xahlee@gmail.com
 http://xahlee.org/
 US citizen.
 Mountain View, CA.")

    ("uwe" "http://wordyenglish.com/")
    ("uxa" "http://xaharts.org/")
    ("uxl" "http://xahlee.org/")
    ("uxli" "http://xahlee.info/")
    ("uxm" "http://xahmusic.org/")
    ("uxp" "http://xahporn.org/")
    ("uxsl" "http://xahsl.org/")
    ("uunicode" "http://xahlee.info/comp/unicode_index.html")

    ("utek" "http://xahlee.info/kbd/Truly_Ergonomic_keyboard.html")
    ("uergodox" "http://xahlee.info/kbd/ergodox_keyboard.html")
    ("umaltron" "http://xahlee.info/kbd/Maltron_keyboard.html")
    ("ukinesis" "http://xahlee.info/kbd/keyboard_Kinesis.html")
    ("uutron" "http://xahlee.info/kbd/uTRON_keyboard.html")

    ("uvmm" "http://VirtualMathMuseum.org/")
    ("u3dxm" "http://3D-XplorMath.org/")

    ("uvi" "http://ergoemacs.org/emacs/emergency_vi.html")
    ("uemacs" "http://ergoemacs.org/emacs/emacs.html")
    ("uelisp" "http://ergoemacs.org/emacs/elisp.html")
    ("uahk" "http://xahlee.info/mswin/autohotkey.html")
    ("ueek" "http://ergoemacs.org/emacs/ergonomic_emacs_keybinding.html")
    ("uhtml" "http://xahlee.info/js/html_index.html")
    ("uwd" "http://xahlee.info/js/index.html")
    ("uem" "http://ergoemacs.github.io/")

    ("ulang" "<a href=\"../java-a-day/java.html\">Java</a>
<a href=\"../python/python3_basics.html\">Python</a>
<a href=\"../ruby/ruby_basics.html\">Ruby</a>
<a href=\"../perl-python/perl_basics.html\">Perl</a>
<a href=\"../php/php_basics.html\">PHP</a>
<a href=\"http://ergoemacs.org/emacs/elisp.html\">Emacs Lisp</a>")

    ("uapache" "http://xahlee.info/linux/apache_tutorial.html")
    ("uperl" "http://xahlee.info/perl-python/perl_basics.html")
    ("upython" "http://xahlee.info/python/python3_basics.html")
    ("uruby" "http://xahlee.info/ruby/ruby_basics.html")
    ("ujs" "http://xahlee.info/js/javascript_basics.html")
    ("uphp" "http://xahlee.info/php/php_basics.html")
    ("ucss" "http://xahlee.info/js/css_index.html")
    ("udvorak" "http://xahlee.info/comp/dvorak_keyboard_layout.html")

    ("ute" "http://xahlee.info/kbd/Truly_Ergonomic_keyboard.html")

    ("uocaml" "http://xahlee.info/ocaml/ocaml.html")
    ("ups" "http://xahlee.info/powershell/index.html")
    ("umma" "http://xahlee.info/M/index.html")
    ("ujava" "http://xahlee.info/java-a-day/java.html")
    ("utg" "http://xahlee.info/UnixResource_dir/writ/tech_geeker.html")

  ;

    ))

;; 
;; ;;; stop asking whether to save newly added abbrev when quitting emacs
(setq save-abbrevs nil)

