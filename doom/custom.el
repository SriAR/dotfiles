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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'org-publish-project-alist
         '("Electrical Flows"
        :base-directory "~/Study/Writeups/Electrical Flows"
        :publishing-directory "~/Study/Writeups/Electrical Flows"
        :publishing-function org-latex-publish-to-pdf
        :body-only t
        :makeindex t
        ))
