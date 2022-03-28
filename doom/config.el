;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sricharan AR"
      user-mail-address "arsricharan1999@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq org-roam-directory "~/roam/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq evil-want-fine-undo t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; small font size in helm child frames
(setq +helm-posframe-text-scale 0)

;; Need this to unfuck bufler
(use-package! map)

;; make helm behave more like ivy while working with directories
(after! helm
  ;; make backspace go up a level
  (add-hook! 'helm-find-files-after-init-hook
    (map! :map helm-find-files-map
          "<DEL>" #'helm-find-files-up-one-level)))

(use-package! company
  :config (setq
           company-idle-delay 0.7))

;; snippets
(use-package! doom-snippets
  :after yasnippet)

;; set custom variables
(setq
 org_notes (concat (getenv "HOME") "/org/")
 pubs_bib (concat (getenv "HOME") "/texmf/bibtex/bib/GlobalRef.bib")
 org-directory org_notes
 deft-directory org_notes
 )

;; keybinds
(use-package! general)
;; Creating a constant for making future changes simpler
(defconst my-leader "SPC")
;; Tell general all about it
(general-create-definer my-leader-def
  :prefix my-leader)

;; I like short names
(general-evil-setup t)
;; Stop telling me things begin with non-prefix keys
(general-auto-unbind-keys)

(after! org (map! :localleader
      :map org-mode-map
      :desc "Eval Block" "e" 'ober-eval-block-in-repl
      (:prefix "o"
        :desc "Tags" "t" 'org-set-tags
        :desc "Roam Bibtex" "b" 'orb-note-actions
        :desc "Latex Preview" "l" 'org-latex-preview
        (:prefix ("p" . "Properties")
          :desc "Set" "s" 'org-set-property
          :desc "Delete" "d" 'org-delete-property
          :desc "Actions" "a" 'org-property-action
          )
        )
      (:prefix ("i" . "Insert")
       :desc "Link/Image" "l" 'org-insert-link
       :desc "Item" "o" 'org-toggle-item
       :desc "Citation" "c" 'org-ref-insert-cite-link
       :desc "Footnote" "f" 'org-footnote-action
       :desc "Table" "t" 'org-table-create-or-convert-from-region
       :desc "Screenshot" "s" 'org-download-screenshot
       (:prefix ("b" . "Math")
        :desc "Bold" "f" 'org-make-bold-math
        :desc "Blackboard" "b" 'org-make-blackboard-math
        :desc "Vert" "v" 'org-make-vert-math
        )
       (:prefix ("h" . "Headings")
        :desc "Normal" "h" 'org-insert-heading
        :desc "Todo" "t" 'org-insert-todo-heading
        (:prefix ("s" . "Subheadings")
         :desc "Normal" "s" 'org-insert-subheading
         :desc "Todo" "t" 'org-insert-todo-subheading
         )
        )
       (:prefix ("e" . "Exports")
        :desc "Dispatch" "d" 'org-export-dispatch
        )
       )
      (:prefix "m"
       :desc "Roam Add Alias" "a" 'org-roam-alias-add
       :desc "Roam Add Tag" "t" 'org-roam-tag-add)
      )
  )

;; add custom latex environments
(add-hook 'LaTeX-mode-hook 'add-my-latex-environments)
(defun add-my-latex-environments ()
  (LaTeX-add-environments
   '("thm" LaTeX-env-label)
   '("prop" LaTeX-env-label)
   '("lem" LaTeX-env-label)
   '("cor" LaTeX-env-label)
   '("defn" LaTeX-env-label)
   '("not" LaTeX-env-label)
   '("rem" LaTeX-env-label)
   '("ex" LaTeX-env-label)
   '("align" LaTeX-env-label)
   '("notation" LaTeX-env-label)
   '("dmath" LaTeX-env-label)
   ))

;; Code I added to make syntax highlighting work in Auctex

(custom-set-variables
 '(font-latex-math-environments (quote
                                 ("display" "displaymath" "equation" "eqnarray" "gather" "multline"
                                  "align" "alignat" "xalignat" "dmath")))
 '(TeX-insert-braces nil)) ;;Stops putting {} on argumentless commands to "save" whitespace

;; Additionally, reftex code to recognize this environment as an equation
(setq reftex-label-alist
      '(("dmath" ?e nil nil t)))

;; note setup, due to haozeke
;; org-ref handles links and references in org-mode
(use-package! org-ref
  ;; :init
                                        ; code to run before loading org-ref
  :config
  (setq
   org-ref-completion-library 'org-ref-ivy-cite
   org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
   org-ref-default-bibliography (list (concat (getenv "HOME") "/texmf/bibtex/bib/GlobalRef.bib"))
   org-ref-bibliography-notes (concat (getenv "HOME") "/org/bibnotes.org")
   org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
         org-ref-notes-directory (concat (getenv "HOME") "/org/")
         org-ref-notes-function 'orb-edit-notes
         ))

;; set up helm-bibtex
(after! org-ref
  (setq
   bibtex-completion-notes-path org_notes
   bibtex-completion-bibliography pubs_bib
   bibtex-completion-pdf-field "file"
   bibtex-completion-notes-template-multiple-files
   (concat
    "#+TITLE: ${title}\n"
    "#+ROAM_KEY: cite:${=key=}\n"
    "#+ROAM_TAGS: ${keywords}\n"
    "* TODO Notes\n"
    ":PROPERTIES:\n"
    ":Custom_ID: ${=key=}\n"
    ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
    ":AUTHOR: ${author-abbrev}\n"
    ":JOURNAL: ${journaltitle}\n"
    ":DATE: ${date}\n"
    ":YEAR: ${year}\n"
    ":DOI: ${doi}\n"
    ":URL: ${url}\n"
    ":END:\n\n"
    )
   )
  )

;; org-roam-bibtex
(use-package! org-roam-bibtex
  :after (org-roam)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq org-roam-bibtex-preformat-keywords
   '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${citekey}"
           :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}
- tags ::
- keywords :: ${keywords}

* Notes
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:NOTER_DOCUMENT: ${file}
:NOTER_PAGE:
:END:"))))

;; This is to use pdf-tools instead of doc-viewer
(use-package! pdf-tools
  :config
  ;;(pdf-tools-install)
  ;; This means that pdfs are fitted to width by default when you open them
  (setq-default pdf-view-display-size 'fit-width)
  :custom
  (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

;; Org-noter setup
(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; Split inside emacs, helps maintain consistency on OSs without a tiling WM
   ;; TODO Could set this to be 'other-frame on linux with TWM only
   org-noter-notes-window-location 'horizontal-split
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list org_notes)
   )
  )

(map! :localleader
      :map (org-mode-map pdf-view-mode-map)
      (:prefix ("o" . "Org")
        (:prefix ("n" . "Noter")
         :desc "Noter" "n" 'org-noter
         :desc "Kill noter session" "k" 'org-noter-kill-session
          )))

(after! pdf-view
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-width)
  ;;(add-hook! 'pdf-view-mode-hook (evil-mode -1))
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t
        pdf-view-resize-factor 1.1)
   ;; faster motion
 (map!
   :map pdf-view-mode-map
   :n "g g"          #'pdf-view-first-page
   :n "G"            #'pdf-view-last-page
   :n "N"            #'pdf-view-next-page-command
   :n "E"            #'pdf-view-previous-page-command
   :n "e"            #'evil-collection-pdf-view-previous-line-or-previous-page
   :n "n"            #'evil-collection-pdf-view-next-line-or-next-page
   :localleader
   (:prefix "o"
    (:prefix "n"
     :desc "Insert" "i" 'org-noter-insert-note
     ))
 ))


;; platformio mode config stuff
(use-package! platformio-mode
  :hook (c++-mode-hook . (lambda () (lsp-deferred) (platformio-conditionally-enable))))
