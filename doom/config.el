;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Nathan Hüsken"
      user-mail-address "nathan@wintercloud.de")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-oceanic-next)
(custom-set-faces
  '(mode-line ((t (:background "RoyalBlue4"))))
  '(mode-line-active ((t (:background "RoyalBlue4"))))
  '(mode-line-inactive ((t (:background "midnight blue")))))
(setq evil-normal-state-cursor '(box "DeepPink")
      evil-insert-state-cursor '(bar "DeepPink")
      evil-visual-state-cursor '(hollow "DeepPink"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/projects/org/")

 (defun center-cargo-test-error ()
      "Center the error in the error window"
      (interactive)
      (when-let ((buffer (get-buffer "*cargo-test*")))
        (with-selected-window (get-buffer-window buffer)
          (recenter-top-bottom 0))))
(add-hook 'next-error-hook 'center-cargo-test-error)

;; Make _ part of words
(modify-syntax-entry ?_ "w")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; dap setup
(setq dap-python-debugger 'debugpy)
(setq dap-auto-configure-mode t)

;; company comletion
(with-eval-after-load 'company
  ;;(define-key company-mode-map [remap indent-for-tab-command] #'counsel-company)
  (setq company-idle-delay nil)
)

;; Smart tab, these will only work in GUI Emacs
(map! :i [tab] (cmds! (and (bound-and-true-p company-mode)
                           (modulep! :completion company))
                      #'company-indent-or-complete-common)
      :i [C-return]  (cmds! (and (modulep! :editor snippets)
                              (yas-maybe-expand-abbrev-key-filter 'yas-expand))
                         #'yas-expand)
      )

(with-eval-after-load 'snippets
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-keymap [(tab)] nil)
  (define-key yas-keymap (kbd "TAB") nil)
  (define-key yas-keymap [(C-return)] (yas-filtered-definition 'yas-next-field-or-maybe-expand))
  (define-key yas-keymap [(S-return)] (yas-filtered-definition 'yas-prev-field))
)
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-mobile-inbox-for-pull "~/Dropbox/Apps/MobileOrg/mobileorg.org")

(with-eval-after-load 'dired
  (map! :map dired-mode-map
        :n [backspace] 'dired-up-directory
        )
  )

(map!
      :n "U" 'evil-redo
)

;; projectile
(setq projectile-project-search-path '(("~/projects/" . 10)))

;; (hercules-def
;;  :show-funs #'dired-mode
;;  :hide-funs '(+dired/quit-all)
;;  :keymap 'dired-mode-map)

;; (with-eval-after-load 'dired
;;   (defhydra hydra-dired (:hint nil :color pink)
;;     "dired"
;;     ("\\" dired-do-ispell "flyspell")
;;     ("(" dired-hide-details-mode "details")
;;     (")" dired-omit-mode "omit-mode")
;;     ("+" dired-create-directory "mkdir")
;;     ("=" diredp-ediff "pdiff")         ;; smart diff
;;     ("?" dired-summary "summay")
;;     ("$" diredp-hide-subdir-nomove "hide-subdir")
;;     ("A" dired-do-find-regexp "find regexp")
;;     ("C" dired-do-copy "Copy")        ;; Copy all marked files
;;     ("D" dired-do-delete "Delete")
;;     ("E" dired-mark-extension "Extension mark")
;;     ("e" dired-ediff-files "ediff")
;;     ("F" dired-do-find-marked-files "find marked")
;;     ("G" dired-do-chgrp "chgrp")
;;     ("g" revert-buffer "revert buf")        ;; read all directories again (refresh)
;;     ("i" dired-maybe-insert-subdir "insert subdir")
;;     ("l" dired-do-redisplay "redisplay")   ;; relist the marked or singel directory
;;     ("M" dired-do-chmod "chmod")
;;     ("m" dired-mark "mark")
;;     ("O" dired-display-file "view other")
;;     ("o" dired-find-file-other-window "open other")
;;     ("Q" dired-do-find-regexp-and-replace "replace regex")
;;     ("R" dired-do-rename "rename")
;;     ("r" dired-do-rsynch "rsync")
;;     ("S" dired-do-symlink "symlink")
;;     ("s" dired-sort-toggle-or-edit "sort")
;;     ("t" dired-toggle-marks "toggle marks")
;;     ("U" dired-unmark-all-marks "unmark all")
;;     ("u" dired-unmark "unmark")
;;     ("v" dired-view-file "view")      ;; q to exit, s to search, = gets line #
;;     ("w" dired-kill-subdir "kill subdir")
;;     ("Y" dired-do-relsymlink "rel symlink")
;;     ("z" diredp-compress-this-file "compress files")
;;     ("Z" dired-do-compress "compress")
;;     ("^" dired-up-directory "up directory")
;;     ("<backspace>" dired-up-directory)
;;     ("q" +dired/quit-all "quit" :color blue)
;;     ("." nil "toggle hydra" :color blue))
;;   (map! :map dired-mode-map
;;         :n "." 'hydra-dired/body
;;         :n [backspace] 'dired-up-directory
;;         )
;;   )
