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
