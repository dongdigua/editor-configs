(setq gc-cons-threshold (* 32 1024 1024))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" default))
 '(package-selected-packages
   '(nord-theme company markdown-mode neotree elixir-mode racket-mode evil)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ========== package ==========
(require 'package)
(setq package-archives'(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                        ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
(package-initialize)

;; ========== ui ==========
(tool-bar-mode -1)                           ; 关闭 Tool bar
(menu-bar-mode -1)
(setq inhibit-startup-message t)             ; 关闭启动 Emacs 时的欢迎界面
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条
(column-number-mode t)                       ; 在 Mode line 上显示列号
(global-auto-revert-mode t)                  ; 让 Emacs 及时刷新 Buffer

(add-to-list 'default-frame-alist '(width . 80))  ; 设定启动图形界面时的Frame宽度
(add-to-list 'default-frame-alist '(height . 40)) ; 设定启动图形界面时的Frame高度

(setq display-line-numbers-type 't)
(global-display-line-numbers-mode t)

;(set-frame-font "-ADBO-Source Code Pro-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;(set-frame-font "-JB-JetBrains Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
(set-frame-font "-JB-JetBrainsMono Nerd Font Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
(load-theme 'nord t)

;;set transparent effect, but it blinks when I click at the end of the line
(global-set-key [(f8)] 'loop-alpha)
(setq alpha-list '((90 60) (100 100) (70 40)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))))

;; ========== custom ==========
(setq make-backup-files nil)                 ; 关闭文件自动备份
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))

(setq default-tab-width 2)
(setq indent-tabs-mode nil)

(global-whitespace-mode t)
;(add-hook 'after-init-hook 'global-company-mode)

;; ========== use-package ==========
;; https://phenix3443.github.io/notebook/emacs/modes/use-package-manual.html
(use-package evil
  :init
  (evil-mode 1))

(use-package neotree
  :init
  (global-set-key [(f3)] 'neotree-toggle))

(use-package elixir-mode
  :defer t
  :init
  (setq tab-width 2))

