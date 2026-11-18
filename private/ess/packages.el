;;; -*- lexical-binding: t; -*-

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
        essgd
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

      ;; (defun add-pipe-native ()
      ;;   (interactive)
      ;;   (end-of-line)
      ;;   (unless (looking-back "|>" nil)
      ;;     (just-one-space 1)
      ;;     (insert "|>"))
      ;;   (save-excursion
      ;;     ;; (forward-line 1)
      ;;     (next-line 1)
      ;;     (beginning-of-line)
      ;;     (if (looking-at-p "[[:blank:]][[:alpha:]]$")  ; Check if the next line is empty
      ;;         (indent)
      ;;       (newline))))

      ;; (defun add-pipe-native ()
      ;;   (interactive)
      ;;   (end-of-line)
      ;;   (unless (looking-back "|>" nil)
      ;;     (just-one-space 1)
      ;;     (insert "|>"))
      ;;   (save-excursion
      ;;     (forward-line 1)
      ;;     (beginning-of-line)
      ;;     (if (looking-at-p "^\\s-*$") ; Check if the next line is empty
      ;;         (delete-blank-lines)
      ;;       (newline-and-indent))))

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

  ;; Estilo de indentação -------------------------------------------------------
  ;; Estilo próprio (OWN): recuo de 4, sempre a partir do início da linha que
  ;; abriu a chamada ou o bloco, sem alinhar ao parêntese nem ao if (o C++ do
  ;; ESS atual alinha os dois). A exceção são os argumentos de function(),
  ;; alinhados ao parêntese. É o RStudio- com recuo 4. O mesmo estilo está em
  ;; ~/git/ai-instructions/formata.el, e os dois precisam ficar iguais.
  ;;
  ;; Fica fora do bloco do ess-site: um .qmd aberto antes de qualquer .R carrega
  ;; só o ess-r-mode, pelo polymode, e o ess-site não chega a ser carregado. O
  ;; ess-custom carrega nos dois casos.
  (with-eval-after-load 'ess-custom
    (customize-set-variable
     'ess-own-style-list
     '((ess-indent-offset . 4)
       (ess-offset-arguments . prev-line)
       (ess-offset-arguments-newline . prev-line)
       (ess-offset-block . prev-line)
       (ess-offset-continued . straight)
       (ess-align-nested-calls)
       (ess-align-arguments-in-calls "function[ \t]*(")
       (ess-align-continuations-in-calls)
       (ess-align-blocks)
       (ess-indent-from-lhs arguments)
       (ess-indent-from-chain-start . t)
       (ess-indent-with-fancy-comments)))
    (customize-set-variable 'ess-style 'OWN)
    (add-hook 'ess-mode-hook (lambda () (ess-set-style 'OWN))))

  ;; R --------------------------------------------------------------------------
  (with-eval-after-load 'ess-site
    ;; ESS
    (add-hook 'ess-mode-hook
              (lambda ()
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
           (define-key sh-mode-map "\C-c\C-n" 'pipe-line-to-shell-and-step)
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

;; essgd for plots inside emacs buffer. See
;; https://melpa.org/#/essgd
;; https://github.com/sje30/essgd
(defun ess/init-essgd ()
  "Initialize essgd package."
  (use-package essgd
    ;; Add any specific configuration or keybindings here
    ))

;; This was done to facilitate sending dev.off() to iESS when using
;; options(device = "cairo_pdf")
(defun ess-dev-off ()
  "Send dev.off() to the inferior R process."
  (interactive)
  (ess-eval-linewise "dev.off()"))

;; Preenchimento até 80 colunas em .qmd e .Rmd. As regras abaixo repetem as
;; de ~/git/ai-instructions/formata.el, e os dois precisam ficar iguais.

;; Começo de linha que o pandoc pode ler como marcador: lista (inclusive a de
;; exemplos, com @), citação, bloco de linhas, lista de definição ou título.
;; Inclui o código em linha seguido de . ou ), como `r k`.: quando o knitr
;; imprime um inteiro ou uma letra, a linha começa com 40. ou b), e dentro de um
;; item o pandoc abre ali uma sublista.
(defconst markdown-inicio-perigoso
  (concat "\\(?:@\\|(@\\|#\\|>\\|[|:]\\(?:[ \t]\\|$\\)"
          "\\|[-+*]\\(?:[ \t]\\|$\\)"
          "\\|(?[0-9]+[.)]\\(?:[ \t]\\|$\\)"
          "\\|(?[A-Za-z][.)]\\(?:[ \t]\\|$\\)"
          "\\|(?`r [^`]*`[.)]\\(?:[ \t]\\|$\\)\\)"))

(defun markdown-nao-quebra-p ()
  "Proíbe quebrar a linha logo depois de `r ou antes de um marcador.
O knitr só avalia o código em linha quando `r é seguido de espaço, e
não de quebra de linha. Os marcadores estão em
`markdown-inicio-perigoso'."
  (or (save-excursion
        (skip-chars-backward " \t")
        (and (>= (- (point) 2) (point-min))
             (string= (buffer-substring-no-properties (- (point) 2) (point))
                      "`r")))
      (save-excursion
        (skip-chars-forward " \t")
        (looking-at-p markdown-inicio-perigoso))))

;; Marcador de item de lista do pandoc, com os brancos que o seguem: -, + ou *;
;; número ou letra seguidos de . ou ), ou entre parênteses, como (a); ou (@) da
;; lista de exemplos. O markdown-mode só conhece -, +, * e 1., e o M-q juntava
;; num parágrafo só os itens (a), (b) e (c).
(defconst markdown-marcador-item
  (concat "[ \t]*\\(?:[-+*]\\|(?\\(?:[0-9]+\\|[A-Za-z]\\)[.)]"
          "\\|(@[A-Za-z0-9_-]*)\\)[ \t]+"))

;; Linha que não pertence a parágrafo algum: a que abre ou fecha matemática em
;; bloco ($$) ou um bloco cercado de código. Sem ela, o M-q juntava as linhas da
;; fórmula ao parágrafo.
(defconst markdown-linha-separa "[ \t]*\\(?:\\$\\$\\|```\\|~~~\\)")

(defun markdown-prefixo-item ()
  "Prefixo de preenchimento da linha, como o do markdown-mode.
Num item com um marcador que o markdown-mode não conhece, como (a), o
prefixo é o próprio marcador, que o preenchimento troca por brancos nas
linhas seguintes, como faz com o - de um item."
  (or (markdown-adaptive-fill-function)
      (and (looking-at markdown-marcador-item)
           (match-string-no-properties 0))))

(defun markdown-em-cifroes-p ()
  "Não nil se a linha do ponto pertence a matemática em bloco ($$).
Pertencem ao bloco as linhas que o abrem e o fecham. Como em
formata.el, o bloco abre numa linha que começa com $$ e fecha na
próxima linha que contém $$."
  (save-excursion
    (let ((alvo (line-beginning-position)) dentro)
      (goto-char (point-min))
      (while (< (point) alvo)
        (setq dentro (if dentro
                         (not (looking-at-p ".*\\$\\$"))
                       (and (looking-at-p "[ \t]*\\$\\$")
                            (not (looking-at-p
                                  "[ \t]*\\$\\$.*\\$\\$[ \t]*$")))))
        (forward-line 1))
      (or dentro (looking-at-p "[ \t]*\\$\\$")))))

(defun markdown-coluna-item ()
  "Coluna do texto do item de lista acima da linha do ponto, ou nil.
Sobe pelas linhas em branco e pelas recuadas até o item mais próximo.
Uma linha sem recuo que não é item encerra a lista, a não ser que
continue o parágrafo de cima, como em formata--segmentos."
  (save-excursion
    (let (col fim)
      (while (and (not fim) (= (forward-line -1) 0))
        (cond ((looking-at-p "[ \t]*$"))
              ((looking-at markdown-marcador-item)
               (setq col (- (match-end 0) (point)) fim t))
              ((looking-at-p "[ \t]"))
              ((or (bobp)
                   (looking-at-p paragraph-start)
                   (save-excursion
                     (forward-line -1)
                     (looking-at-p paragraph-separate)))
               (setq fim t))))
      col)))

(defun markdown-recuo-item ()
  "Recuo do parágrafo do ponto, se ele está recuado dentro de um item.
É o branco no início da primeira linha do parágrafo. Fora de um item,
ou com recuo de 4 ou mais além do texto do item (um bloco de código),
devolve nil."
  (save-excursion
    (end-of-line)
    (backward-paragraph)
    (while (and (not (eobp)) (looking-at-p paragraph-separate))
      (forward-line 1))
    (let ((recuo (current-indentation))
          (col (markdown-coluna-item)))
      (when (and (> recuo 0) col (< recuo (+ col 4)))
        (buffer-substring-no-properties
         (point) (progn (skip-chars-forward " \t") (point)))))))

(defun markdown-preenche-recuado (ini fim recuo justify)
  "Preenche entre INI e FIM o texto recuado em RECUO, como formata.el.
Isolado da lista, o texto recuado é um bloco de código para o
markdown-mode, que não o preenche. O recuo sai então de cada linha, o
texto é preenchido como markdown, com a largura reduzida na mesma
medida, e o recuo volta. JUSTIFY é o de `fill-paragraph'."
  (let* ((tira (format "\\`[ \t]\\{0,%d\\}" (length recuo)))
         (largura (- fill-column (length recuo)))
         (velho (buffer-substring-no-properties ini fim))
         (cheio (with-temp-buffer
                  (delay-mode-hooks (markdown-mode))
                  (add-hook 'fill-nobreak-predicate #'markdown-nao-quebra-p
                            nil t)
                  (setq-local adaptive-fill-function #'markdown-prefixo-item)
                  (setq fill-column largura)
                  (insert (mapconcat (lambda (s)
                                       (replace-regexp-in-string tira "" s))
                                     (split-string velho "\n") "\n"))
                  (goto-char (point-min))
                  (while (not (eobp))
                    (unless (looking-at-p "[ \t]*$")
                      (save-excursion (end-of-line) (fill-paragraph justify)))
                    (forward-line 1))
                  (buffer-string)))
         (novo (mapconcat (lambda (s) (if (string= s "") s (concat recuo s)))
                          (split-string cheio "\n") "\n")))
    (unless (string= novo velho)
      (replace-region-contents ini fim (lambda () novo)))))

(defun markdown-preenche (&optional justify)
  "M-q em texto markdown, com as regras de formata.el.
Em matemática em bloco ($$), não faz nada. O texto recuado dentro de um
item de lista, que `markdown-fill-paragraph' toma por bloco de código, é
preenchido por `markdown-preenche-recuado'. Fora disso,
`markdown-fill-paragraph'. JUSTIFY é o de `fill-paragraph'."
  (let (recuo)
    (cond ((markdown-em-cifroes-p)
           (message "M-q não age em matemática em bloco ($$)"))
          ((and (not (markdown-get-enclosing-fenced-block-construct))
                (not (save-excursion (beginning-of-line)
                                     (looking-at-p "[ \t]*$")))
                (setq recuo (markdown-recuo-item)))
           (save-excursion
             (end-of-line)
             (let* ((fim (progn (forward-paragraph) (point)))
                    (ini (progn (backward-paragraph)
                                (while (and (< (point) fim)
                                            (looking-at-p paragraph-separate))
                                  (forward-line 1))
                                (point))))
               (markdown-preenche-recuado ini fim recuo justify))))
          (t (markdown-fill-paragraph justify))))
  t)

(defun markdown-regras-de-lista ()
  "Aplica no buffer markdown as regras de lista de formata.el.
Cada item, inclusive (a), é um parágrafo; as linhas de $$ e as cercas de
código separam parágrafos; e o M-q é `markdown-preenche'."
  (setq-local paragraph-start
              (concat paragraph-start "\\|" markdown-linha-separa
                      "\\|" markdown-marcador-item))
  (setq-local paragraph-separate
              (concat paragraph-separate "\\|" markdown-linha-separa))
  (setq-local adaptive-fill-function #'markdown-prefixo-item)
  (setq-local fill-paragraph-function #'markdown-preenche))

(defun preenche-legenda ()
  "Preenche a legenda YAML dobrada (#| fig-cap: >-) em volta do ponto.
Mantém o prefixo \"#|\" com o recuo YAML; sem o recuo, o YAML fica
inválido e o knitr para."
  (interactive)
  (let ((re "^\\(#|[ \t][ \t]+\\)[^ \t\n]") ini fim pref)
    (save-excursion
      (beginning-of-line)
      (unless (looking-at re)
        (user-error "Fora de uma legenda recuada"))
      (while (and (not (bobp))
                  (save-excursion (forward-line -1) (looking-at-p re)))
        (forward-line -1))
      (looking-at re)
      (setq ini (point) pref (match-string 1))
      (while (looking-at-p re) (forward-line 1))
      (setq fim (point))
      (let ((fill-prefix pref)
            (fill-column 80)
            (sentence-end-double-space nil))
        (fill-region-as-paragraph ini fim)))))

(defun preenche-ou-padrao (&optional arg)
  "M-q em buffers R.
Numa linha de texto de legenda recuada (#|   texto), `preenche-legenda'.
Numa linha de opção (#| echo: false, #| fig-cap: >-), não faz nada: o
comando padrão trata as linhas #| seguidas como um comentário só, junta
as opções numa linha e invalida o YAML. Fora delas,
`prog-fill-reindent-defun'."
  (interactive "P")
  (let ((linha (save-excursion
                 (beginning-of-line)
                 (cond ((looking-at-p "#|[ \t][ \t]+[^ \t\n]") 'legenda)
                       ((looking-at-p "[ \t]*#|") 'opcao)))))
    (pcase linha
      ('legenda (preenche-legenda))
      ('opcao (message "M-q não age em linhas de opção #|"))
      (_ (prog-fill-reindent-defun arg)))))

;; Set keybindings
(defun ess/post-init-ess ()
  ;; R source buffers: C-. to dev.off()
  (with-eval-after-load 'ess-r-mode
    (define-key ess-r-mode-map (kbd "C-.") #'ess-dev-off)
    ;; M-q que preserva o recuo das legendas #|
    (define-key ess-r-mode-map (kbd "M-q") #'preenche-ou-padrao))

  ;; Texto de .qmd, .Rmd e .md: não quebra a linha depois de `r nem antes de
  ;; um marcador do pandoc, e o M-q segue as regras de lista de formata.el
  (add-hook 'markdown-mode-hook
            (lambda ()
              (add-hook 'fill-nobreak-predicate #'markdown-nao-quebra-p
                        nil t)
              (markdown-regras-de-lista)))

  ;; iESS (*R* REPL) – bind when the mode starts, no map needed at compile time
  (add-hook 'inferior-ess-r-mode-hook
            (lambda ()
              (local-set-key (kbd "C-.") #'ess-dev-off)))

  ;; Markdown / Rmarkdown
  (add-hook 'markdown-mode-hook
            (lambda ()
              (local-set-key (kbd "C-.") #'ess-dev-off)))

  ;; Polymode host for Rmarkdown/Quarto
  (add-hook 'poly-markdown+r-mode-hook
            (lambda ()
              (local-set-key (kbd "C-.") #'ess-dev-off)))

  ;; Quarto major mode
  (add-hook 'quarto-mode-hook
            (lambda ()
              (local-set-key (kbd "C-.") #'ess-dev-off)))

  ;; --- Bind C-c C-p ONLY inside R code chunks ---
  ;; This was done to avoid the cursor stepping out from a code chunk to the
  ;; text in quarto/Rmarkdown files
  ;; Polymode inner R mode (most common)
  (add-hook 'poly-r-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c C-p") #'ess-eval-paragraph)))

  ;; Older polymode ESS inner mode
  (add-hook 'poly-ess-r-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c C-p") #'ess-eval-paragraph)))

  ;; Fallback: indirect ESS R buffer inside polymode
  ;; (safe to include; triggers only in R chunk buffers)
  (add-hook 'ess-r-mode-hook
            (lambda ()
              (when (bound-and-true-p polymode-mode)
                (local-set-key (kbd "C-c C-p") #'ess-eval-paragraph))))
  )
