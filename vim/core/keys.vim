" vim-leader-guide
let g:lmap = {}
call leaderGuide#register_prefix_descriptions(",", "g:lmap")


" Set leaders
let mapleader = ","
let maplocalleader = "\\"

" Pressing ,ss will toggle and untoggle spell checking
noremap <leader>ss :setlocal spell!<cr> :echo &spell<cr>

" Shortcuts using <leader>
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=

" Prepending/Appending in Insert mode
inoremap <C-l> <C-o>A
inoremap <C-h> <C-o>I

"Linewise scrolling in Insert mode
inoremap <C-e> <C-o><C-e>
inoremap <C-y> <C-o><C-y>

" Editing the vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
let g:lmap.e = {'name': 'Edit Vimrc'}

" Better movement between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move to next visual line rather than next actual line
vnoremap j gj
vnoremap k gk
nnoremap j gj
nnoremap k gk

" Copy pasting from system clipboard. Needs +clipboard (gvim/nvim)
vnoremap <C-c> "+y
nnoremap <C-v> "+p

" :W sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Enter visual block mode. The usual command is overriden by paste
command! Vb normal! <C-v>

" Add empty lines above and below
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Writing/Quitting macros
inoremap <leader>wq <Esc>:wq<CR>
nnoremap <leader>wq :wq<CR>
inoremap <leader><leader> <Esc>m`:w<CR>``a
nnoremap <leader><leader> :w<CR>
nnoremap <leader>q :q<CR>

