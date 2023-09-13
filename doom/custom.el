(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-insert-braces nil)
 '(font-latex-math-environments
   '("display" "displaymath" "equation" "eqnarray" "gather" "multline" "align" "alignat" "xalignat" "dmath"))
 '(safe-local-variable-values
   '((org-roam-db-location . "~/dynAlgLab/org-roam.db")
     (org-roam-directory . "~/dynAlgLab/")))
 '(warning-suppress-types '((doom-after-init-hook) (defvaralias)))
 '(org-html-head-include-default-style nil)
 '(org-publish-use-timestamps-flag nil)
 '(org-html-metadata-timestamp-format "%Y-%m-%d")
 ; '(org-display-custom-times t)
 ; '(org-time-stamp-custom-formats (quote ("<%d>" . "<%d %m %Y--- [%H:%M]>")))
 ; '(org-time-stamp-formats (quote ("<%d>" . "<%d %m %Y--- [%H:%M]>")))
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(org-link-set-parameters "doc"
                         :export #'org-doc-export
                         )

(defun org-doc-export (link description format _)
  "Export a doc page link from Org files."
  (let ((path (format "%s" link))
        (desc (or description link)))
    (pcase format
      (`html (format "<a href=\"/files/%s\">%s</a>" path desc))
      (t path))))

(setq org-publish-project-alist
      '(("orgfiles"
         :base-directory "~/arsricharan.in"
         :base-extension "org"
         :publishing-directory "~/arsricharan.in/public"
         :publishing-function org-html-publish-to-html
         :exclude "home/*"
         :recursive t
         :html-doctype "html5"
         ; :html-postamble "<hr style=\"border-top: 1px;\"><p>%C</p>"
         :html-postamble nil
         :html-head-include-default-style nil
         :with-toc nil
         :with-title nil
         :with-author nil
         :section-numbers nil
         :html-head "<link rel=\"icon\" type=\"image/x-icon\" href=\"/favicon.ico\"> <link rel=\"stylesheet\" href=\"/style.css\" />"
         :html-preamble "<div id=\"navbar\">
    <a href=\"/\"><div class=\"navitem home\">&heartsuit;</div></a>
    <a href=\"/pubs\"><div class=\"navitem\">pubs</div></a>
    <a href=\"/blog\"><div class=\"navitem\">blog</div></a>
    <a href=\"/meta\"><div class=\"navitem\">meta</div></a>
    <a href=\"/files/Sricharan_AR_CV.pdf\"><div class=\"navitem\">cv</div></a>
</div> <hr>
"
         )

        ("other"
         :base-directory "~/arsricharan.in"
         :base-extension "ico\\|css\\|ttf\\|woff2\\|woff\\|jpg\\|png\\|pdf\\|toml"
         :publishing-directory "~/arsricharan.in/public"
         :exclude "~/arsricharan.in/public/*"
         :recursive t
         :publishing-function org-publish-attachment)

        ("website" :components ("orgfiles" "other"))

        ("eflows"
        :base-directory "~/Study/Writeups/eflows"
        :publishing-directory "~/Study/Writeups/eflows"
        :publishing-function org-latex-publish-to-pdf
        )

        ))

(defun my-yas-try-expanding-auto-snippets ()
  (when yas-minor-mode
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))
(add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)
