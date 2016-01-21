;;======================================================================
;; Functions only
;;======================================================================

;;======================================================================
;; (R) markdown mode
;;======================================================================

;; Insert a new (empty) chunk to R markdown ============================
(defun insert-chunk ()
  "Insert chunk environment Rmd sessions."
  (interactive)
  (insert "```{r}\n\n```")
  (forward-line -1)
  )
;; key binding
(global-set-key (kbd "C-c i") 'insert-chunk)

;; Mark a word at a point ==============================================
;; http://www.emacswiki.org/emacs/ess-edit.el
(defun ess-edit-word-at-point ()
  (save-excursion
    (buffer-substring
     (+ (point) (skip-chars-backward "a-zA-Z0-9._"))
     (+ (point) (skip-chars-forward "a-zA-Z0-9._")))))
;; eval any word where the cursor is (objects, functions, etc)
(defun ess-eval-word ()
  (interactive)
  (let ((x (ess-edit-word-at-point)))
    (ess-eval-linewise (concat x)))
)
;; key binding
(global-set-key (kbd "C-c r") 'ess-eval-word)

;;======================================================================
;; Text functions
;; From @walmes in
;; https://github.com/walmes/emacs/blob/master/functions.el
;;======================================================================

;; Duplicate lines =====================================================
(defun duplicate-line ()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank)
  )
;; key binding
(global-set-key (kbd "\C-c d") 'duplicate-line)

;; (un)Comment without selection =======================================
(defun comment-line-or-region ()
  "Comment or uncomment current line, or current text selection."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region
       (region-beginning)
       (region-end)
       )
    (comment-or-uncomment-region
     (line-beginning-position)
     (line-beginning-position 2)
     )
    )
  )
;; key binding
(global-set-key (kbd "M-;") 'comment-line-or-region)

;; Commented rules to divide code ======================================
(defun blank-line-p ()
  (string-match "^[[:space:]]*$"
                (buffer-substring-no-properties
                 (line-beginning-position)
                 (line-end-position) )))

(defun insert-rule-from-point-to-margin (&optional rule-char)
  "Insert a commented rule with dashes (-) from the `point' to
   the `fill-column' if the line has only spaces. If the line has
   text, fill with dashes until the `fill-column'. Useful to
   divide your code in sections. If a non nil prefix argument is
   passed, then (=) is used instead."
  (interactive)
  (if (blank-line-p)
      (progn
        (insert "-")
        (comment-line-or-region)
        (delete-char -2))
    nil)
  (if rule-char
      (insert (make-string (- fill-column (current-column)) ?=))
    (insert (make-string (- fill-column (current-column)) ?-)))
  )
;; key binding
(global-set-key [?\M--] 'insert-rule-from-point-to-margin)
(global-set-key [?\M-=]
                (lambda ()
                  (interactive)
                  (insert-rule-from-point-to-margin 1)))

(defun insert-rule-and-comment-3 ()
  "Insert a commented rule with 43 dashes (-). Useful to divide
   your code in sections."
  (interactive)
  (insert (make-string 43 ?-))
  (comment-or-uncomment-region
   (line-beginning-position)
   (line-beginning-position 2))
  (backward-char 44)
  (delete-char 1)
  (move-end-of-line nil)
  )
;; key binding
(global-set-key [?\C--] 'insert-rule-and-comment-3)


;; Move lines ==========================================================
;; http://www.emacswiki.org/emacs/MoveLine
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

(global-set-key (kbd "M-[") 'move-line-up)
(global-set-key (kbd "M-]") 'move-line-down)

;; Move regions ========================================================
(defun move-region (start end n)
  "Move the current region up or down by N lines."
  (interactive "r\np")
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (let ((start (point)))
      (insert line-text)
      (setq deactivate-mark nil)
      (set-mark start))))

(defun move-region-up (start end n)
  "Move the current line up by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) -1 (- n))))

(defun move-region-down (start end n)
  "Move the current line down by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) 1 n)))

(global-set-key (kbd "M-{") 'move-region-up)
(global-set-key (kbd "M-}") 'move-region-down)

;;======================================================================

;; To revert-buffer without confirmation ===============================
;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer t t))
;; key binding
(global-set-key [f5] 'revert-buffer-no-confirm)

;; COPY the current line, whithout selecting it ========================
;; Source: http://www.emacswiki.org/emacs/CopyingWholeLines
(defun quick-copy-line ()
  "Copy the whole line that point is on and move to the beginning of the next line.
    Consecutive calls to this command append each line to the
    kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end))))
  (beginning-of-line 2))
;; key binding
;; (global-set-key "\C-c\M-w" 'quick-copy-line)
(global-set-key (kbd "C-<insert>") 'quick-copy-line)

;; CUT the current line without selecting it
(defun quick-cut-line ()
  "Cut the whole line that point is on. Consecutive calls to this
command append each line to the kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-cut-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end)))
    (delete-region beg end))
  (beginning-of-line 1)
  (setq this-command 'quick-cut-line))
;; key binding
;; (global-set-key "\C-c\M-k" 'quick-cut-line)
(global-set-key (kbd "s-<delete>") 'quick-cut-line)
