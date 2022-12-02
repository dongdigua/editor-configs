(setq gc-cons-threshold (* 64 1024 1024))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t)
 '(package-selected-packages
   '(org-tree-slide org2blog rg sly gemini-mode ement shr-tag-pre-highlight rainbow-mode nix-mode htmlize doom-modeline nyan-mode benchmark-init webfeeder elpher use-package indent-guide nim-mode zenburn-theme valign fzf go-translate expand-region circe selectric-mode clippy beacon catppuccin-theme pyim web-mode elfeed-org elfeed undo-tree smart-hungry-delete magit evil-mc neotree all-the-icons dashboard rust-mode nord-theme company markdown-mode elixir-mode racket-mode evil))
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
(tool-bar-mode               -1) ; 关闭 Tool bar
(menu-bar-mode               -1) ; should use -1 instead of nil
(toggle-scroll-bar          nil) ; 关闭滚动条
(column-number-mode           t) ; 在 Mode line 上显示列号
(global-auto-revert-mode      t) ; 让 Emacs 及时刷新 Buffer
(setq inhibit-startup-message t) ; 关闭启动 Emacs 时的欢迎界面

;(add-to-list 'default-frame-alist '(width . 80))  ; 设定启动图形界面时的Frame宽度
;(add-to-list 'default-frame-alist '(height . 40)) ; 设定启动图形界面时的Frame高度

;(set-frame-font "-ADBO-Source Code Pro-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;(set-frame-font "-JB-JetBrains Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
(set-frame-font "-JB-JetBrainsMono Nerd Font Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")

(if (display-graphic-p)
    (progn ;(load-theme 'zenburn t)  ; seems I'm using the same theme as tsoding
           (add-to-list 'custom-theme-load-path "~/.emacs.d/everforest")
           (load-theme 'everforest-hard-dark t)
           )
  (progn
    (load-theme 'tango-dark t)
    (custom-set-faces
     '(default ((t (:background "unspecified-bg" :foreground "#eeeeec")))))))

;; set transparent effect
;; 其中前一个指定当 Emacs 在使用中时的透明度, 而后一个则指定其它应用在使用中时 Emacs 的透明度
(setq alpha-list '((90 80) (100 100) (70 40)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab))))
     (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))))



;; =============== ;;
;; package manager ;;
;; =============== ;;
(require 'package)
(setq package-archives'(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                        ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
(package-initialize)



;; ====== ;;
;; custom ;;
;; ====== ;;
(setq make-backup-files nil
      auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))

(setq-default tab-width 4
              indent-tabs-mode nil)    ; must be setq-default
(setq backward-delete-char-untabify-method 'hungry)

(setq display-line-numbers-type 'relative)    ; relative number, make d d easier
(global-display-line-numbers-mode)

(global-set-key [(f8)] 'loop-alpha)
(global-set-key [(f3)] 'neotree-toggle)
(add-hook 'after-init-hook 'loop-alpha)

(setq epa-file-cache-passphrase-for-symmetric-encryption t
      epg-pinentry-mode 'loopback)    ; use minibuffer instead of popup

(defalias 'yes-or-no-p 'y-or-n-p)
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

(defun lambda-copy ()
  ;; https://caiorss.github.io/Emacs-Elisp-Programming/Elisp_Snippets.html#sec-1-5
  (interactive)
  (with-temp-buffer
    (insert "λ")
    (clipboard-kill-region (point-min) (point-max))))

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
(add-hook 'post-command-hook 'highlight-custom)

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

(defun toggle-proxy ()
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



;; =========== ;;
;; use-package ;;
;; =========== ;;
(use-package evil
  :init
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
  ;; to make tags aligned:
  ;; * https://emacs-china.org/t/org-mode-tag/22291
  ;; ** https://list.orgmode.org/87lfh745ch.fsf@localhost/T/
  ;; but it looks not satisfying and add a bit of lag, so I don't use it
  :config
  (setq org-startup-indented t
        org-startup-with-inline-images t
        ;; org-display-remote-inline-images only works for trump
        org-return-follows-link t  ; in insert mode
        browse-url-browser-function 'eww-browse-url)

  (setq org-catch-invisible-edits 'show)
  
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

  (evil-define-key 'normal org-mode-map [tab] 'org-cycle)

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
  :defer t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons))
  ;; without this evil mode will conflict with neotree
  ;; ref: https://www.emacswiki.org/emacs/NeoTree
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "<return>") 'neotree-enter))

(use-package dashboard
  :if (and window-system (not (getenv "NO_DASHBOARD")))
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        ;; https://github.com/snackon/Witchmacs/blob/master/marivector.png
        dashboard-banner-logo-png "~/.emacs.d/marisa.png"
        dashboard-image-banner-max-width 256
        dashboard-image-banner-max-hight 256)
  (setq dashboard-items '((recents . 7)
                          (bookmarks . 5)
                          (agenda . 3)))
  (setq org-agenda-files '("~/org/TODO.org"))
  (setq dashboard-set-heading-icons t
        dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "董地瓜@bilibili"))

(use-package smart-hungry-delete
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
  :defer 2
  :config
  (global-company-mode))

(use-package valign
  :commands (valign--space valign--put-overlay)  ; autoload
  :hook (org-mode . valign-mode))

(use-package gud
  :defer t
  :config
  (setq gdb-many-windows t)
  (defalias 'dasm 'gdb-display-disassembly-buffer)
  (tool-bar-mode t))

(use-package pyim
  :init
  (setq default-input-method "pyim")
  :config
  (setq pyim-page-tooltip 'minibuffer)
  (setq pyim-cloudim 'google)  ; I hate baidu
  (setq pyim-dicts
        '((:name "tsinghua" :file "~/git/pyim-tsinghua-dict/pyim-tsinghua-dict.pyim")))
  (setq-default pyim-punctuation-translate-p '(no yes))
  :bind
  ("C-|" . pyim-punctuation-toggle))

(use-package beacon
  ;; from DistroTube
  :if window-system
  :config
  (beacon-mode 1))

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
  :config
  (setenv "FZF_DEFAULT_COMMAND" "rg --files --hidden"))

(use-package indent-guide
  :defer 2
  :config
  (indent-guide-global-mode))

(use-package nyan-mode
  :if window-system
  :defer 1
  :config
  (nyan-mode)
  (nyan-start-animation))

(use-package rainbow-mode
  :config
  (setq rainbow-x-colors nil
        rainbow-r-colors nil
        rainbow-html-colors nil))

(use-package doom-modeline
  :config
  (doom-modeline-mode))

;; ===================== ;;
;; use-package/languages ;;
;; ===================== ;;
(use-package web-mode
  ;; https://web-mode.org/
  :config
  (setq web-mode-markup-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.eex\\'"  . web-mode))
  ;; the default html mode sucks
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode)))

(use-package rust-mode
  :bind
  ("C-c C-c c" . rust-compile))

(use-package nim-mode
  :config
  (setq nim-compile-default-command '("c" "-r" "--excessiveStackTrace:on" "--debuginfo:on" "--cc:clang")))

(use-package gemini-mode
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
  :bind
  (:map gemini-mode-map ("C-c C-o" . #'my/gemini-open-link-at-point)))

(use-package sly
  :config
  (setq inferior-lisp-program "sbcl"))

(use-package flycheck
  :config
  (setq flycheck-global-modes '(rust-mode)))

;; ==================== ;;
;; use-package/internet ;;
;; ==================== ;;
(use-package elfeed
  :defer t
  :config
  (elfeed-org)
  (setq browse-url-browser-function 'browse-url-firefox)
  (setq elfeed-use-curl t)
  (setq elfeed-curl-extra-arguments '("--proxy" "http://127.0.0.1:20172"))
  (elfeed-search-set-filter "@2-weeks-ago -cve -weixin")
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

(use-package circe
  ;; well I don't want to learn keybindings for other irc clients like weechat
  ;; both erc and rcirc can't use sasl properly
  ;; https://lists.gnu.org/archive/html/emacs-devel/2021-06/msg00876.html
  :defer t
  :config
  (defun irc-password (server)
    (read-passwd "password for irc: "))
  (setq circe-network-options
        '(("libera"
           :host "irc.libera.chat"
           :port 6697
           :tls t
           :sasl-username "dongdigua"
           :sasl-password irc-password
           :reduce-lurker-spam t)))
  (company-mode nil))

(use-package eww
  :init
  (setq browse-url-handlers
        '( ; use alist in browse-url-browser-function is deprecated
          ("^https?://youtu\\.be"            . browse-url-firefox)
          ("^https?://.*youtube\\..+"        . browse-url-firefox)
          ("^https?://.*bilibili\\.com"      . browse-url-firefox)
          ("^https?://.*reddit\\.com"        . browse-url-firefox)
          ("^https?://github\\.com"          . browse-url-firefox)
          ("^https?://.*stackoverflow\\.com" . browse-url-firefox)
          ("^https?://.*stackexchange\\.com" . browse-url-firefox)
          ("^https?://t\\.co"                . browse-url-firefox)
          ("^http://phrack\\.org"            . eww-browse-no-pre-hl)
          ("gopher://.*"                     . elpher-browse-url-elpher)
          ("gemini://.*"                     . elpher-browse-url-elpher)
          ))
  :config
  (defun eww-browse-no-pre-hl (url &optional new-window)
    (eww-browse-url url new-window)
    (setq-local shr-external-rendering-functions nil))
  (evil-define-key 'normal eww-mode-map (kbd "^") 'eww-back-url) ; like elpher
  (evil-define-key 'normal eww-mode-map (kbd "C") 'eww-copy-page-url) ; like elpher
  (evil-define-key 'normal eww-mode-map (kbd "&") 'eww-browse-with-external-browser))

(use-package shr-tag-pre-highlight
  ;; render code block in eww
  :after shr
  :config
  (add-to-list 'shr-external-rendering-functions
               '(pre . shr-tag-pre-highlight)))

(use-package ement
  :config
  (setq plz-curl-default-args
        '("--proxy" "http://127.0.0.1:20172" "--silent" "--compressed" "--location" "--dump-header" "-")))

(use-package gnus
  :defer t
  :config
  (setq gnus-select-method '(nntp "news.tilde.club")))



;; =========== ;;
;; end of init ;;
;; =========== ;;
(setq initial-scratch-message
      (concat
       (emacs-init-time ";; %2.4f secs\n")
       (button-buttonize ";; (config)" (lambda (_) (find-file-existing "~/.emacs")))
       "\n"
       (button-buttonize ";; (collections)" (lambda (_) (find-file-existing "~/git/dongdigua.github.io/org/internet_collections.org")))
       "\n"
       (button-buttonize ";; (quote)" (lambda (_) (find-file-existing "~/git/dongdigua.github.io/js/random-quote.js")))
       "\n"
       (button-buttonize ";; (YW)" (lambda (_) (dired "~/git/digua-YW")))
       "\n"
       ))

(setq gc-cons-threshold (* 8 1024 1024))
