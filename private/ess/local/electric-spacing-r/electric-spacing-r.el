;;; electric-spacing-r.el --- Insert operators with surrounding spaces smartly

;; Copyright (C) 2004, 2005, 2007-2016 Free Software Foundation, Inc.

;; Author: William Xu <william.xwl@gmail.com>
;; Version: 5.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with EMMS; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Smart Operator mode is a minor mode which automatically inserts
;; surrounding spaces around operator symbols.  For example, `='
;; becomes ` = ', `+=' becomes ` += '.  This is most handy for writing
;; C-style source code.  Also follows the R-style when in ess-mode.
;;
;; Type `M-x electric-spacing-mode' to toggle this minor mode.

;;; Contributions

;; Contributions made by Walmes Zeviani <walmeszeviani@gmail.com> to
;; adapt the Smart Operator mode to R-style source code.

;;; Acknowledgements

;; Nikolaj Schumacher <n_schumacher@web.de>, for suggesting
;; reimplementing as a minor mode and providing an initial patch for
;; that.

;;; Code:

;;; electric-spacing minor mode

(defcustom electric-spacing-double-space-docs t
  "Enable double spacing of . in document lines - e,g, type '.' => get '.  '."
  :type 'boolean
  :group 'electricity)

(defcustom electric-spacing-docs t
  "Enable electric-spacing in strings and comments."
  :type 'boolean
  :group 'electricity)

(defvar electric-spacing-rules
  '((?= . electric-spacing-self-insert-command)
    (?| . electric-spacing-self-insert-command)
    (?& . electric-spacing-self-insert-command)
    (?+ . electric-spacing-+)
    (?- . electric-spacing--)
    (?* . electric-spacing-*)
    (?< . electric-spacing-<)
    (?> . electric-spacing->)
    (?! . electric-spacing-!)
    (?% . electric-spacing-%)
    (?~ . electric-spacing-~)
    (?. . electric-spacing-.)
    (?/ . electric-spacing-/)
    (?{ . electric-spacing-{)
    ;; (?( . electric-spacing-\()
    (?, . electric-spacing-\,)
    ;; (?: . electric-spacing-:)
    ;; (?? . electric-spacing-?)
  ))

(defun electric-spacing-post-self-insert-function ()
  (when (electric-spacing-should-run?)
    (let ((rule (cdr (assq last-command-event electric-spacing-rules))))
      (when rule
        (goto-char (electric--after-char-pos))
        (delete-char -1)
        (funcall rule)))))

;;;###autoload
(define-minor-mode electric-spacing-mode
  "Toggle automatic surrounding space insertion (Electric Spacing mode).
   With a prefix argument ARG, enable Electric Spacing mode if
   ARG is positive, and disable it otherwise.  If called from
   Lisp, enable the mode if ARG is omitted or nil.

   This is a local minor mode.  When enabled, typing an operator
   automatically inserts surrounding spaces.  e.g., `=' becomes `
   = ',`+=' becomes ` += '.  This is very handy for many
   programming languages."
  :global nil
  :group 'electricity
  :lighter " _+_"

  ;; body
  (if electric-spacing-mode
      (add-hook 'post-self-insert-hook
                #'electric-spacing-post-self-insert-function nil t)
    (remove-hook 'post-self-insert-hook
                 #'electric-spacing-post-self-insert-function t)))

(defun electric-spacing-self-insert-command ()
  "Insert character with surrounding spaces."
  (electric-spacing-insert (string last-command-event)))

(defun electric-spacing-insert (op &optional only-where)
  "See `electric-spacing-insert-1'."
  (delete-horizontal-space)
  (cond ((and (electric-spacing-lispy-mode?)
              (not (electric-spacing-document?)))
         (electric-spacing-lispy op))
        (t
         (electric-spacing-insert-1 op only-where))))

(defun electric-spacing-insert-1 (op &optional only-where)
  "Insert operator OP with surrounding spaces.
   e.g., `=' becomes ` = ', `+=' becomes ` += '.
    - When `only-where' is 'after, we will insert space at back only;
    - when `only-where' is 'before, we will insert space at front only;
    - when `only-where' is 'middle, we will not insert space."
  (pcase only-where
    (`before (insert " " op))
    (`middle (insert op))
    (`after (insert op " "))
    (`both (insert " " op " "))
    (_
     (let ((begin? (bolp)))
       (unless
           (or (looking-back
                (regexp-opt
                 (mapcar 'char-to-string
                         (mapcar 'car electric-spacing-rules)))
                (line-beginning-position))
               begin?)
         (insert " "))
       (insert op " ")
       (when begin?
         (indent-according-to-mode))))))

(defun electric-spacing-document? ()
  (nth 8 (syntax-ppss)))

(defun electric-spacing-should-run? ()
  (or (not electric-spacing-docs)
      (not (electric-spacing-document?))))

(defun electric-spacing-lispy-mode? ()
  (derived-mode-p 'emacs-lisp-mode
                  'lisp-mode
                  'lisp-interaction-mode
                  'scheme-mode))

(defun electric-spacing-lispy (op)
  "We're in a Lisp-ish mode, so let's look for parenthesis.
   Meanwhile, if not found after ( operators are more likely to
   be function names, so let's not get too insert-happy."
  (cond
   ((save-excursion
      (backward-char 1)
      (looking-at "("))
    (if (equal op ",")
        (electric-spacing-insert-1 op 'middle)
      (electric-spacing-insert-1 op 'after)))
   ((equal op ",")
    (electric-spacing-insert-1 op 'before))
   (t
    (electric-spacing-insert-1 op 'middle))))

(defconst electric-spacing-operators-regexp
  (regexp-opt
   (mapcar (lambda (el) (char-to-string (car el)))
           electric-spacing-rules)))

;;;---------------------------------------------------------------------
;;; Fine Tunings - eletric-spacing-* functions.

;;-------------------------------------------
;; Arithmetic operators.

(defun electric-spacing-* ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | a * b
         ;; | a %*% b
         ;; | a**b = a^b
         ;; | y ~ a + . * b
         ;; `----
         (cond ((looking-back "% *" 1)
                (electric-spacing-insert "*" 'middle))
               ((looking-back " \\* *" 1)
                (fixup-whitespace)
                (delete-char -1)
                (fixup-whitespace)
                (insert " %*% "))
               ((looking-back "[~.] *" 1)
                (electric-spacing-insert "*" 'both))
               (t
                (electric-spacing-insert "*"))))
        ((derived-mode-p 'python-mode)
         ;; ,----[ cases ]
         ;; | a * b
         ;; | "string" * 10
         ;; | a**b
         ;; `----
         (cond ((looking-back " \\* *" 1)
                (delete-char -3)
                (insert "**"))
               (t
                (electric-spacing-insert "*"))))
        (t
         (electric-spacing-insert "*"))
        ))

(defun electric-spacing-+ ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode 'python-mode)
         ;; ,----[ cases ]
         ;; | a + b
         ;; | y ~ a + b
         ;; | y ~ . + b
         ;; | 10e+5
         ;; | 10E+5
         ;; `----
         (cond ((looking-back "[~.] *" 1)
                (electric-spacing-insert "+" 'both))
               ((looking-back "[([{/^] *" 1)
                (insert "+"))
               ((looking-back "[0-9.]+[eE] *" 1)
                (insert "+"))
               ((looking-back "^\\s-*" 1)
                (insert "+"))
               (t
                (electric-spacing-insert "+")))
         )
        (t
         (electric-spacing-insert "+"))))

(defun electric-spacing-- ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | a - b
         ;; | a * (-b)
         ;; | a * -b
         ;; | a + -b
         ;; | a & -5 > b
         ;; | a | -5 > b
         ;; | a < -5
         ;; | a > -5
         ;; | y ~ -1+x
         ;; | y ~ . - x
         ;; | a = -5
         ;; | a <- -5
         ;; | a[-b, -x]
         ;; | c(1, -2)
         ;; | 10e-5
         ;; | 10E-5
         ;; | 10^-5
         ;; | 10/-5
         ;; | 10/-5
         ;; |    -5
         ;; |    -.5
         ;; `----
         (cond ((or (looking-back "[=~,*+<>&|.] *" 1)
                    (looking-back "<- *" 1))
                (electric-spacing-insert "-" 'before))
               ((looking-back "[([{/^] *" 1)
                (insert "-"))
               ((looking-back "[0-9.]+[eE]" 1)
                (insert "-"))
               ((looking-back "^\\s-*" 1)
                (insert "-"))
               (t
                (electric-spacing-insert "-"))))
        ;; exponent notation, e.g. 1e-10: don't space
        ((looking-back "[0-9.]+[eE]" 1)
         (insert "-"))
        ;; a = -9
        ((and
          (looking-back (concat electric-spacing-operators-regexp " *") 1)
          (not (looking-back "- *" 1)))
         (electric-spacing-insert "-" 'before))
        (t
         (electric-spacing-insert "-"))))

;;-------------------------------------------
;; Relational operators.

(defun electric-spacing-> ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | 5 < 7
         ;; | 5 <= 7
         ;; | iris %>%
         ;; |     filter(...)
         ;; `----
         (cond ((looking-at " *=")
                (electric-spacing-insert ">" 'before))
               ((looking-back " > *" 1)
                (fixup-whitespace)
                (delete-char -1)
                (fixup-whitespace)
                (insert " %>%\n")
                (ess-indent-or-complete))
               (t
                (electric-spacing-insert ">"))))
        ((derived-mode-p 'python-mode)
         ;; ,----[ cases ]
         ;; | 5 < 7
         ;; | 5 <= 7
         ;; `----
         (cond ((looking-at " *=")
                (electric-spacing-insert ">" 'before))
               (t
                (electric-spacing-insert ">"))))
        (t
         (electric-spacing-insert ">"))))

(defun electric-spacing-< ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | 5 > 7
         ;; | 5 >= 7
         ;; | x <<- 10
         ;; `----
         (cond ((looking-at " *=")
                (electric-spacing-insert "<" 'before))
               ((looking-back " < *" 1)
                (fixup-whitespace)
                (delete-char -1)
                (fixup-whitespace)
                (insert " <<- "))
               (t
                (electric-spacing-insert "<"))))
        ((derived-mode-p 'python-mode)
         ;; ,----[ cases ]
         ;; | 5 < 7
         ;; | 5 <= 7
         ;; `----
         (cond ((looking-at " *=")
                (electric-spacing-insert "<" 'before))
               (t
                (electric-spacing-insert "<"))))
        (t
         (electric-spacing-insert "<"))))

(defun electric-spacing-! ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | x <- !y
         ;; | x = !y
         ;; | x & !y
         ;; | x | !y
         ;; | a != b
         ;; | 2 != 4
         ;; | y[!a, !b]
         ;; | if (!x) ...
         ;; | if (a) { !b } ...
         ;; | x + !y
         ;; | x * !y
         ;; `----
         (cond ((looking-back "[{([] *" 1)
                (insert "!"))
               ((looking-back "[[:alnum:],=|&*+-] *" 1)
                (electric-spacing-insert "!" 'before))
               (t
                (insert "!"))))
        (t
         (insert "!"))))

;;-------------------------------------------
;; Other operators.

;; BUG: the %op% operator has something special that I didn't
;; understand. The rules does't apply to the openning % of the pair. I
;; think that this can be related to font face. Only the closing % of
;; the pair is affected by the rules below programmed. Meanwhile, to
;; solve the problem, the package key-combo can be used to set the rules
;; for the opening %. See the file
;; https://github.com/walmes/emacs/blob/master/init.el to details.

;; SOLVED: the above related problem was solved using the
;; `save-excursion' block.

(defun electric-spacing-% ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | a %*% b
         ;; | a %/% b
         ;; | a %% b
         ;; | a %>% b
         ;; | a %o% b
         ;; | a %in% b
         ;; | sprintf("%d %d\n", a, b)
         ;; `----
         (cond ((looking-back "[%][[:alnum:]$!?<>=_*+/.-]+ *" 1)
                (save-excursion
                  (search-backward "%")
                  (fixup-whitespace))
                (electric-spacing-insert "%" 'after))
               ((looking-back "% *" 1)
                (fixup-whitespace)
                (delete-char -1)
                (electric-spacing-insert "%%" 'both))
               (t
                (electric-spacing-insert "%"))))
        ((derived-mode-p 'python-mode)
         ;; ,----[ cases ]
         ;; | a % b
         ;; | "%0.2f" % 3.1415
         ;; `----
         (cond ((looking-back "% *" 1)
                (electric-spacing-insert "%" 'after))
               (t
                (electric-spacing-insert "%"))))
        (t
         (insert "%"))))

(defun electric-spacing-~ ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | a ~ b
         ;; | ~a + b
         ;; | x <- ~a + b
         ;; | x = ~a + b
         ;; | c(~a + b, ~x + y)
         ;; | update(model, . ~ .)
         ;; `----
         (cond ((looking-back "\\(<-\\|[=,.]\\) *" 1)
                (electric-spacing-insert "~" 'before))
               ((looking-back "( *" 1)
                (insert "~"))
               ((looking-back "^\\s-*" 1)
                (insert "~"))
               (t
                (electric-spacing-insert "~"))))
        (t
         (insert "~"))))

(defun electric-spacing-. ()
  "See `electric-spacing-insert'."
  (cond ((and electric-spacing-double-space-docs
              (electric-spacing-document?))
         (electric-spacing-insert "." 'after)
         (insert " "))
        ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | read.table()
         ;; | plot.default()
         ;; | 3.14
         ;; | 2 + .5
         ;; | x <- .5
         ;; | x = .5
         ;; | c(.9, .5)
         ;; | lm(y ~ .)
         ;; | update(model, . ~ . + I(x^2))
         ;; | function(x, ...)
         ;; | obj$.x
         ;; | obj@.x
         ;; | .Machine$double.xmin
         ;; | fun <- .Call(...)
         ;; `----
         (cond ((or (looking-back "[0-9({[.] *" 1)
                    (looking-back "[A-Za-z]" 1))
                (insert "."))
               ((looking-back "[,*+=~-] *" 1)
                (electric-spacing-insert "." 'before))
               (t
                (insert "."))))
        ((derived-mode-p 'python-mode)
         ;; ,----[ cases ]
         ;; | pd.read_csv()
         ;; | 3.14
         ;; | 2 + .5
         ;; | x = .5
         ;; | (.9, .5)
         ;; | [.9, .5]
         ;; | .Machine.double.xmin
         ;; | fun = .hidden()
         ;; `----
         (cond ((or (looking-back "[0-9([.] *" 1)
                    (looking-back "[A-Za-z]" 1))
                (insert "."))
               ((looking-back "[,*+=-] *" 1)
                (electric-spacing-insert "." 'before))
               (t
                (insert "."))))
        (t
         (electric-spacing-insert "." 'after)
         (insert " "))))

(defun electric-spacing-/ ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'ess-mode)
         ;; ,----[ cases ]
         ;; | 5/3
         ;; | 5 %/% 3
         ;; `----
         (cond ((looking-back "/ *" 1)
                (fixup-whitespace)
                (delete-char -1)
                (electric-spacing-insert "%/%" 'both))
               (t
                (electric-spacing-insert "/" 'middle))))
        (t
         (insert "/"))))

(defun electric-spacing-{ ()
  "See `electric-spacing-insert'."
  (cond ((and (derived-mode-p 'ess-mode)
              (or (looking-back "[^[:alnum:]_.]\\(repeat\\|else\\) *" 1)
                  (looking-back ") *" 1)))
         ;; ,----[ cases ]
         ;; | for (i in 1:10) { ...
         ;; | function(x) { ...
         ;; | repeat { ...
         ;; | else { ...
         ;; `----
         (electric-spacing-insert "{" 'before))
        (t
         (insert "{"))))

(defun electric-spacing-\( ()
  "See `electric-spacing-insert'."
  (cond ((and (derived-mode-p 'ess-mode)
              (looking-back "[^[:alnum:]_.]\\(for\\|if\\|while\\) *" 1))
         ;; ,----[ cases ]
         ;; | for (i in 1:10) { ...
         ;; | if (x == 2) { ...
         ;; | while (x < 10) { ...
         ;; `----
         (electric-spacing-insert "(" 'before))
        (t
         (insert "("))))

(defun electric-spacing-\, ()
  "See `electric-spacing-insert'."
  (cond ((derived-mode-p 'python-mode)
         ;; ,----[ cases ]
         ;; | (1, 2, 3)
         ;; | [1, 2, 3]
         ;; | ([1, 2, 3], [123, 234, 345])
         ;; `----
         (electric-spacing-insert "," 'after))
        (t
         (insert ","))))

;; (defun electric-spacing-: ()
;;   "See `electric-spacing-insert'."
;;   (cond ((derived-mode-p 'ess-mode)
;;          (insert ":"))
;;         (t
;;          (electric-spacing-insert ":" 'after))))
;;
;; (defun electric-spacing-? ()
;;   "See `electric-spacing-insert'."
;;   (cond ((derived-mode-p 'ess-mode)
;;          (electric-spacing-insert "?"))
;;         (t
;;          (electric-spacing-insert "?" 'after))))

;;----------------------------------------------------------------------

(provide 'electric-spacing-r)

;;; electric-spacing-r.el ends here
