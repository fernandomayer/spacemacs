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
