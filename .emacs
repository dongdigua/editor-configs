(setq gc-cons-threshold (* 64 1024 1024))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("950b1e8c8cd4a32b30cadc9d8b0eb6045538f0093dad8bdc1c24aaeeb64ed43d" "0d2882cc7dbb37de573f14fdf53472bcfb4ec76e3d2f20c9a93a7b2fe1677bf5" default))
 '(package-selected-packages
   '(use-package indent-guide nim-mode zenburn-theme valign fzf go-translate expand-region circe selectric-mode clippy beacon catppuccin-theme pyim web-mode elfeed-org elfeed undo-tree smart-hungry-delete magit esup evil-mc neotree all-the-icons dashboard rust-mode nord-theme company markdown-mode elixir-mode racket-mode evil)))

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
    (progn (load-theme 'zenburn t)  ; seems I'm using the same theme as tsoding
           ;(add-to-list 'custom-theme-load-path "~/.emacs.d/everforest")
           ;(load-theme 'everforest-hard-dark t)
           )
  (progn
    (set-frame-parameter (selected-frame) 'alpha '(85 85))
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
(setq make-backup-files nil)
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)    ; must be setq-default
(setq backward-delete-char-untabify-method 'hungry)

(setq display-line-numbers-type 'relative)    ; relative number, make d d easier
(global-display-line-numbers-mode)
(setq org-startup-indented t)

(global-set-key [(f8)] 'loop-alpha)
(global-set-key [(f3)] 'neotree-toggle)
(add-hook 'after-init-hook 'loop-alpha)

(setq epa-file-cache-passphrase-for-symmetric-encryption t)
(setq epg-pinentry-mode 'loopback)    ; use minibuffer instead of popup

(defalias 'yes-or-no-p 'y-or-n-p)
(ido-mode t)
(electric-pair-mode t)
(setq shr-use-fonts nil)  ; https://github.com/skeeto/elfeed/issues/318

;; erc-sasl and tetris(fedora don't ship tetris)
(add-to-list 'load-path "~/.emacs.d/lisp/")



;; ========= ;;
;; functions ;;
;; ========= ;;
(defun animate-text (text)
  ;; https://github.com/matrixj/405647498.github.com/blob/gh-pages/src/emacs/emacs-fun.org
  (interactive "stext: ")  ; s means read-string
  (switch-to-buffer (get-buffer-create "*butterfly*"))
  (erase-buffer)
  (animate-string text 10))

(defun minecraft ()
  (interactive)
  (start-process-shell-command "" "*scratch*"
                               "cd ~/minecraft; java -jar HMCL*.jar"))

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
  (highlight-regexp "// TODO\\|// BUG\\|todo!" 'todo)
  (highlight-regexp "<%=\\|%>"                 'todo)
  (highlight-regexp "// CTF"                   'ctf))
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



;; =========== ;;
;; use-package ;;
;; =========== ;;
;; https://phenix3443.github.io/notebook/emacs/modes/use-package-manual.html
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

(use-package expand-region
  ;; something like wildfire.vim
  :after evil-mc
  :config
  (global-set-key (kbd "C-<return>") 'er/expand-region))

(use-package neotree
  :defer t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons))
  ;; without this evil mode will conflict with neotree
  ;; ref: https://www.emacswiki.org/emacs/NeoTree
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle))

(use-package dashboard
  :if window-system
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents . 7)
                          (bookmarks . 5)
                          (agenda . 3)))
  (setq org-agenda-files '("~/org/TODO.org"))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "董地瓜@bilibili")
  (setq dashboard-set-navigator t))

(use-package smart-hungry-delete
  :defer 1
  :config
  (global-set-key (kbd "C-<backspace>")
                  'smart-hungry-delete-backward-char))

(use-package undo-tree
  :defer 1
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history nil))

(use-package company
  :defer 2
  :config
  (global-company-mode))

(use-package valign
  :commands (valign--space valign--put-overlay)  ; autoload
  :hook (org-mode . valign-mode))

(use-package elfeed
  :defer t
  :config
  (elfeed-org)
  (setq elfeed-use-curl t)
  (setq elfeed-curl-extra-arguments '("--proxy" "http://127.0.0.1:20172"))
  (elfeed-search-set-filter "@2-weeks-ago")
  (custom-set-faces
   '(elfeed-search-date-face ((t (:foreground "#8fbcbb"))))
   '(elfeed-search-feed-face ((t (:foreground "#ebcb8b"))))
   '(elfeed-search-tag-face  ((t (:foreground "#66ccff")))))

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
             (tags-str (mapconcat
                        (lambda (s) (propertize s 'face 'elfeed-search-tag-face))
                        tags ","))
             (title-width (- (window-width) 10 elfeed-search-trailing-width))
             (title-column (elfeed-format-column
                            title (elfeed-clamp
                                   elfeed-search-title-min-width
                                   title-width
                                   elfeed-search-title-max-width)
                            :left))
             (align-to (* (+ date-width 2 (min title-width elfeed-search-title-max-width))
                          (default-font-width))))
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

(use-package gud
  :defer t
  :config
  (setq gdb-many-windows t)
  (defalias 'dasm 'gdb-display-disassembly-buffer)
  (tool-bar-mode t))

(use-package pyim
  :config
  (setq default-input-method "pyim")
  (setq pyim-page-tooltip 'minibuffer)
  (setq pyim-cloudim 'google)  ; I hate baidu
  (setq pyim-dicts
       '((:name "tsinghua" :file "~/git/pyim-tsinghua-dict/pyim-tsinghua-dict.pyim"))))

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

(use-package circe
  ;; well I don't want to learn keybindings for other irc clients like weechat
  ;; both erc and rcirc can't use sasl properly
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

;; ===================== ;;
;; use-package/languages ;;
;; ===================== ;;
(use-package web-mode
  ;; https://web-mode.org/
  ;; for embeded elixir
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
  (setq nim-compile-default-command '("c" "-r" "--excessiveStackTrace:on" "--debuginfo:on")))
