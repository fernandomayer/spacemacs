;;; packages.el --- polymode layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Walmes Zeviani & Fernando Mayer
;; URL: https://github.com/syl20bnr/spacemacs

;;; Code:

(defconst polymode-packages
  '(polymode))

(defun polymode/init-polymode ()
  (use-package polymode
    :mode (("\\.Rmd"   . Rmd-mode))
    :init
    (progn
      (defun Rmd-mode ()
        "ESS Markdown mode for Rmd files"
        (interactive)
        (require 'poly-R)
        (require 'poly-markdown)
        (R-mode)
        (poly-markdown+r-mode))
      ))
  (use-package polymode
    :mode (("\\.Rnw"   . Rnw-mode))
    :init
    (progn
      (defun Rnw-mode ()
        "ESS LaTeX mode for Rnw files"
        (interactive)
        (require 'poly-R)
        (require 'poly-noweb)
        (R-mode)
        (poly-noweb+r-mode))
      ))
  )

;;; packages.el ends here
