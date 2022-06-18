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

(setq doom-font (font-spec :family "Source Code Pro" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 18)
      doom-big-font (font-spec :family "Source Code Pro" :size 28))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(setq org-directory "~/Org/")

(after! org
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-time-prefix "* "
        org-journal-date-format "%a, %Y-%m-%d"
        org-journal-file-format "%Y-%m-%d.org"))

(after! org
  (setq deft-extensions '("txt" "tex" "org")
        deft-directory "~/Org"
        deft-recursive t))

(after! org
  (setq org-tag-alist
        '((:startgroup)
          ;; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i))))

(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

;; (after! org
;;   (setq org-priority-faces
;;         '((?A :foreground "#e45649")
;;           (?B :foreground "#da8548")
;;           (?C :foreground "#0098dd"))))

(after! org
  (setq org-refile-targets
        '(("Archive/2022-Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))
  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers))

(defun dw/read-file-as-string (path)
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-string)))

(after! org
  (setq org-capture-templates
        `(("t" "Tasks / Projects")
          ("tt" "Task" entry (file+olp "~/Org/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
          ("ts" "Clocked Entry Subtask" entry (clock)
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

          ("j" "Journal Entries")
          ("jj" "Journal" entry
           (file+olp+datetree "~/Org/journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
          ("jm" "Meeting" entry
           (file+olp+datetree "~/Org/journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

          ("w" "Workflows")
          ("we" "Checking Email" entry (file+olp+datetree "~/Org/journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

          ("m" "Metrics Capture")
          ("mw" "Weight" table-line (file+headline "~/Org/metrics.org" "Weight")
           "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)
          ("mf" "Fitness" table-line (file+headline "~/Org/metrics.org" "Fitness")
           "| %U | %^{Type} | %^{Notes} |" :kill-buffer t))))

(after! org
  ;; TODO Agenda doesn't work in hidden directories and subdirectories
  (setq org-agenda-files '("~/Org" "~/Org/Roam" "~/Org/Roam/daily")
        org-agenda-start-with-log-mode t
        org-log-done 'time     ; Log time when task done
        ;; NOTE I don't undestand this
        org-log-into-drawer t))

(after! org
  (setq org-todo-keywords      ; This overwrites the default Doom org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)"))))
        ;; org-todo-keyword-faces
        ;; `(("TODO" :foreground "#7c7c75" :weight normal :underline t)
        ;;   ("WAIT" :foreground "#9f7efe" :weight normal :underline t)
        ;;   ("NEXT" :foreground "#0098dd" :weight normal :underline t)
        ;;   ("DONE" :foreground "#50a14f" :weight normal :underline t)
        ;;   ("CANC" :foreground "#ff6480" :weight normal :underline t))

(after! org
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT" ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email") ;; - for exclude tag

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files))))))))

(after! org-roam
  (setq org-roam-directory "~/Org/Roam"
        org-roam-dailies-directory "daily/" ; daily is default, put here for explicit
        org-roam-completion-everywhere t  ; Try complete roam links everywhere (outside of [[]])
        org-roam-capture-templates
        '(("d" "default" plain
           (file "~/Org/Roam/Templates/DefaultTemplate.org")
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("b" "book notes" plain
           (file "~/Org/Roam/Templates/BookNoteTemplate.org")
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("p" "project" plain
           (file "~/Org/Roam/Templates/ProjectTemplate.org")
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :project:")
           :unnarrowed t)))
  ;; TODO work, but error when start emacs
  ;; (map! ("C-M-i" . completion-at-point))
  ;; NOTE try but doesn't work
  ;; (define-key global-map (kbd "C-M-i") #'completion-at-point)
  (map! :leader
        :desc "Insert immediate node" "n r I" #'org-roam-node-insert-immediate))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

;; (defun my/org-roam-filter-by-tag (tag-name)
;;   (lambda (node)
;;     (member tag-name (org-roam-node-tags node))))

;; (defun my/org-roam-list-notes-by-tag (tag-name)
;;   (mapcar #'org-roam-node-file
;;           (seq-filter
;;            (my/org-roam-filter-by-tag tag-name)
;;            (org-roam-node-list))))

;; (defun my/org-roam-refresh-agenda-list ()
;;   (interactive)
;;   (setq org-agenda-files (my/org-roam-list-notes-by-tag "project")))

;; Build the agenda list the first time for the session
;; (my/org-roam-refresh-agenda-list)

(use-package! org-gtd
  :after org
  :config
  (map! :leader
        (:prefix ("d" . "GDT")
         :desc "Add" "a" #'org-gtd-capture
         :desc "Engage" "e" #'org-gtd-engage
         :desc "Process Inbox" "p" #'org-gtd-process-inbox
         :desc "Show All Next" "n" #'org-gtd-show-all-next
         :desc "Show Stuck Projects" "s" #'org-gtd-show-all-next
         :desc "Choose" "c" #'org-gtd-choose
         ))
  (define-key org-gtd-process-map (kbd "C-c c") #'org-gtd-choose)
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

(after! flyspell
  (setq flyspell-default-dictionary "en_US"))

(setq user-full-name "Ilya Lisin"
      user-mail-address "blacklacost@gmail.com")
