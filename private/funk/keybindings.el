;;======================================================================
;; Keybindings only
;;======================================================================

;; C-TAB move between buffers
(global-set-key [(control tab)] 'other-window)

;; Change font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)
