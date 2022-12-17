(setq min-pkg-list
      '(yaml-mode org-tree-slide rg shr-tag-pre-highlight rainbow-mode nix-mode htmlize doom-modeline nyan-mode elpher indent-guide zenburn-theme valign fzf go-translate expand-region circe selectric-mode clippy beacon pyim web-mode elfeed-org elfeed undo-tree smart-hungry-delete magit evil-mc neotree all-the-icons rust-mode nord-theme company markdown-mode elixir-mode evil use-package))

(defun setup-min-pkg () (interactive) (setup-what-pkg min-pkg-list))

