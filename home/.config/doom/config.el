(beacon-mode 1)

(setq doom-theme 'doom-material)

(setq display-line-numbers 'visual)
(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Comment or uncomment lines" "/" #'comment-line
       :desc "Toggle line numbers" "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines" "t" #'toggle-truncate-lines))

(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(setq org-directory "~/Org/")

(after! org
  ;; TODO Agenda doesn't work in hidden directories
  (setq org-agenda-files '("~/Org" "~/.config/doom")
        ;; org-priority-faces     ; Colors for priority
        ;; '((?A :foreground "#e45649")
        ;;   (?B :foreground "#da8548")
        ;;   (?C :foreground "#0098dd"))
        org-todo-keywords      ; This overwrites the default Doom org-todo-keywords
        '((sequence
           "TODO(t)"           ; A task that is ready to be tackled
           "BLOG(b)"           ; Blog writing assignments
           "GYM(g)"            ; Things to accomplish at the gym
           "PROJ(p)"           ; A project that contains other tasks
           "VIDEO(v)"          ; Video assignments
           "WAIT(w)"           ; Something is holding up this task
           "|"                 ; The pipe necessary to separate "active" states and "inactive" states
           "DONE(d)"           ; Task has been completed
           "CANCELLED(c)"))    ; Task has been cancelled
        ;; org-todo-keyword-faces
        ;; `(("TODO" :foreground "#7c7c75" :weight normal :underline t)
        ;;   ("WAITING" :foreground "#9f7efe" :weight normal :underline t)
        ;;   ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
        ;;   ("DONE" :foreground "#50a14f" :weight normal :underline t)
        ;;   ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))))
        deft-extensions '("txt" "tex" "org")
        deft-directory "~/Org"
        deft-recursive t
        org-journal-date-prefix "#+TITLE: "
        org-journal-time-prefix "* "
        org-journal-date-format "%a, %Y-%m-%d"
        org-journal-file-format "%Y-%m-%d.org"
        org-roam-directory "~/Org/Roam"
        )
  )

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

(setq eshell-aliases-file "~/.config/doom/eshell/aliases"
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "htop" "ssh" "top"))

(map! :leader
      (:prefix ("e". "Terminal")
       :desc "Eshell" "s" #'eshell
       :desc "Eshell popup toggle" "t" #'+eshell/toggle
       :desc "Consult terminal history" "h" #'consult-history
       :desc "Vterm popup toggle" "v" #'+vterm/toggle))

(setq user-full-name "Ilya Lisin"
      user-mail-address "blacklacost@gmail.com")
