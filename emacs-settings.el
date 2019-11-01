(setq visible-bell 1)

(defun disable-all-minor-modes ()
  (interactive)
  (mapc
   (lambda (mode-symbol)
     (when (functionp mode-symbol)
       ;; some symbols are functions which aren't normal mode functions
       (ignore-errors 
         (funcall mode-symbol -1))))
   minor-mode-list))


(defun bean--kill-buffer ()
  (interactive)
  (kill-buffer)
  (helm-buffer-list)
  ;; (switch-to-buffer "*Messages*")
  )
(global-set-key (kbd "C-x k") 'bean--kill-buffer)

(use-package which-key
  :ensure t 
  :config
  (which-key-mode))

(use-package try
        :ensure t)

;; not needed
;; (use-package ace-window
;;   :ensure t
;;   :init
;;   (progn
;;     (setq aw-scope 'frame)
;;     (global-set-key (kbd "C-x O") 'other-frame)
;;     (global-set-key [remap other-window] 'ace-window)
;;     (custom-set-faces
;;      '(aw-leading-char-face
;;        ((t (:inherit ace-jump-face-foreground :height 3.0))))) 
;;     ))

(use-package popwin
  :ensure t
  :config (progn
            (popwin-mode 1)
            (push "*helm-exwm*" popwin:special-display-config)
            (push "*helm-mini*" popwin:special-display-config)
            (push "*Async Shell Command*" popwin:special-display-config)
            (push "*Flycheck error messages*" popwin:special-display-config)
            (push "*Shell Command Output*" popwin:special-display-config)
            )
  )

(winner-mode 1)
;; window navigation
(global-set-key (kbd "C-.") 'other-window)
(global-set-key (kbd "C-,") 'other-window)

(use-package expand-region
  :ensure t
  :bind ("C-M-h" . 'er/expand-region)
  :bind ("C-M-g" . 'er/contract-region)
  :config (progn))


(add-hook 'c-mode-hook
          (lambda ()
            (local-set-key (kbd "C-M-n") 'end-of-defun)
            (local-set-key (kbd "C-M-p") 'beginning-of-defun)))


(use-package golden-ratio
  :ensure t
  :config (golden-ratio-mode 1)
  )

;; https://www.reddit.com/r/emacs/comments/2jzkz7/quickly_switch_to_previous_buffer/
(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(global-set-key (kbd "C-x x") 'switch-to-last-buffer)

;; todo: set up keybindings: create a new key prefix for window manipulation
(use-package  buffer-move
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(setq org-latex-prefer-user-labels t)
  (use-package latex-preview-pane
    :ensure t)

;; (use-package skewer-mode
;;   :ensure t
;;   :config (progn
;;             (add-hook 'js2-mode-hook 'skewer-mode)
;;             (add-hook 'css-mode-hook 'skewer-css-mode)
;;             (add-hook 'html-mode-hook 'skewer-html-mode)
;;             (add-hook 'web-mode-hook 'skewer-mode)
;;             ))



;; https://github.com/foretagsplatsen/emacs-js
(use-package xref-js2
  :ensure t)
;; (use-package eslintd-fix
;;   :ensure t)
;; (use-package widget-js
;;   :ensure t)
;; (load-file "~/.emacs.d/emacs-js/emacs-js.el")
;; (use-package tern
;;               :ensure t)

(use-package glsl-mode
  :ensure t)

(use-package nasm-mode
  :ensure t)

(require 'man)
(set-face-attribute 'Man-overstrike nil :inherit font-lock-type-face :bold t)
(set-face-attribute 'Man-underline nil :inherit font-lock-keyword-face :underline t)

(use-package highlight-symbol
:ensure t)

(defun shell-command-as-string (cmd)
  (with-temp-buffer
    (shell-command-on-region (point-min) (point-max)
                             cmd t)
    (buffer-string)))


(defun bean--launch-command(command)
  (interactive)
  (call-process-shell-command
   command
   nil 0 nil
   )
  )

(defun keyboard-ch()
  (interactive)
  (shell-command-as-string "setxkbmap ch")
  )

(defun keyboard-us()
  (interactive)
  (shell-command-as-string "setxkbmap us")
  )

(use-package smartparens-config
    :ensure smartparens
    :config
    (progn
      (smartparens-global-mode)
      (show-smartparens-global-mode t)))

(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)

;; http://pragmaticemacs.com/emacs/visualise-and-copy-differences-between-files/
(use-package ediff
  :ensure t
  :config (progn
            ;; don't start another frame
            ;; this is done by default in preluse
            (setq ediff-window-setup-function 'ediff-setup-windows-plain)
            ;; put windows side by side
            (setq ediff-split-window-function (quote split-window-horizontally))
            ;;revert windows on exit - needs winner mode

            (add-hook 'ediff-after-quit-hook-internal 'winner-undo)
            )
  )

;; (use-package alloy-mode
  ;; :load-path "~/emacs.d/alloy-mode/alloy-mode.el")

(setq dired-recursive-copies 'always)

(setq vc-follow-symlinks t)

(defun open-current-in-urxvt()
  (interactive)
  (urxvt-with-tmux-new-window default-directory))

(defun urxvt-with-tmux-new-window(path)
  "creates new window in a running tmux session in urxvt and cd to path"
  ;; (setq test-path "/opt")
  ;; (setq command (format "urxvt -e sh -c \"cd %s ; tmux new-window -n dired\"" path))
  ;; (setq workspace 1)
  ;; (setq old-workspace exwm-workspace-current-index)
  ;; (shell-command command)
  ;; (exwm-workspace-switch 1)
  ;; (message (format "workspace [%d] -> [%d]. $ %s"
  ;;                  old-workspace
  ;;                  workspace command))

  (setq command (format "urxvt -e sh -c \"cd %s ; zsh\"" path))
  (bean--launch-command command))

(defun open-in (msg)
  (interactive "sopen with: [t]erminal, [f]ile explorer, [d]efault application, [i]ntellij, [c]lion, [p]ycharm, [b]rowser url:  ")
  (if (equal msg "t") (open-current-in-urxvt)
    (if (equal msg "f") (open-with-default-app nil)
      (if (equal msg "d") (crux-open-with nil)
        (if (equal msg "c") (bean--launch-command "/home/bean/tools/clion/bin/clion.sh $(pwd) &")
          (if (equal msg "p") (bean--launch-command "charm $(pwd) &")
            (if (equal msg "i") (bean--launch-command "intellij $(pwd) &")
              (if (equal msg "b") (browse-url-at-point)
                (message "unsupported command: %s" msg)))))))))

(defun open-with-default-app (arg)
  "Open visited file in default external program.

With a prefix ARG always prompt for command to use."
  (interactive)
  (bean--launch-command "nautilus $(pwd) &"))
;; (async-shell-command ))
;; (when buffer-file-name
;;   (async-shell-command (concat
;;                   (cond
;;                    ;; ((and (not arg) (eq system-type 'darwin)) "open")
;;                    ;; ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "nautilus")
;;                    (t (read-shell-command "Open current file with: ")))
;;                   " "
;;                   (shell-quote-argument buffer-file-name)))))



(global-set-key (kbd "C-x o") 'open-in)


(defun crux-open-with (arg)
  "Open visited file in default external program.
When in dired mode, open file under the cursor.
With a prefix ARG always prompt for command to use."
  (interactive "P")
  (let* ((current-file-name
          (if (eq major-mode 'dired-mode)
              (dired-get-file-for-visit)
            buffer-file-name))
         (open (pcase system-type
                 (`darwin "open")
                 ((or `gnu `gnu/linux `gnu/kfreebsd) "xdg-open")))
         (program (if (or arg (not open))
                      (read-shell-command "Open current file with: ")
                    open)))
    (call-process program nil 0 nil current-file-name)))

(use-package openwith
  :ensure t
  :config (progn
            (openwith-mode t)
            (setq openwith-associations '(("\\.pdf\\'" "firefox --new-window" (file))
                                          ("\\.jpg\\'" "eog" (file))
                                          ("\\.png\\'" "eog" (file))
                                          ))))

;; uncompress zip files
(eval-after-load "dired-aux"
   '(add-to-list 'dired-compress-file-suffixes 
                 '("\\.zip\\'" ".zip" "unzip")))

;; -- too distracting
;; (use-package rainbow-delimiters
;;   :ensure t
;;   :config (progn
;;             (add-hook 'elisp-mode #'rainbow-delimiters-mode)
;;             (add-hook 'lisp-mode #'rainbow-delimiters-mode)))


(use-package highlight-parentheses
  :ensure t
  :config (progn
            (add-hook 'elisp-mode #'highlight-parentheses-mode)
            (add-hook 'lisp-mode #'highlight-parentheses-mode)))

(use-package popup
  :ensure t)

(defun bean/xref-find-definitions ()
  "uses xref-find-definition to find definition of symbol.
   If location is not found, use describe-symbol/function to look up help text"

  (interactive)
  (let* ((id (symbol-at-point)))
    (defun error-handler(a b c)
      (describe-function-in-popup))

    (setq command-error-function 'error-handler)    
    (xref--find-definitions (symbol-name id) nil)))


(defun describe-function-in-popup ()
  (interactive)
  (let* ((thing (symbol-at-point))
         ;; (help-xref-following t)
         (description (save-window-excursion
                        (describe-function thing)
                        (switch-to-buffer "*Help*")
                        (buffer-string))))
    (popup-tip description
               :point (point)
               :around t
               :height 30
               :scroll-bar t
               :margin t)))

(define-key lisp-mode-map (kbd "M-.") 'bean/xref-find-definitions)

(use-package wc-mode
  :ensure t
  :config (progn
            (wc-mode 1)))

;;; readme: https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :load-path "~/emacs.d/multiple-cursors.el/"
  :ensure multiple-cursors
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this) 
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this) 
  (global-set-key (kbd "C-c C-;") 'mc/mark-all-like-this)
  (define-key mc/keymap (kbd "<return>") nil)
  )

;; https://raw.githubusercontent.com/camdez/goto-last-change.el/master/goto-last-change.el
(use-package goto-last-change
  :bind("C-x C-l" . goto-last-change)
)

(use-package ggtags
  :ensure t
  :config (progn
            (add-hook 'c-mode-common-hook
                      (lambda ()
                        (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'python-mode)
                          (ggtags-mode 1))))
            ))

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(use-package backup-each-save :load-path "~/emacs.d/lisp"
  :ensure backup-each-save
  :config ())
 (add-hook 'after-save-hook 'backup-each-save)

;; show letters on screen to jump to 
(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-word-1))

(use-package projectile
  :ensure t
  :config (progn
            (projectile-mode +1)
            (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)))

(define-key projectile-mode-map (kbd "C-c p n") 'projectile-previous-project-buffer)

;; todo use use-package
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-l") 'helm-mini)

(with-eval-after-load 'helm-buffers
  (add-to-list 'helm-boring-buffer-regexp-list "\\`*"))

(use-package helm-exwm
  :ensure t
  )

(use-package helm-swoop
  :ensure t
  :config

  ;; Change the keybinds to whatever you like :)
  (global-set-key (kbd "M-i") 'helm-swoop)
  (global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
  (global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
  (global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)
  (global-set-key (kbd "C-M-i") 'helm-multi-swoop-projectile)

  ;; When doing isearch, hand the word over to helm-swoop
  (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
  ;; From helm-swoop to helm-multi-swoop-all
  (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
  ;; When doing evil-search, hand the word over to helm-swoop
  ;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

  ;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
  (define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

  ;; Move up and down like isearch
  (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
  (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
  (define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
  (define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

  ;; Save buffer when helm-multi-swoop-edit complete
  (setq helm-multi-swoop-edit-save t)

  ;; If this value is t, split window inside the current window
  (setq helm-swoop-split-with-multiple-windows nil)

  ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
  (setq helm-swoop-split-direction 'split-window-horizontally)

  ;; If nil, you can slightly boost invoke speed in exchange for text color
  ;; (setq helm-swoop-speed-or-color nil)

  ;; ;; Go to the opposite side of line from the end or beginning of line
  (setq helm-swoop-move-to-line-cycle t)

  ;; Optional face for line numbers
  ;; Face name is `helm-swoop-line-number-face`
  (setq helm-swoop-use-line-number-face t)

  ;; If you prefer fuzzy matching
  ;; (setq helm-swoop-use-fuzzy-match t)
  )

(setq helm-buffer-max-length nil)


;; we may want to disable counsel projectile
(use-package helm-projectile
  :load-path "~/.emacs.d/helm-projectile"
  :config (progn
            (helm-projectile-on)))


(setq helm-mini-default-sources '(helm-source-buffers-list
                                  helm-source-recentf
                                  helm-source-bookmarks
                                  helm-source-buffer-not-found))

(add-hook 'org-mode-hook 'turn-on-flyspell)
(org-indent-mode 1)
(add-hook 'org-mode-hook 'org-indent-mode 1)

(set-face-foreground 'org-drawer "#282A36")

(use-package browse-url
  :ensure t)


;; always expand lists on open
(setq org-startup-folded 'content)



(use-package bind-key
  :ensure t)

;;; more options: https://github.com/yjwen/org-reveal
(use-package ox-reveal
  :load-path "~/.emacs.d/org-reveal"
  :config (progn
            (setq org-reveal-root "file:////home/bean/.emacs.d/reveal.js/")
            ;; (setq org-reveal-root "file:///http://cdn.jsdelivr.net/reveal.js/3.0.0/")
            (setq org-reveal-single-file t)
            (setq org-reveal-theme "black")
            ))

(use-package htmlize
  :ensure t)

;; (use-package easypg
;;   :ensure t)

(use-package org-journal
  :ensure t)

(use-package org-autolist
  :load-path "~/.emacs.d/org-autolist/"
  :config (progn
            (add-hook 'org-mode-hook (lambda () (org-autolist-mode)))))

(use-package helm-chrome
   :ensure t)

(defun bt-connect-bose-qt-35 ()
    "connect to bluetooth headphones"
  (interactive)
  (shell-command "bt-connect-qc35 &"))

(defun bt-connect-bombom ()
    "connect to bluetooth speakers"
  (interactive)
  (shell-command "bt-connect-bombom &"))

(defun bt-disconnect ()
  (interactive)
  (bean--launch-command "bt-disconnect &"))

(defun audio-play-pause ()
  (interactive)
  (bean--launch-command "xdotool key XF86AudioPlay &"))

(defun audio-next ()
  (interactive)
  (bean--launch-command "xdotool key XF86AudioNext &"))

(defun audio-prev ()
  (interactive)
  (bean--launch-command "xdotool key XF86AudioPrev &"))

(defun keyboard-light-off ()
  (interactive)
  (bean--launch-command "keyboard-light-0 &"))

(defun keyboard-light-on-1 ()
  (interactive)
  (bean--launch-command "keyboard-light-1 &"))

(defun keyboard-light-on-2 ()
  (interactive)
  (bean--launch-command "keyboard-light-2 &"))

(define-minor-mode disable-mouse-mode
  "A minor-mode that disables all mouse keybinds."
  :global t
  :lighter " 🐭"
  :keymap (make-sparse-keymap))

(dolist (type '(mouse down-mouse drag-mouse
                      double-mouse triple-mouse))
  (dolist (prefix '("" C- M- S- M-S- C-M- C-S- C-M-S-))
    ;; Yes, I actually HAD to go up to 7 here.
    (dotimes (n 7)
      (let ((k (format "%s%s-%s" prefix type n)))
        (define-key disable-mouse-mode-map
          (vector (intern k)) #'ignore)))))


(disable-mouse-mode 1)

(defun social-spawn()
  (interactive)
  (setq ws exwm-workspace-current-index)
  (message "spawning social apps on workspace 7" nil)

  (exwm-workspace-switch-create 7)
  (bean--launch-command "social-spawn &")
)

;; http://endlessparentheses.com/ispell-and-abbrev-the-perfect-auto-correct.html
(define-key ctl-x-map "\C-i" #'endless/ispell-word-then-abbrev)

(defun endless/simple-get-word ()
  (car-safe (save-excursion (ispell-get-word nil))))

(defun endless/ispell-word-then-abbrev (p)
  "Call `ispell-word', then create an abbrev for it
With prefix P, create local abbrev. Otherwise it will
be global.
If there's nothing wrong with the word at point, keep
looking for a typo until the beginning of buffer. You can
skip typos you don't want to fix with `SPC', and you can
abort completely with `C-g'."
  (interactive "P")
  (let (bef aft)
    (save-excursion
      (while (if (setq bef (endless/simple-get-word))
                 ;; Word was corrected or used quit.
                 (if (ispell-word nil 'quiet)
                     nil ; End the loop.
                   ;; Also end if we reach `bob'.
                   (not (bobp)))
               ;; If there's no word at point, keep looking
               ;; until `bob'.
               (not (bobp)))
        (backward-word)
        (backward-char))
      (setq aft (endless/simple-get-word)))
    (if (and aft bef (not (equal aft bef)))
        (let ((aft (downcase aft))
              (bef (downcase bef)))
          (define-abbrev
            (if p local-abbrev-table global-abbrev-table)
            bef aft)
          (message "\"%s\" now expands to \"%s\" %sally"
                   bef aft (if p "loc" "glob")))
      (user-error "No typo at or before point"))))

(setq save-abbrevs 'silently)
(setq-default abbrev-mode t)

;; (use-package slime-company
;;   :ensure t)

;; ;;  https://www.kaashif.co.uk/2015/06/28/hacking-stumpwm-with-common-lisp/index.html
;; (use-package slime
;;   :ensure t
;;   :config (progn
;;             (setq inferior-lisp-program "sbcl")
;;             (slime-setup '(slime-company))
;;             (load (expand-file-name "~/quicklisp/slime-helper.el"))))


(use-package paredit
  :ensure t)

(use-package stumpwm-mode
  :ensure t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(use-package dracula-theme
  :ensure t
  )

(use-package white-sand-theme
  :ensure t
  )



(use-package atom-one-dark-theme
  :ensure t
  )

(use-package zenburn-theme
  :ensure t
  )

;; (load-theme 'dracula t)
(load-theme 'zenburn t)
;; (load-theme 'white t)


(setq-default header-line-format
              (list " " (make-string 79 ?-) "|"))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<f12>") 'menu-bar-mode)

;; cursor movements
(global-set-key (kbd "M-n")
                (lambda () (interactive) (next-line 10)))

(global-set-key (kbd "M-p")
                (lambda () (interactive) (previous-line 10)))

;; after copy Ctrl+c in Linux X11, you can paste by `yank' in emacs
(setq x-select-enable-clipboard t)


;; after mouse selection in X11, you can paste by `yank' in emacs
(setq x-select-enable-primary t)

(face-remap-add-relative 'mode-line :background "goldenrod")
(use-package smart-mode-line
  :ensure t
  :config (progn
            (setq sml/no-confirm-load-theme t)
            (sml/setup)

            ))


;; (set-face-background 'mode-line "#282A36")
;; (set-face-foreground 'mode-line "#282A36")

(global-set-key (kbd "<f5>") 'eval-buffer)
(display-battery-mode 1)
(setq display-time-format " %a %Y-%m-%d %I:%M:%S ")


;; enable lin numbering in text based modesm
;; (add-hook 'text-mode-hook 'linum-mode)
;; (add-hook 'prog-mode-hook 'linum-mode)
;; (add-hook 'text-mode-hook 'line-number-mode)
;; (add-hook 'prog-mode-hook 'line-number-mode)


;; set the modeline background color and save a "cookie" so the change can be undone
;; (face-remap-add-relative 'mode-line :background "goldenrod")
;; (face-remap-add-relative 'mode-line :foreground "goldenrod")

(progn
  ;; Disable menu-bar, tool-bar and scroll-bar to increase the usable space.

  (use-package cl-generic
    :ensure t
    :config
    )


  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  ;; Also shrink fringes to 1 pixel.
  (fringe-mode 1)

  ;; Turn on `display-time-mode' if you don't use an external bar.
  ;; (setq display-time-default-load-average t)
  (display-time-mode t)

  ;; You are strongly encouraged to enable something like `ido-mode' to alter
  ;; the default behavior of 'C-x b', or you will take great pains to switch
  ;; to or back from a floating frame (remember 'C-x 5 o' if you refuse this
  ;; proposal however).
  ;; You may also want to call `exwm-config-ido' later (see below).
  (ido-mode 1)

  ;; Emacs server is not required to run EXWM but it has some interesting uses
  ;; (see next section).
  ;; (server-start)

;;;; Below are configurations for EXWM.

  ;; Add paths (not required if EXWM is installed from GNU ELPA).
                                        ;(add-to-list 'load-path "/path/to/xelb/")
                                        ;(add-to-list 'load-path "/path/to/exwm/")

  ;; Load EXWM.
  (require 'exwm)

  ;; Fix problems with Ido (if you use it).
  (require 'exwm-config)
  (exwm-config-ido)

  ;; Set floating window border
  (setq exwm-floating-border-width 3)
  (setq exwm-floating-border-color "orange")

  (defun suspend-computer ()
    (interactive)
    (shell-command "systemctl suspend"))

  (defun hibernate-computer ()
    (interactive)
    (shell-command "systemctl hibernate"))

  (defun restart-computer ()
    (interactive)
    (shell-command "systemctl reboot"))

  (defun shutdown-computer ()
    (interactive)
    (shell-command "systemctl poweroff"))

  (defun lock-i3 ()
    (interactive)
    (bean--launch-command "lock-i3"))
  ;; (shell-command "lock-i3"))

  (defun terminal ()
    (interactive)
    (bean--launch-command "urxvt &> /dev/null &"))
  ;; (shell-command "urxvt &> /dev/null &"))

  (defun browser ()
    (interactive)
    ;; (shell-command "chromium-browser --new-window &> /dev/null &"))
    ;; (bean--launch-command "chromium-browser  --new-window &> /dev/null &")
    (bean--launch-command "firefox  --new-window &> /dev/null &"))

  (defun chrome ()
    (interactive)
    (browser))

  (defun next-exwm-buffer ()
    "show next exwm window"
    (interactive)
    (switch-to-buffer "*Messages*")
    (message "finding previous exwm buffer ...")
    (next-buffer)
    (while (not (eq major-mode 'exwm-mode))
      (next-buffer)))

  (defun previous-exwm-buffer ()
    "show previous exwm window"
    (interactive)
    (switch-to-buffer "*Messages*")
    (message "finding previous exwm buffer ...")
    (previous-buffer)
    (while (not (eq major-mode 'exwm-mode))
      (previous-buffer)))

  (use-package flx
    :ensure t
    )

  ;; (setq ivy-re-builders-alist
  ;;     '((ivy-switch-buffer . ivy--regex-plus)
  ;;       (t . ivy--regex-fuzzy)))

  ;; (setq ivy-initial-inputs-alist nil)
  ;; Disable dialog boxes since they are unusable in EXWM
  (setq use-dialog-box nil)

  ;; Set the initial number of workspaces (they can also be created later).

  (defun kill-all-buffers ()
    (interactive)
    (mapc 'kill-buffer (buffer-list)))


  (setq exwm-workspace-number 10)

  ;; All buffers created in EXWM mode are named "*EXWM*". You may want to
  ;; change it in `exwm-update-class-hook' and `exwm-update-title-hook', which
  ;; are run when a new X window class name or title is available.  Here's
  ;; some advice on this topic:
  ;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
  ;; + For applications with multiple windows (e.g. GIMP), the class names of
                                        ;    all windows are probably the same.  Using window titles for them makes
  ;;   more sense.
  ;; In the following example, we use class names for all windows expect for
  ;; Java applications and GIMP.
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                          (string= "gimp" exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-class-name))))
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (or (not exwm-instance-name)
                        (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-title))))

  ;; Global keybindings can be defined with `exwm-input-global-keys'.
  ;; Here are a few examples:  
  (setq exwm-input-global-keys
        `(
          ;; Bind "s-r" to exit char-mode and fullscreen mode.
          ([?\s-r] . exwm-reset)
          ;; ([?\s-] . bean/show-emacs)
          ([?\s-p] . previous-exwm-buffer)
          ([?\s-n] . next-exwm-buffer)
          ([?\s-f] . exwm-layout-toggle-fullscreen)
          ([?\s-i] . exwm-input-toggle-keyboard)
          ([?\s-b] . helm-mini)
          ([?\s-t] . terminal)
          ([?\s-e] . counsel-linux-app)
          ([?\s-g] . google-this)
          ([?\s-c] . chrome)
          ([?\s-.] . other-window)
          ([?\s-o] . other-window)
          ([?\s-,] . other-window)
          ([s-kp-7] . audio-prev)
          ([s-kp-8] . audio-play-pause)
          ([s-kp-9] . audio-next)
          ([?\s-u] . keyboard-us)
          ([?\s-y] . keyboard-ch)
          ([?\s-k] . bean--kill-buffer)
          ;; ([c-n] . next-line)
          ;; ([?\C-x C-p] . next-buffer)
          ;; ([?\C-x C-p] . previous-buffer)
          ;; Bind "s-w" to switch workspace interactively.
          ([?\s-w] . exwm-workspace-move-window)
          ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))
          ;; Bind "s-&" to launch applications ('M-&' also works if the output
          ;; buffer does not bother you).
          ;; ([?\s-e] . (lambda (command)
          ;;              (interactive (list (read-shell-command "$ ")))
          ;;              (start-process-shell-command command nil command)))
          )
        )


  ;; To add a key binding only available in line-mode, simply define it in
  ;; `exwm-mode-map'.  The following example shortens 'C-c q' to 'C-q'.
  (define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

  ;; The following example demonstrates how to use simulation keys to mimic
  ;; the behavior of Emacs.  The value of `exwm-input-simulation-keys` is a
  ;; list of cons cells (SRC . DEST), where SRC is the key sequence you press
  ;; and DEST is what EXWM actually sends to application.  Note that both SRC
  ;; and DEST should be key sequences (vector or string).
  (setq exwm-input-simulation-keys
        '(
          ;; movement
          ([?\C-b] . [left])
          ([?\M-b] . [C-left])
          ([?\C-f] . [right])
          ([?\M-f] . [C-right])
          ([?\C-p] . [up])
          ([?\C-n] . [down])
          ([?\C-a] . [home])
          ([?\C-e] . [end])
          ([?\M-v] . [prior])
          ([?\C-v] . [next])
          ([?\C-d] . [delete])
          ([?\C-k] . [S-end delete])
          ;; cut/paste.
          ([?\C-w] . [?\C-x])
          ([?\M-w] . [?\C-c])
          ([?\C-y] . [?\C-v])
          ;; search
          ([?\C-s] . [?\C-f])))

  ;; You can hide the minibuffer and echo area when they're not used, by
  ;; uncommenting the following line.
  ;; (setq exwm-workspace-minibuffer-position 'bottom)
  (setq exwm-manage-force-tiling nil)

  (global-set-key (kbd "C-x C-b") 'helm-exwm)
  )


;; (use-package subr-x
;;   :ensure t)

(defvar exwm-workspace-window-assignments
  '(("URxvt" . 1)

    ("Spotify" . 8)
    ("Franz" . 7)
    ("Thunderbird" . 7)
    ("TelegramDesktop" . 7)
    ("Whatsapp" . 7)
    )
  "An alist of window classes and which workspace to put them on.")

(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (when-let ((target (cdr (assoc exwm-class-name exwm-workspace-window-assignments))))
              (exwm-workspace-move-window target))))

;; always auto fill lines
  (add-hook 'tex-mode-hook 'turn-on-auto-fill)

  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))


  (use-package vlf
    :ensure t
    )

  ;; (use-package color-identifiers-mode
  ;;   :ensure t
  ;;   :config
  ;;   ;; (add-hook 'c-mode-hook 'global-color-identifiers-mode)
  ;;   )

  ;; open current file in finder
  ;; (require 'ido)
  ;; (ido-mode t)
  (defun open-current-file-in-finder ()
    (interactive)
    (shell-command "open -R ."))


  ;; shortcut to open .emacs config
  (global-set-key (kbd "<f6>") (lambda() (interactive)(find-file "~/.emacs.d/.emacs")))
  (global-set-key (kbd "<f7>") (lambda() (interactive)(find-file "~/.emacs.d/settings.org")))


  (defun toggle-window-split ()
    (interactive)
    (if (= (count-windows) 2)
        (let* ((this-win-buffer (window-buffer))
               (next-win-buffer (window-buffer (next-window)))
               (this-win-edges (window-edges (selected-window)))
               (next-win-edges (window-edges (next-window)))
               (this-win-2nd (not (and (<= (car this-win-edges)
                                           (car next-win-edges))
                                       (<= (cadr this-win-edges)
                                           (cadr next-win-edges)))))
               (splitter
                (if (= (car this-win-edges)
                       (car (window-edges (next-window))))
                    'split-window-horizontally
                  'split-window-vertically)))
          (delete-other-windows)
          (let ((first-win (selected-window)))
            (funcall splitter)
            (if this-win-2nd (other-window 1))
            (set-window-buffer (selected-window) this-win-buffer)
            (set-window-buffer (next-window) next-win-buffer)
            (select-window first-win)
            (if this-win-2nd (other-window 1))))))

  (global-set-key (kbd "C-x |") 'toggle-window-split)

  (global-set-key (kbd "<C-up>") 'shrink-window)
  (global-set-key (kbd "<C-down>") 'enlarge-window)
  (global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
  (global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)
  (global-set-key (kbd "C-M-.") 'pop-tag-mark)
  (global-set-key (kbd "C-c 4") 'multi-term-dedicated-toggle)



  (defun duplicate-current-line-or-region (arg)
    "Duplicates the current line or region ARG times.
  If there's no region, the current line will be duplicated. However, if
  there's a region, all lines that region covers will be duplicated."
    (interactive "p")
    (let (beg end (origin (point)))
      (if (and mark-active (> (point) (mark)))
          (exchange-point-and-mark))
      (setq beg (line-beginning-position))
      (if mark-active
          (exchange-point-and-mark))
      (setq end (line-end-position))
      (let ((region (buffer-substring-no-properties beg end)))
        (dotimes (i arg)
          (goto-char end)
          (newline)
          (insert region)
          (setq end (point)))
        (goto-char (+ origin (* (length region) arg) arg)))))
  (global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

  (defun move-line (n)
    "Move the current line up or down by N lines."
    (interactive "p")
    (setq col (current-column))
    (beginning-of-line) (setq start (point))
    (end-of-line) (forward-char) (setq end (point))
    (let ((line-text (delete-and-extract-region start end)))
      (forward-line n)
      (insert line-text)
      ;; restore point to original column in moved line
      (forward-line -1)
      (forward-char col)))

  (defun move-line-up (n)
    "Move the current line up by N lines."
    (interactive "p")
    (move-line (if (null n) -1 (- n))))

  (defun move-line-down (n)
    "Move the current line down by N lines."
    (interactive "p")
    (move-line (if (null n) 1 n)))

  (global-set-key (kbd "M-<up>") 'move-line-up)
  (global-set-key (kbd "M-<down>") 'move-line-down)

  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; == company-mode ==
  (use-package company
    :ensure t
    :defer t
    :init (add-hook 'after-init-hook 'global-company-mode)
    :config
    ;; (use-package company-irony :ensure t :defer t)
    ;; (setq company-idle-delay         confine nil
    ;;       company-minimum-prefix-length   1
    ;;       company-show-numbers            t
    ;;       company-tooltip-limit           30
    ;;       company-dabbrev-downcase        nil
    ;;       company-backends                '((company-irony company-gtags))
    ;;       )

    (setq company-dabbrev-downcase nil)
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)
    (define-key company-search-map (kbd "C-n") 'company-select-next)
    (define-key company-search-map (kbd "C-p") 'company-select-previous)
    (define-key company-search-map (kbd "C-t") 'company-search-toggle-filtering)

    (use-package company-c-headers
      :ensure t
      :config
      (add-to-list 'company-backends 'company-c-headers)
      (add-to-list 'company-c-headers-path-system "/usr/local/include/eigen3/" )
      )
    (add-hook 'global-init-hook 'global-company-mode)

    :bind ("C-;" . company-complete-common)
    )


  (defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (eshell-command 
     (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))

  ;; (require 'etags-update)

  (use-package flycheck
    :ensure t
    :config (progn
              (global-flycheck-mode)
              (setq flycheck-highlighting-mode 'symbols)
              (setq flycheck-indication-mode 'left-fringe)
              (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
              ))

  (defun toggle-flycheck-error-buffer ()
    "Toggle a flycheck error buffer."
    (interactive)
    (if (string-match-p "Flycheck errors" (format "%s" (window-list)))
        (dolist (w (window-list))
          (when (string-match-p "*Flycheck errors*" (buffer-name (window-buffer w)))
            (delete-window w)
            ))
      (flycheck-list-errors)
      )
    )
  (global-set-key (kbd "<f8>") 'toggle-flycheck-error-buffer)

  ;; indent buffer
  (defun indent-buffer ()
    (interactive)
    (save-excursion
      (indent-region (point-min) (point-max) nil)))

  ;; buffer
  ;; (defalias 'list-buffers 'ibuffer) ; make ibuffer default
  ;; (setq ido-separator "\n") ; show ido elements vertically

  (global-set-key (kbd "C-x C-n") 'my-next-buffer)
  (global-set-key (kbd "C-x C-p") 'my-previous-buffer)

  ;; (server-start)

  ;; (add-hook 'prog-mode-hook 'linum-on)

  ;; (use-package pdf-tools
  ;;   :ensure t
  ;;   :config
  ;;   (progn
  ;;     (pdf-tools-install)
  ;;     ;; overwrite swiper search
  ;;     (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;;     (add-hook 'pdf-view-mode-hook 'auto-revert-mode )))

  ;; org mode
  (require 'org)

  ;; toggle images and blocks
  ;; https://emacs.stackexchange.com/questions/7211/collapse-src-blocks-in-org-mode-by-default

  ;; (setq org-agenda-custom-commands '("c" "Simple agenda view" agenda ""))

  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "|" "DONE" )))

  (defvar org-blocks-hidden nil)
  (defun org-toggle-blocks ()
    (interactive)
    (if org-blocks-hidden
        (org-show-block-all)
      (org-hide-block-all))
    (setq-local org-blocks-hidden (not org-blocks-hidden)))
  (add-hook 'org-mode-hook 'org-toggle-blocks)

  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  (define-key org-mode-map (kbd "C-c i") 'org-toggle-inline-images)

  ;; TODO
  ;; ;; show recently browsed files
  ;; (require 'recentf)
  ;; (recentf-mode 1)
  ;; (setq recentf-max-menu-items 999)
  ;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)
  ;; (run-at-time nil (* 2 60) 'recentf-save-list)

  ;; http://emacsredux.com/blog/2013/04/21/edit-files-as-root/
  (defun sudo-edit (&optional arg)
    "Edit currently visited file as root.
  With a prefix ARG prompt for a file to visit.
  Will also prompt for a file to visit if current
  buffer is not visiting a file."

    (interactive "P")
    (if (or arg (not buffer-file-name))
        (find-file (concat "/sudo:root@localhost:"
                           (ido-read-file-name "Find file(as root): ")))
      (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))



  (setq inhibit-splash-screen t)
  ;; (switch-to-buffer "**")


  ;; todo
  (use-package dired-x
    :config (progn
              (setq diredp-find-file-reuse-dir-buffer 1)
              (setq diredp-toggle-find-file-reuse-dir 1)
              ))
  (setq dired-listing-switches "-ahl --group-directories-first")


  ;; (require 'dired-x)



  ;; (defun dired-write-cwd-to-file()
  ;;   ;; (message (dired-current-directory))

  ;;   (bean--launch-command (format "echo \"%s\" > ~/.emacs.d/current-dir" (dired-current-directory)))
  ;;   ;; (write-region (dired-current-directory) nil "~/.emacs.d/current-dir" :append 0 :visit 0 :MUSTBENEW nil)
  ;;   )

  ;; (defun dired-directory-aware-find-file()
  ;;   "just like (dired-find-file) but writes current directory to file 
  ;;    so that it can be used by other applications"
  ;;   (interactive)
  ;;   (dired-find-file)
  ;;   (dired-write-cwd-to-file))

  ;; (defun dired-directory-aware-jump()
  ;;   "just like (dired-jump) but writes current directory to file 
  ;;    so that it can be used by other applications"
  ;;   (interactive)
  ;;   (dired-jump)
  ;;   (dired-write-cwd-to-file))

  ;; (add-hook dired-mode-hook (lambda() 
  ;;                             (define-key dired-mode-map (kbd "<return>") 'dired-directory-aware-find-file)
  ;;                             (define-key dired-mode-map (kbd "C-x C-j") 'dired-directory-aware-jump)))



  ;; https://www.emacswiki.org/emacs/RecentFiles#toc21
  (defun recentd-track-opened-file ()
    "Insert the name of the directory just opened into the recent list."
    (and (derived-mode-p 'dired-mode) default-directory
         (recentf-add-file default-directory))
    ;; Must return nil because it is run from `write-file-functions'.
    nil)

  (defun recentd-track-closed-file ()
    "Update the recent list when a dired buffer is killed.
  That is, remove a non kept dired from the recent list."
    (and (derived-mode-p 'dired-mode) default-directory
         (recentf-remove-if-non-kept default-directory)))

  ;; (add-hook 'dired-after-readin-hook 'recentd-track-opened-file)
  ;; (add-hook 'kill-buffer-hook 'recentd-track-closed-file)

  (setq diredp-hide-details-initially-flag nil)


  (set-default 'truncate-lines t)
  ;; (toggle-truncate-lines t)

  ;; TODO:
  ;; https://stackoverflow.com/questions/6845005/how-can-i-open-files-externally-in-emacs-dired-mode
  ;; (require 'openwith)
  ;; (setq openwith-associations '(("\\.pdf\\'" "open" (file))))
  ;; (openwith-mode t)


  ;; show folders first in dired
  ;; https://emacs.stackexchange.com/questions/29096/how-to-sort-directories-first-in-dired
  ;; (setq dired-listing-switches "-lXGha --group-directories-first")

  (setq diredp-hide-details-initially-flag t)

  ;; (use-package dired-collapse
  ;;   :ensure t
  ;;   :config
  ;;   (setq dired-collapse-mode 1)
  ;;   )
  ;; (use-package dired-rainbow
  ;;   :ensure t
  ;;   :config
  ;;   )

  ;; (use-package diredful
  ;;   :ensure t
  ;;   :config
  ;;   (diredful-mode 1)
  ;;   )

  ;; https://www.emacswiki.org/emacs/BookmarkPlus
  ;; (require 'bookmark+)




;; (use-package dash
;;   :ensure t)

;; (use-package transient
;;   :ensure t)
;; (use-package with-editor
;;   :ensure t)

(use-package magit-popup
  :ensure t ; make sure it is installed
  :demand t ; make sure it is loaded
  )


  (use-package magit
    :ensure t
    :init
    :config
    :bind ("C-x g" . magit-status)
    :bind ("C-x M-g" . magit-dispatch-popup)
    )



  ;; https://raw.githubusercontent.com/camdez/goto-last-change.el/master/goto-last-change.el
  (use-package goto-last-change
    :bind("C-x C-l" . goto-last-change)
    )


  (global-set-key (kbd "M-<Tab>") 'switch-to-next-buffer)

  (require 'helm)
  (require 'helm-config)
  (global-set-key (kbd "C-x b") (lambda()
                                  (interactive)
                                  (if (projectile-project-p)
                                      (helm-projectile)(helm-mini))))

  (global-set-key (kbd "M-l") 'helm-mini)
  (global-set-key (kbd "M-C-l") 'ibuffer)

  (with-eval-after-load 'helm-buffers
    (add-to-list 'helm-boring-buffer-regexp-list "\\`*"))

  (use-package helm-exwm
    :ensure t
    )

  (use-package helm-swoop
    :ensure t
    :config

    ;; Change the keybinds to whatever you like :)
    (global-set-key (kbd "M-i") 'helm-swoop)
    (global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
    (global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
    (global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

    ;; When doing isearch, hand the word over to helm-swoop
    (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
    ;; From helm-swoop to helm-multi-swoop-all
    (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
    ;; When doing evil-search, hand the word over to helm-swoop
    ;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

    ;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
    (define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

    ;; Move up and down like isearch
    (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
    (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
    (define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
    (define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

    ;; Save buffer when helm-multi-swoop-edit complete
    (setq helm-multi-swoop-edit-save t)

    ;; If this value is t, split window inside the current window
    (setq helm-swoop-split-with-multiple-windows nil)

    ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
    (setq helm-swoop-split-direction 'split-window-horizontally)

    ;; If nil, you can slightly boost invoke speed in exchange for text color
    ;; (setq helm-swoop-speed-or-color nil)

    ;; ;; Go to the opposite side of line from the end or beginning of line
    (setq helm-swoop-move-to-line-cycle t)

    ;; Optional face for line numbers
    ;; Face name is `helm-swoop-line-number-face`
    (setq helm-swoop-use-line-number-face t)

    ;; If you prefer fuzzy matching
    ;; (setq helm-swoop-use-fuzzy-match t)
    )

  (setq helm-buffer-max-length nil)

  (global-set-key "\C-x\C-m" 'compile)

  (subword-mode +1)
  (setq-default c-basic-offset 4)


  ;; https://emacs.stackexchange.com/questions/29453/change-c-indent-style-for-specific-project/29456
  (use-package google-c-style
    ;; provides the Google C/C++ coding style
    :ensure t
    :init
    (setq c-basic-offset 4)
    :config
    (add-hook 'c-mode-common-hook 'google-set-c-style)
    (add-hook 'c-mode-common-hook 'google-make-newline-indent)
    (setq c-basic-offset 4)
    ;; https://www.emacswiki.org/emacs/IndentingC
    (setq-default indent-tabs-mode nil)
    (setq tab-width 4) ; or any other preferred value
    (setq c-default-style "google"
          c-basic-offset 4)

    (add-hook 'c-mode-common-hook
              '(lambda ()
                 (setq c-default-style "google")
                 (setq indent-tabs-mode nil)
                 (setq c-basic-offset 4)
                 (c-toggle-auto-state 1)))


    (add-hook 'c-mode-common-hook 
              (lambda ()
                (setq c-basic-offset 4)
                )
              )

    (defun indent-it-all ()
      "indent the buffer using indent"
      (shell-command-on-region (point-min) (point-max) "indent" t t))
    )


  (defun indent-buffer ()
    "Indent the currently visited buffer."
    (interactive)
    (indent-region (point-min) (point-max)))

  (defun indent-region-or-buffer ()
    "Indent a region if selected, otherwise the whole buffer."
    (interactive)
    (save-excursion
      (if (region-active-p)
          (progn
            (indent-region (region-beginning) (region-end))
            (message "Indented selected region."))
        (progn
          (indent-buffer)
          (message "Indented buffer.")))))

  (global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)


  (use-package hungry-delete
    :ensure t
    :config
    (global-hungry-delete-mode)
    )

  (use-package restart-emacs
    :ensure t
    )


  ;; (defun open-in-clion ()
  ;;   "Open files in Intellij clion."
  ;;   (interactive)
  ;;   (shell-command
  ;;    (format "clion --line %d %s"
  ;;            (line-number-at-pos)
  ;;            (buffer-file-name))))

  ;; (global-set-key(kbd "C-x o") 'open-in)

  ;; (defun open-in (msg)
  ;;   (interactive "swhat tool to launch? [l]ion, [f]inder, i[t]erm: ")
  ;;   (if (equal msg "l")
  ;;       (open-in-clion)
  ;;     (if (equal msg "f")
  ;;         (open-current-file-in-finder)
  ;;       (if (equal msg "t")
  ;;           (iterm-goto-filedir-or-home)        
  ;;         (message "unsupported command: %s" Meg)
  ;;         )))
  ;;   )

  ;; javascript
  (use-package js2-mode
    ;;  "https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html"
    :ensure t
    :config
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
    (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)


    (use-package js2-refactor
      :ensure t
      :config
      (add-hook 'js2-mode-hook #'js2-refactor-mode)
      (js2r-add-keybindings-with-prefix "C-c C-r")
      (define-key js2-mode-map (kbd "C-k") #'js2r-kill)    
      )

    (use-package xref-js2
      :ensure t
      :config
      (define-key js-mode-map (kbd "M-.") nil)
      (add-hook 'js2-mode-hook (lambda ()
                                 (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
      )
    )


  (defun my-sgml-insert-gt ()
    "Inserts a `>' character and calls 
  `my-sgml-close-tag-if-necessary', leaving point where it is."
    (interactive)
    (insert ">")
    (save-excursion (my-sgml-close-tag-if-necessary)))

  (defun my-sgml-close-tag-if-necessary ()
    "Calls sgml-close-tag if the tag immediately before point is
  an opening tag that is not followed by a matching closing tag."
    (when (looking-back "<\\s-*\\([^<> \t\r\n]+\\)[^<>]*>")
      (let ((tag (match-string 1)))
        (unless (and (not (sgml-unclosed-tag-p tag))
                     (looking-at (concat "\\s-*<\\s-*/\\s-*" tag "\\s-*>")))
          (sgml-close-tag)))))

  (eval-after-load "web-mode"
    '(define-key sgml-mode-map ">" 'my-sgml-insert-gt))

  (use-package web-mode
    ;; "http://web-mode.org/"
    :ensure t
    :config

    (defun my-web-mode-hook ()
      "Hooks for Web mode."
      (setq web-mode-markup-indent-offset 2)
      (setq web-mode-css-indent-offset 2)
      (setq web-mode-code-indent-offset 2)
      (setq web-mode-enable-auto-pairing t)
      (setq web-mode-enable-css-colorization t)
      (setq web-mode-enable-block-face t)
      (setq web-mode-enable-part-face t)
      (setq web-mode-enable-current-element-highlight t)
      (setq web-mode-enable-current-column-highlight t)
      (setq web-mode-enable-auto-closing t)
      (setq web-mode-tag-auto-close-style 2)

      (setq web-mode-ac-sources-alist
            '(("css" . (ac-source-css-property))
              ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
      )
    (add-hook 'web-mode-hook  'my-web-mode-hook)
    )

  (use-package websocket
    :ensure t)

  (use-package indium
    :ensure t
    :config

    )

  (use-package nhexl-mode
    :ensure t
    )


  (defun what-hexadecimal-value ()
    "Prints the decimal value of a hexadecimal string under cursor.
  Samples of valid input:

    ffff
    0xffff
    #xffff
    FFFF
    0xFFFF
    #xFFFF

  Test cases
    64*0xc8+#x12c 190*0x1f4+#x258
    100 200 300   400 500 600"
    (interactive )

    (let (inputStr tempStr p1 p2 )
      (save-excursion
        (search-backward-regexp "[^0-9A-Fa-fx#]" nil t)
        (forward-char)
        (setq p1 (point) )
        (re-search-forward "[^0-9A-Fa-fx#]" nil t)
        (backward-char)
        (setq p2 (point) ) )

      (setq inputStr (buffer-substring-no-properties p1 p2) )

      (let ((case-fold-search nil) )
        (setq tempStr (replace-regexp-in-string "^0x" "" inputStr )) ; C, Perl, …
        (setq tempStr (replace-regexp-in-string "^#x" "" tempStr )) ; elisp …
        (setq tempStr (replace-regexp-in-string "^#" "" tempStr ))  ; CSS …
        (setq tempStr (replace-regexp-in-string "^$0x" "" tempStr ))  ; asm
        )

      (message "Hex %s is %d" tempStr (string-to-number tempStr 16 ) )
      ))


  (use-package restclient
    :ensure t)
  (put 'upcase-region 'disabled nil)


  (use-package htmlize
    :ensure t
    )

  (use-package solidity-mode
    :ensure t
    )


  (use-package hindent
    :ensure t)


  ;; (use-package inf-haskell
  ;; :ensure t)

  (use-package ghc
    :ensure t
    :config (progn
              (autoload 'ghc-init "ghc" nil t)
              (autoload 'ghc-debug "ghc" nil t)
              ;; (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
              ))


  ;; https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
  ;; M-x haskell-mode-stylish-buffer
  ;; also sort and align your import sections nicely. This is available in the key binding C-c C-,
  ;; F8 haskell navigate imports
  ;; use haskell interactive-bring for console
  (use-package haskell-mode
    :ensure t
    :config (progn
              (defun my-haskell-hook()
                (progn
                  (interactive-haskell-mode)
                  (haskell-doc-mode)
                  (haskell-indent-mode)
                  (hindent-mode)
                  ;; (haskell-session-change)
                  (eval-after-load 'haskell-mode
                    '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))
                  ))

              (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
                (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
                (add-to-list 'exec-path my-cabal-path))
              (custom-set-variables '(haskell-tags-on-save t))

              (add-hook 'haskell-mode-hook 'my-haskell-hook)))


  (use-package company-ghc
    :ensure t
    :config (progn
              (add-to-list 'company-backends 'company-ghc)
              (custom-set-variables '(company-ghc-show-info t))))




  (setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
   '(("." . "~/.saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))


  (recentf-mode 1)
  (setq recentf-max-menu-items 50)
  (global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; (use-package bookmark+
;;  :load-file "bookmark-plus"
;;  :ensure t
;;  )


(defun bean/show-bookmarks ()
  (interactive)
  (call-interactively 'bookmark-bmenu-list)
  (call-interactively 'swiper)
  )

(global-set-key (kbd "C-x r l") 'bean/show-bookmarks)

;; it looks like counsel is a requirement for swiper
(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x e") 'counsel-linux-app)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-load-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

    ;; (setq ivy-re-builders-alist
    ;;       '((swiper . regexp-quote)
    ;;         (t      . ivy--regex-fuzzy)))
    ))


;; (use-package counsel-projectile
;;   :load-path "~/.emacs.d/counsel-projectile/"
;;   :config
;;   (counsel-projectile-mode)
;;   )

(defun bean/show-emacs()
  (interactive)
  (find-file "~/.emacs")
  )

(defun bean/show-emacs()
  (interactive)(find-file "~/.emacs.d/settings.org"))

;; todo: more helm buffers?
(setq skippable-buffers '("*Async Shell Command*" "*Helm Completions*" "*Open Recent*" "*helm mini*" "*scratch*" "*Shell Command Output*" "*Messages*" "*Helm Swoop*"))

(defun my-next-buffer ()
  "next-buffer that skips certain buffers"
  (interactive)
  (if (projectile-project-p)
      (projectile-next-project-buffer)(next-buffer))

  (while (member (buffer-name) skippable-buffers)
    (if (projectile-project-p)
        (projectile-next-project-buffer)(next-buffer))))

(defun my-previous-buffer ()
  "previous-buffer that skips certain buffers"
  (interactive)

  (if (projectile-project-p)
      (projectile-previous-project-buffer)(previous-buffer))

  (while (member (buffer-name) skippable-buffers)
    (if (projectile-project-p)
        (projectile-previous-project-buffer)(previous-buffer))))

(global-set-key (kbd "M-<tab>") 'my-next-buffer)
;; (global-set-key (kbd "M-<tab>") 'my-next-buffer)
;; (use-package emacs-async
;;   :ensure t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'flyspell)
(define-key flyspell-mode-map (kbd "C-.") nil)
(define-key flyspell-mode-map (kbd "C-,") nil)
(unbind-key "C-." flyspell-mode-map)
(unbind-key "C-," flyspell-mode-map)



;; (define-key dired-mode-map (kbd "<return>") 'dired-directory-aware-find-file)
;; (define-key dired-mode-map (kbd "C-x C-j") 'dired-directory-aware-jump)
