(setq gc-cons-threshold most-positive-fixnum)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t)
 '(package-selected-packages
   '(go-mode age restclient paren-face haskell-mode rfc-mode nasm-mode yaml-mode org-tree-slide sly gemini-mode ement shr-tag-pre-highlight rainbow-mode nix-mode htmlize doom-modeline nyan-mode benchmark-init webfeeder elpher use-package indent-guide nim-mode zenburn-theme valign fzf go-translate expand-region selectric-mode clippy catppuccin-theme pyim web-mode elfeed-org elfeed undo-tree smart-hungry-delete magit evil-mc neotree all-the-icons rust-mode nord-theme company markdown-mode elixir-mode racket-mode evil))
 '(warning-suppress-types '((comp))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; =================== ;;
;; Graphical Interface ;;
;; =================== ;;
;;;ifdef dump
(tool-bar-mode               -1)
(menu-bar-mode               -1)
(toggle-scroll-bar          nil)
(column-number-mode           t)
(setq inhibit-startup-message t)

;(add-to-list 'default-frame-alist '(width . 80))
;(add-to-list 'default-frame-alist '(height . 40))

;; theme-start
;(set-frame-font "-ADBO-Source Code Pro-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;(set-frame-font "-JB-JetBrains Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
;;;ifdef excl
(set-frame-font "-JB-JetBrainsMono Nerd Font Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
;;;endif excl
;;;endif dump

(setq catppuccin-flavor 'latte)
(if (display-graphic-p)
    (progn ;(load-theme 'zenburn t)  ; seems I'm using the same theme as tsoding
;;;ifdef excl
           (add-to-list 'custom-theme-load-path "~/.emacs.d/everforest")
           (load-theme 'everforest-hard-dark t)
;;;endif excl
           )
  (progn
    (load-theme 'zenburn t)
    (custom-set-faces
     '(default ((t (:background "unspecified-bg" :foreground "#eeeeec")))))))
;; theme-end

;; set transparent effect (29)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; native smooth scrolling (29)
(pixel-scroll-precision-mode)
;; normally it is for touchpad, enable for mouse:
(setq pixel-scroll-precision-large-scroll-height 40.0)

;; manually do the gcmh https://akrl.sdf.org
(setq normal-gc-threshold 6400000)
(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))
(run-with-idle-timer 30 t
                     (lambda ()
                       (message "gcmh: %.04fsec"
                                (k-time (garbage-collect)))))



;; =============== ;;
;; package manager ;;
;; =============== ;;
(setq package-archives'(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                        ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
;(package-initialize) ;; (29) seems don't need, and dump will crash
(setq use-package-verbose t)

(defmacro setup-what-pkg (what)
  ;; https://liujiacai.net/blog/2021/05/05/emacs-package
  `(progn
     (when (not package-archive-contents)
       (package-refresh-contents))
     (dolist (p ,what)
       (when (not (package-installed-p p))
         (package-install p)))))

(defun setup-full-pkg () (interactive) (setup-what-pkg package-selected-packages))


;; ====== ;;
;; custom ;;
;; ====== ;;
(setq make-backup-files nil
      auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))

(setq-default tab-width 4
              c-basic-offset 4
              indent-tabs-mode nil)    ; must be setq-default
(setq backward-delete-char-untabify-method 'hungry)

;;;ifdef dump
(setq display-line-numbers-type 'relative)    ; relative number, make d d easier
;;;endif dump
(global-display-line-numbers-mode)

(setq epa-file-cache-passphrase-for-symmetric-encryption t
      epg-pinentry-mode 'loopback)    ; use minibuffer instead of popup

(defalias 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(ido-mode t)
(electric-pair-mode t)

(setq shr-use-fonts nil)



;; ========= ;;
;; functions ;;
;; ========= ;;
(defun animate-text (text)
  ;; https://github.com/matrixj/405647498.github.com/blob/gh-pages/src/emacs/emacs-fun.org
  (interactive "stext: ")  ; s means read-string
  (switch-to-buffer (get-buffer-create "*butterfly*"))
  (erase-buffer)
  (animate-string text 10))

(defun highlight-custom ()
  (interactive)
  (defface todo
    '((((background dark))  :foreground "#66CCFF" :bold t))
    "highlight todo"
    :group 'basic-faces)
  (defface ctf
    '((((background dark))  :foreground "#39C5BB" :bold t))
    "highlight ctf mark"
    :group 'basic-faces)
  (highlight-regexp " TODO\\| BUG\\|todo!" 'todo)
  (highlight-regexp "<%=\\|%>"             'todo)
  (highlight-regexp " CTF"                 'ctf))

(defun highlight-custum-enable ()
  (interactive)
  (add-hook 'post-command-hook 'highlight-custom))

(defun bili ($from $to)
  ;; well, I always report those fucking video thieves on bilibili,
  ;; so this tool is helpful, for filter out BVid from link
  ;; http://xahlee.info/emacs/emacs/elisp_command_working_on_string_or_region.html
  (interactive "r")
  (let (inputStr outputStr)
    (setq inputStr (buffer-substring-no-properties $from $to))
    (setq outputStr
          (replace-regexp-in-string "?spm_id_from=[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+" ""
                                    (replace-regexp-in-string "https://www.bilibili.com/video/" "" inputStr)))
    (save-excursion
      (delete-region $from $to)
      (goto-char $from)
      (insert outputStr))))

(defun convert-punctuation ($from $to)
  ;; convert Chinese pubctuation to normal
  ;; http://xahlee.info/emacs/emacs/emacs_zap_gremlins.html
  (interactive "r")
  (let (($charMap
    [
     ["，" ", "] ["。" ". "]
     ["？" "? "] ["！" "! "]
     ["：" ": "] ["；" "; "]
     ["（" "("]  ["）" ")"]
     ["【" "["]  ["】" "]"]
     ["‘" "'"]   ["’" "'"]
     ["“" "\""]  ["”" "\""]
     ]))
    (save-restriction
      (narrow-to-region $from $to)
      (mapc
       (lambda ($pair)
         (goto-char (point-min))
         (while (re-search-forward (elt $pair 0) (point-max) t)
           (replace-match (elt $pair 1))))
       $charMap))))

(defun switch-browser ()
  (interactive)
  (if (eq browse-url-browser-function 'eww-browse-url)
      (progn
        (setq browse-url-browser-function 'browse-url-firefox)
        (message "browser switched to firefox"))
    (progn
      (setq browse-url-browser-function 'eww-browse-url)
      (message "browser switched to eww"))))

(defun proxy ()
  (interactive)
  (if (eq url-proxy-services nil)
      (setq url-proxy-services '(("http"  . "127.0.0.1:20172")
                                 ("https" . "127.0.0.1:20172")))
    (progn
      (setq url-proxy-services nil)
      (message "no proxy"))))

(defun toggle-shr-hl ()
  (interactive)
  (if shr-external-rendering-functions
      (setq shr-external-rendering-functions nil)
    (progn
      (add-to-list 'shr-external-rendering-functions
                   '(pre . shr-tag-pre-highlight))
      (message "on"))))

(defun gc-change-threshold ()
  ;; for some crazy usage
  (interactive)
  (if (eq gc-cons-threshold normal-gc-threshold)
      (progn (setq gc-cons-threshold #x40000000) (message "big"))
  (setq gc-cons-threshold normal-gc-threshold)))



;; =========== ;;
;; use-package ;;
;; =========== ;;
(use-package evil
  :ensure t
  :init
  ;; https://emacstalk.codeberg.page/post/025/
  (setq evil-want-C-i-jump nil)
  (setq evil-undo-system 'undo-tree)
  (evil-mode 1)
  :bind
  ("C-r" . isearch-backward))

(use-package evil-mc
  :defer 1
  :config
  ;; don't need to bind "I" and "A"
  ;; because VIM aalready can do this, it only execute after esc and don't need to "grq"
  (global-evil-mc-mode 1))

(use-package org
  :defer t
  ;; to make tags aligned:
  ;; * https://emacs-china.org/t/org-mode-tag/22291
  ;; ** https://list.orgmode.org/87lfh745ch.fsf@localhost/T/
  ;; but it looks not satisfying and add a bit of lag, so I don't use it
  :init
  (require 'org-crypt)
  (org-crypt-use-before-save-magic)
  (setq org-tags-exclude-from-inheritance '("crypt"))
  (setq org-crypt-key "2394861A728929E3755D8FFADB55889E730F5B41")
  :config
;;;ifdef dump
  (setq org-startup-indented t
        org-src-preserve-indentation t
        org-startup-with-inline-images t
        ;; org-display-remote-inline-images only works for trump
        org-return-follows-link t  ; in insert mode
        org-catch-invisible-edits 'show)
;;;endif dump
  (setq-local browse-url-browser-function 'eww-browse-url)

  (add-to-list 'org-export-backends 'md)
  ;; https://d12frosted.io/posts/2017-07-30-block-templates-in-org-mode.html
  (setq org-structure-template-alist
   '(("c" . "CENTER")
     ("C" . "COMMENT")
     ("e" . "EXAMPLE")
     ("E" . "EXPORT")
     ("q" . "QUOTE")
     ("s" . "SRC")
     ("v" . "VERSE")))

  (defmacro my/orgurl (proto)
    `(org-link-set-parameters ,proto
                             :follow #'elpher-browse-url-elpher
                             :export
                             (lambda (link description format _)
                               (let ((url (format "%s:%s" ,proto link)))
                                 (format "<a href=\"%s\">%s</a>" url (or description url))))))
  (my/orgurl "gopher")
  (my/orgurl "gemini"))

(use-package expand-region
  ;; something like wildfire.vim
  :after evil-mc
  :config
  ;; can't use :bind
  (global-set-key (kbd "C-<return>") 'er/expand-region))

(use-package neotree
  :init
  (global-set-key [(f3)] 'neotree-toggle)
  :defer t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons))
  ;; without this evil mode will conflict with neotree
  ;; ref: https://www.emacswiki.org/emacs/NeoTree
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "<return>") 'neotree-enter))

(use-package smart-hungry-delete
  :if window-system ; in terminal the key just don't work
  :defer 1
  :bind
  ("C-<backspace>" . 'smart-hungry-delete-backward-char))

(use-package undo-tree
  :defer 1
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history nil))

(use-package company
  :if window-system
  :defer 1
  :config
  (setq company-dabbrev-ignore-case nil)
  (setq company-global-modes '(not erc-mode gud-mode))
  (global-company-mode))

(use-package valign
  :commands (valign--space valign--put-overlay)  ; autoload
  :hook (org-mode . valign-mode))

(use-package gud
  :defer t
  :config
  (setq gdb-many-windows t)
  (defalias 'disas 'gdb-display-disassembly-buffer)
  (tool-bar-mode t))

(use-package pyim
  :init
  (setq default-input-method "pyim")
  (setq pyim-punctuation-translate-p '(no yes auto)) ; must be 3-long
  :config
  (setq pyim-page-tooltip 'minibuffer)
  (setq pyim-cloudim 'google)  ; I hate baidu
  (setq pyim-dicts
        '((:name "tsinghua" :file "~/.emacs.d/pyim-tsinghua-dict/pyim-tsinghua-dict.pyim")))
  (add-hook 'pyim-activate-hook   (lambda () (setq gc-cons-threshold (* normal-gc-threshold 10))))
  (add-hook 'pyim-deactivate-hook (lambda () (setq gc-cons-threshold normal-gc-threshold)))
  :bind
  ("C-|" . pyim-punctuation-toggle))

(use-package clippy
  ;; also from DistroTube
  :if window-system
  :bind
  (("C-x c v" . clippy-describe-variable)
   ("C-x c f" . clippy-describe-function)))

(use-package go-translate
  :bind
  ("C-x M-t" . gts-do-translate)
  :config
  (setq gts-translate-list '(("en" "zh")))
  (setq gts-default-translator
        (gts-translator
         :picker (gts-prompt-picker :texter (gts-current-or-selection-texter) :single t)
         :engines (list (gts-bing-engine))
         :render (gts-buffer-render))))

(use-package fzf
  ;; hacker news: How FZF and ripgrep improved my workflow
  ;; https://news.ycombinator.com/item?id=20360204
  :defer t
  :config
  (setenv "FZF_DEFAULT_COMMAND" "rg --files --hidden"))

(use-package indent-guide
  :defer 1
  :config
  (indent-guide-global-mode))

(use-package nyan-mode
  :if window-system
  :defer 1
  :config
  (nyan-mode)
  (nyan-start-animation))

(use-package rainbow-mode
  :defer 1
  :config
  (setq rainbow-x-colors nil
        rainbow-r-colors nil
        rainbow-html-colors nil))

;;;ifdef excl
(use-package doom-modeline
  ;; if the icons go wrong, try nerd-icons-install-fonts
  :config
  (doom-modeline-mode))
;;;endif excl

(use-package rfc-mode
  :defer t
  :config
  (setq rfc-mode-directory (expand-file-name "~/.emacs.d/rfc/")))

(use-package paren-face
  :config
  (global-paren-face-mode 1))

;; ===================== ;;
;; use-package/languages ;;
;; ===================== ;;
(use-package cc-mode
  :defer t
  :init
  (defun bsd-c-style ()
    (interactive)
    (setq c-mode-hook
          (lambda ()
            (setq-local tab-width 8)
            (indent-tabs-mode t)))) ; per-buffer setting, won't mess up other buffer
  :config
  (setq c-default-style '((c-mode    . "bsd")
                          (java-mode . "java")
                          (awk-mode  . "awk")
                          (other     . "gnu"))))

(use-package web-mode
  ;; https://web-mode.org/
  :mode "\\.eex\\'"
  :mode "\\.html\\'"
  :mode "\\.xml\\'" ; when editing https://dongdigua.github.io/anaconda_kickstart
  :config
  (setq web-mode-markup-indent-offset 2))

(use-package rust-mode
  :config
  (defun rust-t (fun)
    (interactive "sfun: ")
    (rust--compile "%s test -- --nocapture %s" rust-cargo-bin fun))
  :bind
  ("C-c C-c c" . rust-compile))

(use-package nim-mode
  :defer t
  :config
  (setq nim-compile-default-command '("c" "-r" "--excessiveStackTrace:on" "--debuginfo:on" "--cc:clang")))

(use-package gemini-mode
  :defer t
  :config
  (defun my/gemini-open-link-at-point ()
    "modified version of the original function"
    (interactive) ; vital for :map
    (let ((link (gemini-link-at-point)))
      (when link
        (cond ((string-prefix-p "gemini://" link t)
               (elpher-go link))
              ((string-prefix-p "gopher://" link t)
               (elpher-go link))
              ((file-exists-p link)
               (find-file link))
              ((string-match "https?://" link)
               (browse-url link))
              (t (error "gemini-mode: invalid link %s" link))))))
  (setq whitespace-style '(face lines-char))
  :hook
  ;; normally add whitespace-mode doesn't work, this is a per-buffer setting
  (gemini-mode . whitespace-mode)
  :bind
  (:map gemini-mode-map ("C-c C-o" . #'my/gemini-open-link-at-point)))

(use-package sly
  :defer t
  :config
  (setq inferior-lisp-program "sbcl")
  (setq sly-mrepl-history-file-name ""))

(use-package flycheck
  :defer t
  :init
  (setq flycheck-global-modes '(rust-mode)))

(use-package nasm-mode
  ;; https://vishnudevtj.github.io/notes/assembly-in-emacs
  :hook (asm-mode-hook nasm-mode))

(use-package go-mode
  :defer t
  :config
  (setq-local tab-width 4)
  (indent-tabs-mode t)
  (setq whitespace-style '(face tabs tab-mark)) ; setq-local won't work
  :hook
  (go-mode . whitespace-mode))

;; ==================== ;;
;; use-package/internet ;;
;; ==================== ;;
(use-package elfeed
  :defer t
  :config
  (elfeed-org)
  (setq-local browse-url-browser-function 'browse-url-firefox)
  (setq elfeed-use-curl t)
  (setq elfeed-curl-extra-arguments '("--proxy" "http://127.0.0.1:20172"))
  (elfeed-search-set-filter "@2-weeks-ago -cve -weixin")
  (unbind-key "v" shr-map) ; for copying url
  ;; (custom-set-faces
  ;;  '(elfeed-search-date-face ((t (:foreground "#8fbcbb"))))
  ;;  '(elfeed-search-feed-face ((t (:foreground "#ebcb8b"))))
  ;;  '(elfeed-search-tag-face  ((t (:foreground "#66ccff")))))

  ;; https://github.com/skeeto/elfeed/issues/404
  ;; https://github.com/chuxubank/cat-emacs/blob/main/cats/+elfeed.el
  (when (functionp #'valign--put-overlay)
    (defun elfeed-search-print-valigned-entry (entry)
      "Print valign-ed ENTRY to the buffer."
      (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
             (date-width (car (cdr elfeed-search-date-format)))
             (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
             (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
             (feed (elfeed-entry-feed entry))
             (feed-title (when feed (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
             (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
             (tags-str (mapconcat (lambda (s) (propertize s 'face 'elfeed-search-tag-face)) tags ","))
             (title-width (- (window-width) 10 elfeed-search-trailing-width))
             (title-column (elfeed-format-column
                            title (elfeed-clamp elfeed-search-title-min-width title-width elfeed-search-title-max-width)
                            :left))
             (align-to (* (+ date-width 2 (min title-width elfeed-search-title-max-width)) (default-font-width))))
        (insert (propertize date 'face 'elfeed-search-date-face) " ")
        (insert (propertize title-column 'face title-faces 'kbd-help title) " ")
        (valign--put-overlay (1- (point)) (point) 'display (valign--space align-to))
        (when feed-title (insert (propertize feed-title 'face 'elfeed-search-feed-face) " "))
        (when tags (insert "(" tags-str ")"))))
    (setq elfeed-search-print-entry-function #'elfeed-search-print-valigned-entry)))

(use-package elfeed-org
  :defer t
  :after elfeed
  :config
  (setq rmh-elfeed-org-files '("~/org/elfeed.org")))

(use-package erc
  ;; sasl support! (29)
  :defer t
  :init
  (defun erc-connect ()
      (interactive)
      (erc-tls :server "irc.libera.chat" :port 6697
               :nick "dongdigua"
               :user "dongdigua"))
  
  :config
;;ifdef dump
  (setq erc-modules
        ;; customize and copy to here
        '(button completion fill irccontrols log match menu move-to-prompt netsplit networks noncommands notifications readonly ring sasl stamp track truncate))
;;endif dump
  (erc-update-modules)
  (setq erc-log-channels-directory "~/.emacs.d/erc-log"))

(use-package eww
  :init
;;;ifdef dump
  (setq browse-url-handlers
        '( ; use alist in browse-url-browser-function is deprecated
          ("^https?://youtu\\.be"            . browse-url-firefox)
          ("^https?://.*youtube\\..+"        . browse-url-firefox)
          ("^https?://.*bilibili\\.com"      . browse-url-firefox)
          ("^https?://.*zhihu\\.com"         . browse-url-firefox)
          ("^https?://.*reddit\\.com"        . browse-url-firefox)
          ("^https?://.*github\\.com"        . browse-url-firefox)
          ("^https?://.*stackoverflow\\.com" . browse-url-firefox)
          ("^https?://.*stackexchange\\.com" . browse-url-firefox)
          ("^https?://t\\.co"                . browse-url-firefox)
          ("^http://phrack\\.org"            . eww-browse-no-pre-hl)
          ("gopher://.*"                     . elpher-browse-url-elpher)
          ("gemini://.*"                     . elpher-browse-url-elpher)
          ))
;;;endif dump
  :defer t
  :config
  (defun eww-browse-no-pre-hl (url &optional new-window)
    (eww-browse-url url new-window)
    (setq-local shr-external-rendering-functions nil))
  (evil-define-key 'normal eww-mode-map (kbd "^") 'eww-back-url) ; like elpher
  (evil-define-key 'normal eww-mode-map (kbd "C") 'eww-copy-page-url) ; like elpher
  (evil-define-key 'normal eww-mode-map (kbd "&") 'eww-browse-with-external-browser))

(use-package elpher
  :defer t
  :config
  ;; I usually fire up a local agate server to test my content
  (setq elpher-default-url-type "gemini"))

(use-package shr-tag-pre-highlight
  ;; render code block in eww
  :defer t
  :after shr
  :config
  (add-to-list 'shr-external-rendering-functions
               '(pre . shr-tag-pre-highlight)))

(use-package ement
  :defer t
  :config
  (setq plz-curl-default-args
        '("--proxy" "http://127.0.0.1:20172" "--silent" "--compressed" "--location" "--dump-header" "-")))



;; =========== ;;
;; end of init ;;
;; =========== ;;
(setq initial-scratch-message
      (concat
       (emacs-init-time ";; %2.4f secs, ")
       (format "%d gcs\n" gcs-done)
       (button-buttonize ";; (config)" (lambda (_) (find-file-existing "~/.emacs")))
       "\n"
       (button-buttonize ";; (collections)" (lambda (_) (find-file-existing "~/git/dongdigua.github.io/org/internet_collections.org")))
       "\n"
       (button-buttonize ";; (YW)" (lambda (_) (dired "~/git/digua-YW")))
       "\n"
       ))

(setq gc-cons-threshold normal-gc-threshold)
