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
 '(warning-suppress-types '((doom-after-init-hook) (defvaralias))))
 '(org-html-head-include-default-style nil)
 '(org-publish-use-timestamps-flag nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq org-publish-project-alist
      '(("orgfiles"
         :base-directory "~/newsite"
         :base-extension "org"
         :publishing-directory "~/public"
         :publishing-function org-html-publish-to-html
         :exclude "home/*"
         :recursive t
         :html-doctype "html5"
         :html-postamble "<hr style=\"border-top: 1px;\"><p>%C</p>"
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
<div class=\"sidebar\">
    <img src=\"/files/narcissism.jpg\" alt=\"me.jpg\" />
    <span class=\"sbitem\"><a href=\"mailto:arsricharan@cmi.ac.in\">Email</a></span>
    <span class=\"sbitem\"><a href=\"https://github.com/SriAR\">Github</a></span>
    <span class=\"sbitem\"><a href=\"https://twitter.com/ratheritslimit\">Twitter</a></span>
    <span class=\"sbitem\"><a href=\"https://scholar.google.com/citations?hl=en&user=wNnXe84AAAAJ\">Google Scholar</a></span>
</div>"
         )

        ("other"
         :base-directory "~/newsite"
         :base-extension "ico\\|css\\|ttf\\|woff2\\|woff\\|jpg\\|png\\|pdf"
         :publishing-directory "~/public"
         :recursive t
         :publishing-function org-publish-attachment)

        ("website" :components ("orgfiles" "other"))

        ("eflows"
        :base-directory "~/Study/Writeups/eflows"
        :publishing-directory "~/Study/Writeups/eflows"
        :publishing-function org-latex-publish-to-pdf
        )

        ))
