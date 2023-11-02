;;; config.el --- ESS Layer configuration File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Variables

(defvar ess-enable-smart-equals nil
  "If non-nil smart-equal support is enabled")

(defvar ess-enable-smartparens nil
  "If non-nil smartparens support is enabled")

;; List of available commands to weave Rnw files. This changes the
;; default to pdflatex
(setq ess-swv-pdflatex-commands '("pdflatex" "make" "texi2pdf"))

;; Set ess-eval-visibly to true, since from version 19.04 (March 2020),
;; it was set to nil by default. When non-nil, this makes code sent to
;; iESS buffer to appear in the console, instead of appearing only
;; outputs.
(setq ess-eval-visibly t)

;; No indent levels, i.e., no more identation with one '#'
(setq ess-indent-with-fancy-comments nil)

(setq ess-offset-arguments 'prev-line)

;;======================================================================
;; Content from ess-style-alist

;; ess-style-alist is a variable defined in ‘ess-custom.el’.

;; Its value is shown below.

;; Predefined formatting styles for ESS code.
;; Use ‘ess-set-style’ to apply a style in all R buffers. The values of
;; all styles except OWN are fixed. To change the value of variables
;; in the OWN group, customize the variable ‘ess-own-style-list’.
;; DEFAULT style picks default (aka global) values from ESS
;; indentation variables. In addition, ESS provides many indentation
;; styles, the most important being the RRR and the RStudio
;; variants.

;; RRR is the common R style that adheres closely to R internal
;; standards. RRR+ is the same except it also aligns blocks in
;; function calls with the opening delimiter, producing more
;; indentation. The C++ style (named like this for historical
;; reasons rather than any resemblance to existing C++ indentation
;; schemes) is halfway between these two styles and indent block
;; arguments from the start of the surrounding function’s name.

;; The RStudio style closely mimics the indentation of the RStudio
;; editor. RStudio- is the same except it does not align arguments
;; in function calls, which corresponds to the settings of some
;; RStudio users.

;; ESS indentation is fully specified by the following offsets and
;; variables. See the documentation of these variables for examples.

;; Offsets:

;;  - ‘ess-indent-offset’: main offset inherited by other settings

;;  - ‘ess-offset-arguments’: offset type for function and bracket
;;    arguments

;;  - ‘ess-offset-arguments-newline’: offset type of arguments
;;    when ( or [ is followed by a new line.

;;  - ‘ess-offset-block’: offset type for brace and anonymous
;;    parenthesis blocks

;;  - ‘ess-offset-continued’: offset type for continuation lines in
;;    multiline statements


;; Overrides (implies vertical alignment):

;;  - ‘ess-align-nested-calls’: functions whose nested calls
;;    should be aligned.

;;  - ‘ess-align-arguments-in-calls’: calls where
;;    ‘ess-offset-arguments’ should be ignored

;;  - ‘ess-align-continuations-in-calls’: whether to ignore
;;    ‘ess-offset-continued’ in calls.

;;  - ‘ess-align-blocks’: whether to ignore ‘ess-offset-blocks’ for
;;    function declarations or control flow statements.


;; Control variables:

;;  - ‘ess-indent-from-lhs’: whether to indent arguments from
;;    left-hand side of an assignment or parameter declaration.

;;  - ‘ess-indent-from-chain-start’: whether to indent arguments from
;;    the first of several consecutive calls.

;;  - ‘ess-indent-with-fancy-comments’: whether to indent #, ## and
;;    ### comments distinctly.

;; Value:
;; ((OWN
;;   (ess-indent-offset . 2)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-line)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls "ifelse")
;;   (ess-align-arguments-in-calls "function[ 	]*(")
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks control-flow)
;;   (ess-indent-from-lhs arguments fun-decl-opening)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (BSD
;;   (ess-indent-offset . 8)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-call)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls . #1=("ifelse"))
;;   (ess-align-arguments-in-calls . #2=("function[ 	]*("))
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3=(control-flow))
;;   (ess-indent-from-lhs . #4=(arguments fun-decl-opening))
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (C++
;;   (ess-indent-offset . 4)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-call)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls . #1#)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3#)
;;   (ess-indent-from-lhs arguments)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (CLB
;;   (ess-indent-offset . 2)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-line)
;;   (ess-offset-continued straight 4)
;;   (ess-align-nested-calls . #1#)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3#)
;;   (ess-indent-from-lhs . #4#)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (GNU
;;   (ess-indent-offset . 2)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline prev-call 4)
;;   (ess-offset-block . prev-line)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls . #1#)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3#)
;;   (ess-indent-from-lhs . #4#)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (K&R
;;   (ess-indent-offset . 5)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-call)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls . #1#)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3#)
;;   (ess-indent-from-lhs . #4#)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (RRR
;;   (ess-indent-offset . 4)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-line)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls . #1#)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3#)
;;   (ess-indent-from-lhs . #4#)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (RRR+
;;   (ess-indent-offset . 4)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . open-delim)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls . #1#)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls . t)
;;   (ess-align-blocks . #3#)
;;   (ess-indent-from-lhs arguments)
;;   (ess-indent-from-chain-start)
;;   (ess-indent-with-fancy-comments))
;;  (RStudio
;;   (ess-indent-offset . 2)
;;   (ess-offset-arguments . open-delim)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-line)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls)
;;   (ess-align-blocks)
;;   (ess-indent-from-lhs arguments)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (RStudio-
;;   (ess-indent-offset . 2)
;;   (ess-offset-arguments . prev-line)
;;   (ess-offset-arguments-newline . prev-line)
;;   (ess-offset-block . prev-line)
;;   (ess-offset-continued . straight)
;;   (ess-align-nested-calls)
;;   (ess-align-arguments-in-calls . #2#)
;;   (ess-align-continuations-in-calls)
;;   (ess-align-blocks)
;;   (ess-indent-from-lhs arguments)
;;   (ess-indent-from-chain-start . t)
;;   (ess-indent-with-fancy-comments))
;;  (DEFAULT
;;    (ess-indent-offset . 2)
;;    (ess-offset-arguments . open-delim)
;;    (ess-offset-arguments-newline . prev-line)
;;    (ess-offset-block . prev-line)
;;    (ess-offset-continued . straight)
;;    (ess-align-nested-calls . #1#)
;;    (ess-align-arguments-in-calls . #2#)
;;    (ess-align-continuations-in-calls . t)
;;    (ess-align-blocks . #3#)
;;    (ess-indent-from-lhs . #4#)
;;    (ess-indent-from-chain-start . t)
;;    (ess-indent-with-fancy-comments)))

;; [back]

;;======================================================================
