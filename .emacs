(setq gc-cons-threshold (* 20 1024 1024))
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;======================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages
   '(company markdown-mode neotree elixir-mode racket-mode evil))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;======================================================================
 
(tool-bar-mode -1)                           ; 关闭 Tool bar
(menu-bar-mode -1)
(setq inhibit-startup-message t)             ; 关闭启动 Emacs 时的欢迎界面
(setq make-backup-files nil)                 ; 关闭文件自动备份
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条
(column-number-mode t)                       ; 在 Mode line 上显示列号
(global-auto-revert-mode t)                  ; 让 Emacs 及时刷新 Buffer
(add-to-list 'default-frame-alist '(width . 80))  ; 设定启动图形界面时的Frame宽度
(add-to-list 'default-frame-alist '(height . 40)) ; 设定启动图形界面时的Frame高度
(setq display-line-numbers-type 't)
(global-display-line-numbers-mode t)
(setq tab-width 2)
;(setq indent-tabs-mode nil)
;(set-frame-font "-ADBO-Source Code Pro-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
(set-frame-font "-JB-JetBrains Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")

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
    (setq alpha-list (cdr (append alpha-list (list h))))
    ))

(require 'neotree)
(global-set-key [(f3)] 'neotree-toggle)

(require 'evil)
(evil-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'erlang-mode
	  (lambda
	    (setq tab-width 2)))

