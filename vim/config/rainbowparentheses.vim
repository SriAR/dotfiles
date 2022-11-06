" " Activate
" :RainbowParentheses
"
" " Deactivate
" :RainbowParentheses!
"
" " Toggle
" :RainbowParentheses!!
"
" " See the enabled colors
" :RainbowParenthesesColors

" Activation based on file type
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']']]

" List of colors that you do not want. ANSI code or #RRGGBB
let g:rainbow#blacklist = [233, 234]
