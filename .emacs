(setq gc-cons-threshold (* 64 1024 1024))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" default))
 '(package-selected-packages
   '(smart-hungry-delete magit esup evil-mc neotree all-the-icons dashboard rust-mode nord-theme company markdown-mode elixir-mode racket-mode evil)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ========== ui (我把ui放在前面因为我感觉这样加载时"感觉"能快一点) ==========
(tool-bar-mode -1)                           ; 关闭 Tool bar
(menu-bar-mode -1)
(setq inhibit-startup-message t)             ; 关闭启动 Emacs 时的欢迎界面
(toggle-scroll-bar -1)                       ; 关闭滚动条
(column-number-mode t)                       ; 在 Mode line 上显示列号
(global-auto-revert-mode t)                  ; 让 Emacs 及时刷新 Buffer

(add-to-list 'default-frame-alist '(width . 80))  ; 设定启动图形界面时的Frame宽度
(add-to-list 'default-frame-alist '(height . 40)) ; 设定启动图形界面时的Frame高度

;(set-frame-font "-ADBO-Source Code Pro-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;(set-frame-font "-JB-JetBrains Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
(set-frame-font "-JB-JetBrainsMono Nerd Font Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")

(if (display-graphic-p)
    (progn (load-theme 'nord t)
           (global-whitespace-mode t))    ; 显示不可见符号
  (load-theme 'tango-dark t))

;;set transparent effect
(setq alpha-list '((90 60) (100 100) (70 40)))
;; 其中前一个指定当 Emacs 在使用中时的透明度, 而后一个则指定其它应用在使用中时 Emacs 的透明度

(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab))))
     (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))))


;; ========== package ==========
(require 'package)
(setq package-archives'(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                        ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
(package-initialize)


;; ========== custom ==========
(setq make-backup-files nil)
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))

(setq default-tab-width 2)
(setq-default indent-tabs-mode nil)    ; must be setq-default
(setq backward-delete-char-untabify-method 'hungry)

(setq display-line-numbers-type 'relative)    ; relative number, make d-d easier
(global-display-line-numbers-mode)


(global-set-key [(f8)] 'loop-alpha)
(global-set-key [(f3)] 'neotree-toggle)
;(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'loop-alpha)

(setq epa-file-cache-passphrase-for-symmetric-encryption t)
(setq epg-pinentry-mode 'loopback)    ; use minibuffer instead of popup

;; https://github.com/matrixj/405647498.github.com/blob/gh-pages/src/emacs/emacs-fun.org
(defun animate-text (text)
  (interactive "stext: ")  ; s means read-string
  (switch-to-buffer (get-buffer-create "*butterfly*"))
  (erase-buffer)
  (animate-string text 10))


;; ========== use-package ==========
;; https://phenix3443.github.io/notebook/emacs/modes/use-package-manual.html
(use-package evil
  :config
  (evil-mode 1))

(use-package neotree
  :defer t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons))
  ;; without this evil mode will conflict with neotree
  ;; ref: https://www.emacswiki.org/emacs/NeoTree
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle))

(use-package dashboard
  :if window-system
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents . 7)
                          (bookmarks . 5)))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "董地瓜@bilibili")
  (setq dashboard-set-navigator t))

(use-package evil-mc
  :defer 2
  :config
  (global-evil-mc-mode 1))

(use-package smart-hungry-delete
  :defer 2
  :config
  (global-set-key (kbd "<backspace>")
                  'smart-hungry-delete-backward-char))
