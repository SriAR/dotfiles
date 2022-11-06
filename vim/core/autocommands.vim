" Delete trailing whitespace before saving
autocmd BufWritePre * %s/\s\+$//e

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


