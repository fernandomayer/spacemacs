;; -*- lexical-binding: t -*-
;;
;; Author: Rainer Gemulla <rgemulla@gmx.de>
;;
;; This file is not part of GNU Emacs.
;;
;;; Code:

(defconst elpy-packages
  '(python
    elpy
    jedi))

(defun elpy/init-python ()
  (use-package python
    :defer t
    :mode (("\\.py\\'" . python-mode)
           ("\\.ipy\\'" . python-mode))
    :init
    (setq-default python-indent-offset 4)
    :config
    (add-hook 'inferior-python-mode-hook
              (lambda ()
                ;; disable smartscan-mode to make M-p and M-n select previous/next statement in python shell
                (when (featurep 'smartscan)
                  (smartscan-mode -1))

                ;; for some reason, q is bound to exit even in insert state -> undo this
                (define-key evil-insert-state-local-map "q" 'self-insert-command)
                ))
    ))

(defun elpy/init-jedi ()
  (use-package jedi
    :after python
    ))

(defun elpy/init-elpy ()
  (use-package elpy
    :after (python jedi)
    :config
    ;; enable elpy
    (elpy-enable)

    ;; set lighter
    (diminish 'elpy-mode " Ⓔ")

    ;; configure auto-completion
    (setq elpy-rpc-backend "jedi")
    (add-hook  'elpy-mode-hook
               '(lambda ()
                  ;; after 2 seconds or C-tab
                  (setq company-minimum-prefix-length 2)
                  (setq company-idle-delay 2)
                  (define-key elpy-mode-map (kbd "S-<tab>") 'company-complete)))

    ;; python-mode key bindings
    (spacemacs/declare-prefix-for-mode 'python-mode "mh" "help")
    (spacemacs/declare-prefix-for-mode 'python-mode "mg" "goto")
    (spacemacs/declare-prefix-for-mode 'python-mode "me" "send to REPL")
    (spacemacs/declare-prefix-for-mode 'python-mode "ms" "send to REPL and step")
    (spacemacs/declare-prefix-for-mode 'python-mode "mr" "refactor")
    (spacemacs/declare-prefix-for-mode 'python-mode "mV" "pyvenv")
    (spacemacs/declare-prefix-for-mode 'python-mode "mn" "notebook")
    (spacemacs/declare-prefix-for-mode 'python-mode "mt" "toggle")
    (spacemacs/set-leader-keys-for-major-mode 'python-mode
      "hh" 'elpy-doc
      "ga" 'elpy-goto-assignment
      "gA" 'elpy-goto-assignment-other-window
      "go" 'elpy-occur-definitions
      "gi" 'elpy-shell-switch-to-shell
      "gI" 'elpy-shell-switch-to-shell-in-current-window
      "ee" 'elpy-shell-send-statement
      "eE" 'elpy-shell-send-statement-and-go
      "es" 'elpy-shell-send-top-statement
      "eS" 'elpy-shell-send-top-statement-and-go
      "ef" 'elpy-shell-send-defun
      "eF" 'elpy-shell-send-defun-and-go
      "ec" 'elpy-shell-send-defclass
      "eC" 'elpy-shell-send-defclass-and-go
      "eg" 'elpy-shell-send-group
      "eG" 'elpy-shell-send-group-and-go
      "ew" 'elpy-shell-send-codecell
      "eW" 'elpy-shell-send-codecell-and-go
      "er" 'elpy-shell-send-region-or-buffer
      "eR" 'elpy-shell-send-region-or-buffer-and-go
      "eb" 'elpy-shell-send-buffer
      "eB" 'elpy-shell-send-buffer-and-go
      "se" 'elpy-shell-send-statement-and-step
      "sE" 'elpy-shell-send-statement-and-step-and-go
      "ss" 'elpy-shell-send-top-statement-and-step
      "sS" 'elpy-shell-send-top-statement-and-step-and-go
      "sf" 'elpy-shell-send-defun-and-step
      "sF" 'elpy-shell-send-defun-and-step-and-go
      "sc" 'elpy-shell-send-defclass-and-step
      "sC" 'elpy-shell-send-defclass-and-step-and-go
      "sg" 'elpy-shell-send-group-and-step
      "sG" 'elpy-shell-send-group-and-step-and-go
      "sw" 'elpy-shell-send-codecell-and-step
      "sW" 'elpy-shell-send-codecell-and-step-and-go
      "sr" 'elpy-shell-send-region-or-buffer-and-step
      "sR" 'elpy-shell-send-region-or-buffer-and-step-and-go
      "sb" 'elpy-shell-send-buffer-and-step
      "sB" 'elpy-shell-send-buffer-and-step-and-go
      "rc" 'elpy-check
      "re" 'elpy-multiedit
      "rf" 'elpy-format-code
      "rr" 'elpy-refactor
      "rs" 'elpy-rgrep-symbol
      "Va" 'pyvenv-activate
      "Vd" 'pyvenv-deactivate
      "Vw" 'pyvenv-workon
      "nc" 'elpy/insert-codecell-above
      "nm" 'elpy/insert-markdowncell-above)

    ;; jump handlers
    (add-to-list 'spacemacs-jump-handlers-python-mode
                 '(elpy-goto-definition) t)
    (add-to-list 'spacemacs-jump-handlers-python-mode
                 '(dumb-jump-go) t)

    ;; inferior-python-mode key bindings
    (spacemacs/declare-prefix-for-mode 'inferior-python-mode "mg" "goto")
    (spacemacs/set-leader-keys-for-major-mode 'inferior-python-mode
      "gi" 'elpy-shell-switch-to-buffer
      "gI" 'elpy-shell-switch-to-buffer-in-current-window)
    (with-eval-after-load 'counsel
      (define-key inferior-python-mode-map (kbd "C-r") 'counsel-shell-history))
    (with-eval-after-load 'helm
      (define-key inferior-python-mode-map (kbd "C-r") 'spacemacs/helm-shell-history))

    ;; toggles
    (spacemacs/declare-prefix-for-mode 'python-mode "mt" "toggles")
    (spacemacs|add-toggle elpy/shell-display-buffer-after-send
      :documentation "Toggles whether to show the python shell after sending something to it"
      :status elpy-shell-display-buffer-after-send
      :on (setq elpy-shell-display-buffer-after-send t)
      :off (setq elpy-shell-display-buffer-after-send nil)
      :evil-leader-for-mode (python-mode . "td"))

    (spacemacs|add-toggle elpy/shell-echo-input
      :documentation "Toggles whether to echo input sent to the Python shell in the shell buffer"
      :status elpy-shell-echo-input
      :on (setq elpy-shell-echo-input t)
      :off (setq elpy-shell-echo-input nil)
      :evil-leader-for-mode (python-mode . "ti"))

    (spacemacs|add-toggle elpy/shell-echo-output
      :documentation "Toggles whether to echo the Python shell output in the echo area"
      :status elpy-shell-echo-output
      :on (setq elpy-shell-echo-output 'when-shell-not-visible)
      :off (setq elpy-shell-echo-output nil)
      :evil-leader-for-mode (python-mode . "to"))
    ))
