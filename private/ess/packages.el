;;; packages.el --- ESS (R) Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq ess-packages
  '(
    ;; company
    ess
    ess-R-data-view
    ;; ess-R-object-popup
    ess-smart-equals
    rainbow-delimiters
    (electric-spacing-r :location local)
    (essh :location local)
    smartparens
    ;; :local electric-spacing-r
    ))

(defun ess/init-ess ()
  (use-package ess-site
    :mode (("\\.sp\\'"           . S-mode)
           ("/R/.*\\.q\\'"       . R-mode)
           ("\\.[qsS]\\'"        . S-mode)
           ("\\.ssc\\'"          . S-mode)
           ("\\.SSC\\'"          . S-mode)
           ("\\.[rR]\\'"         . R-mode)
           ("\\.[rR]nw\\'"       . Rnw-mode)
           ("\\.[sS]nw\\'"       . Snw-mode)
           ("\\.[rR]profile\\'"  . R-mode)
           ("NAMESPACE\\'"       . R-mode)
           ("CITATION\\'"        . R-mode)
           ("\\.omg\\'"          . omegahat-mode)
           ("\\.hat\\'"          . omegahat-mode)
           ("\\.lsp\\'"          . XLS-mode)
           ("\\.do\\'"           . STA-mode)
           ("\\.ado\\'"          . STA-mode)
           ("\\.[Ss][Aa][Ss]\\'" . SAS-mode)
           ("\\.jl\\'"           . ess-julia-mode)
           ("\\.[Ss]t\\'"        . S-transcript-mode)
           ("\\.Sout"            . S-transcript-mode)
           ("\\.[Rr]out"         . R-transcript-mode)
           ("\\.Rd\\'"           . Rd-mode)
           ("\\.[Bb][Uu][Gg]\\'" . ess-bugs-mode)
           ("\\.[Bb][Oo][Gg]\\'" . ess-bugs-mode)
           ("\\.[Bb][Mm][Dd]\\'" . ess-bugs-mode)
           ("\\.[Jj][Aa][Gg]\\'" . ess-jags-mode)
           ("\\.[Jj][Oo][Gg]\\'" . ess-jags-mode)
           ("\\.[Jj][Mm][Dd]\\'" . ess-jags-mode))
    :commands (R stata julia SAS)
    :init
    (progn
      (when (configuration-layer/package-usedp 'company)
        (add-hook 'ess-mode-hook 'company-mode)))
    (use-package ess-r-mode
      :bind
      (:map ess-r-mode-map
            ("M--" . ess-insert-assign)
            ("M-p" . add-pipe-magrittr)
            ("M-o" . add-pipe-native)
            ("M-k" . add-knitr-opts))
      (:map inferior-ess-r-mode-map
            ("M--" . ess-insert-assign)
            ("M-p" . add-pipe-magrittr-inf)
            ("M-o" . add-pipe-native-inf))
      :config
      (defun add-pipe-magrittr ()
        (interactive)
        (end-of-line)
        (unless (looking-back "%>%" nil)
          (just-one-space 1)
          (insert "%>%"))
        (newline-and-indent))
      (defun add-pipe-magrittr-inf ()
        (interactive)
        (end-of-line)
        (unless (looking-back "%>%" nil)
          (just-one-space 1)
          (insert "%>% ")))
      (defun add-pipe-native ()
        (interactive)
        (end-of-line)
        (unless (looking-back "|>" nil)
          (just-one-space 1)
          (insert "|>"))
        (newline-and-indent))
      (defun add-pipe-native-inf ()
        (interactive)
        (end-of-line)
        (unless (looking-back "|>" nil)
          (just-one-space 1)
          (insert "|> ")))
      (defun add-knitr-opts ()
        (interactive)
        (beginning-of-line)
        (unless (looking-back "#|" nil)
          (just-one-space 0)
          (insert "#| ")
          (end-of-line)))
      ))

  ;; R --------------------------------------------------------------------------
  (with-eval-after-load 'ess-site
    ;; ESS
    (add-hook 'ess-mode-hook
              (lambda ()
                (ess-set-style 'C++ 'quiet)
                ;; Because
                ;;                                 DEF GNU BSD K&R C++
                ;; ess-indent-level                  2   2   8   5   4
                ;; ess-continued-statement-offset    2   2   8   5   4
                ;; ess-brace-offset                  0   0  -8  -5  -4
                ;; ess-arg-function-offset           2   4   0   0   0
                ;; ess-expression-offset             4   2   8   5   4
                ;; ess-else-offset                   0   0   0   0   0
                ;; ess-close-brace-offset            0   0   0   0   0
                (add-hook 'local-write-file-hooks
                          (lambda ()
                            (ess-nuke-trailing-whitespace)))))
    (setq ess-nuke-trailing-whitespace-p 'ask)
    ;; or even
    ;; (setq ess-nuke-trailing-whitespace-p t)
    ;; Perl
    (add-hook 'perl-mode-hook
              (lambda () (setq perl-indent-level 4)))

    (defun spacemacs/ess-start-repl ()
      "Start a REPL corresponding to the ess-language of the current buffer."
      (interactive)
      (cond
       ((string= "S" ess-language) (call-interactively 'R))
       ((string= "STA" ess-language) (call-interactively 'stata))
       ((string= "SAS" ess-language) (call-interactively 'SAS))))

    (spacemacs/set-leader-keys-for-major-mode 'ess-julia-mode
      "si" 'julia)
    (spacemacs/set-leader-keys-for-major-mode 'ess-mode
      "si" 'spacemacs/ess-start-repl
      ;; noweb
      "cC" 'ess-eval-chunk-and-go
      "cc" 'ess-eval-chunk
      "cd" 'ess-eval-chunk-and-step
      "cm" 'ess-noweb-mark-chunk
      "cN" 'ess-noweb-previous-chunk
      "cn" 'ess-noweb-next-chunk
      ;; REPL
      "sB" 'ess-eval-buffer-and-go
      "sb" 'ess-eval-buffer
      "sD" 'ess-eval-function-or-paragraph-and-step
      "sd" 'ess-eval-region-or-line-and-step
      "sL" 'ess-eval-line-and-go
      "sl" 'ess-eval-line
      "sR" 'ess-eval-region-and-go
      "sr" 'ess-eval-region
      "sT" 'ess-eval-function-and-go
      "st" 'ess-eval-function
      ;; R helpers
      "hd" 'ess-R-dv-pprint
      "hi" 'ess-R-object-popup
      "ht" 'ess-R-dv-ctable
      )
    (define-key ess-mode-map (kbd "<s-return>") 'ess-eval-line)
    (define-key inferior-ess-mode-map (kbd "C-j") 'comint-next-input)
    (define-key inferior-ess-mode-map (kbd "C-k") 'comint-previous-input)))

(defun ess/init-ess-R-data-view ())

(defun ess/init-ess-R-object-popup ())

(defun ess/post-init-rainbow-delimiters ()
  (add-hook 'ess-mode-hook #'rainbow-delimiters-mode))

;; To enable smart-equals-mode
(defun ess/init-ess-smart-equals ()
  (use-package ess-smart-equals
    :defer t
    :if ess-enable-smart-equals
    :init
    ;; (setq ess-smart-equals-extra-ops '(brace paren percent))
    (progn
      (add-hook 'ess-mode-hook 'ess-smart-equals-mode)
      (add-hook 'inferior-ess-mode-hook 'ess-smart-equals-mode))))

;; To enable smartparens-mode in ess and iess
(defun ess/post-init-smartparens ()
  (use-package smartparens
    :defer t
    :if ess-enable-smartparens
    :diminish smartparens-mode
    :config
    (progn
      (require 'smartparens-config)
      (smartparens-global-mode 1)
      (sp-pair "\"" nil :unless '(sp-point-after-word-p))
      (sp-pair "'" nil :unless '(sp-point-after-word-p))
      (sp-local-pair '(ess-mode inferior-ess-mode) "(" nil :unless '(sp-point-before-word-p))
      (sp-local-pair '(ess-mode inferior-ess-mode) "[" nil :unless '(sp-point-before-word-p))
      (sp-local-pair '(ess-mode inferior-ess-mode) "{" nil :unless '(sp-point-before-word-p)))
    :init
    (progn
      (add-hook 'ess-mode-hook 'smartparens-mode)
      (add-hook 'inferior-ess-mode-hook 'smartparens-mode))))

;; To enable electric-spacing-mode in ess and iess
(defun ess/init-electric-spacing-r ()
  (use-package electric-spacing-r
    ;; :defer t
    :if ess-enable-electric-spacing-r
    :init
    (progn
      (add-hook 'ess-mode-hook 'electric-spacing-mode))))
      ;; (add-hook 'inferior-ess-mode-hook 'electric-spacing-mode))))

(defun ess/init-essh ()
  (use-package essh
    :config
    (progn
      (add-hook
       'sh-mode-hook
       #'(lambda ()
          (define-key sh-mode-map "\C-c\C-r" 'pipe-region-to-shell)
          (define-key sh-mode-map "\C-c\C-b" 'pipe-buffer-to-shell)
          (define-key sh-mode-map "\C-c\C-j" 'pipe-line-to-shell)
          ;; (define-key sh-mode-map "\C-c\C-n" 'pipe-line-to-shell-and-step)
          (define-key sh-mode-map (kbd "<C-return>") 'pipe-line-to-shell-and-step)
          (define-key sh-mode-map "\C-c\C-f" 'pipe-function-to-shell)
          (define-key sh-mode-map "\C-c\C-d" 'shell-cd-current-directory))))))

(defun wz-ess-find-and-insert-namespace (beg end)
  "Preceds a function with its namespace,
   so `mean(x) -> stats::mean(x)' and
   `xyplot(...) -> lattice::xyplot()'.
   Call this function in a R major mode buffer with the function name
   selected. By Walmes Zeviani."
  (interactive "r")
  (let ((string
         (replace-regexp-in-string
          "\"" "\\\\\\&"
          (replace-regexp-in-string
           "\\\\\"" "\\\\\\&"
           (buffer-substring-no-properties beg end))))
        (buf (get-buffer-create "*ess-command-output*")))
    (ess-force-buffer-current "Process to load into:")
    (ess-command
     (format
      "local({
           x <- \"%s\"
           cat(paste0(sub('.*:', '', utils::find(x)), '::', x), \"\\n\")
       })\n"
      string) buf)
    (with-current-buffer buf
      (goto-char (point-max))
      (let ((end (point)))
        (goto-char (point-min))
        (skip-chars-forward " +")
        (setq string (buffer-substring-no-properties (point) end))))
    (delete-region beg end)
    (insert string)
    (delete-char -1)))

(add-hook
 'ess-mode-hook
 (lambda ()
   (local-set-key (kbd "C-:") 'wz-ess-find-and-insert-namespace)))
