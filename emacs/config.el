;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(after! vterm
  (setq vterm-shell "/home/wsanf/.nix-profile/bin/zsh"))

(defun wsanf/open-daily-note ()
  "Open today's daily note file or create it from template if it doesn't exist."
  (interactive)
  (let* ((today (format-time-string "%Y-%m-%d"))
         (daily-dir "~/proton/Notes/daily/")
         (file-path (concat daily-dir today ".md"))
         (template-path "~/proton/Notes/daily/template.md"))
    (if (file-exists-p file-path)
        (find-file file-path)
      (progn
        (find-file file-path)
        (when (file-exists-p template-path)
          (insert-file-contents template-path))))))

(map! :leader
      :desc "Open daily note"
      "o D" #'wsanf/open-daily-note)

(defun wsanf/open-todo ()
  "Open the Todo.md file."
  (interactive)
  (find-file "~/proton/Notes/Todo.md"))

(map! :leader
      :desc "Open todo list"
      "o o" #'wsanf/open-todo)

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

(after! lsp-mode
  (setq lsp-clients-clangd-executable "clangd"))
